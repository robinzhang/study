#import "Kaixin.h"
#import "KaixinLoginDialog.h"
#import "KaixinRequest.h"
#import <CommonCrypto/CommonDigest.h>


static NSString* kDialogBaseURL = @"https://api.kaixin001.com/oauth2/";
static NSString* kLogin = @"authorize";
static NSString* kRefreshTokenPath = @"access_token";

///////////////////////////////////////////////////////////////////////////////////////////////////

@interface Kaixin ()

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Kaixin

@synthesize accessToken = _accessToken,
            refreshToken = _refreshToken,
         expirationDate = _expirationDate,
        sessionDelegate = _sessionDelegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

 
- (id)initWithAppId:(NSString *)app_id reDirectURL:(NSString *)kRedirectURL secretKey:(NSString *) key{
  self = [super init];
  if (self) {
    [_appId release];
    _appId = [app_id copy];
	[_kRedirectURL release];
	_kRedirectURL = [kRedirectURL copy];
	  [_secretKey release];
	  _secretKey = [key copy];
  }
  return self;
}

/**
 * Override NSObject : free the space
 */
- (void)dealloc {
  [_accessToken release];
  [_refreshToken release];
  [_expirationDate release];
  [_request release];
  [_loginDialog release];
  [_KaixinDialog release];
  [_appId release];
  [_kRedirectURL release];
  [_secretKey release];
  [super dealloc];
}

/**
 * A private helper function for sending HTTP requests.
 *
 * @param url
 *            url to send http request
 * @param params
 *            parameters to append to the url
 * @param httpMethod
 *            http method @"GET" or @"POST"
 * @param delegate
 *            Callback interface for notifying the calling application when
 *            the request has received response
 */
- (KaixinRequest*)openUrl:(NSString *)url
               params:(NSMutableDictionary *)params
           httpMethod:(NSString *)httpMethod
             delegate:(id<KaixinRequestDelegate>)delegate {

  
  [_request release];
  _request = [[KaixinRequest getRequestWithParams:params
                                   httpMethod:httpMethod
                                     delegate:delegate
                                   requestURL:url] retain];
  [_request connect];
  return _request;
}



/**
 * save login information
 */
-(void)createUserSessionInfo{
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];	
	if (self.accessToken) {
		[defaults setObject:self.accessToken forKey:@"access_Token"];
	}
	if (self.refreshToken) {
		[defaults setObject:self.refreshToken forKey:@"refresh_Token"];
	}    
	if (self.expirationDate) {
		[defaults setObject:self.expirationDate forKey:@"expiration_Date"];
	}
	[defaults synchronize];	
    
}

/**
 * delete saved information 
 */
-(void)delUserSessionInfo{
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"access_Token"];
    [defaults removeObjectForKey:@"refresh_Token"];   
	[defaults removeObjectForKey:@"expiration_Date"];
    [defaults synchronize];
}


/**
 * A private function for opening the authorization dialog.
 */
- (void)authorizeWithKXAppAuth:(BOOL)tryKXAppAuth
                    safariAuth:(BOOL)trySafariAuth {
  NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _appId, @"client_id",
                                 @"token", @"response_type",
                                 _kRedirectURL, @"redirect_uri",
                                 @"touch", @"display",
                                 @"basic", @"scope",//要多权限时，以%20串联各个权限标记，例如：“basic%20friends_records”
                                 @"1", @"oauth_client",
                                 nil];
  NSString *loginDialogURL = [kDialogBaseURL stringByAppendingString:kLogin];
  
  [_loginDialog release];
  _loginDialog = [[KaixinLoginDialog alloc] initWithURL:loginDialogURL
                                          loginParams:params
                                             delegate:self];
  [_loginDialog show];
  
}

/**
 * Getting a new access_token by the refresh_token when current access_token out of date.
 */

- (KaixinRequest*)requestByRefreshTokenHttpMethod:(NSString *) StrHttpMethod
                             andDelegate:(id <KaixinRequestDelegate>)delegate{	
    
    self.accessToken = nil;
    
    if ((self.refreshToken == (NSString *) [NSNull null]) || (self.refreshToken.length == 0)) {
        return nil;
    }
    
    NSString *getRefreshTokenURL = [kDialogBaseURL stringByAppendingString:kRefreshTokenPath];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"refresh_token", @"grant_type",
                                   _refreshToken, @"refresh_token",
                                   _appId, @"client_id",
                                   _secretKey, @"client_secret",
                                   nil];
    
	return [self openUrl:getRefreshTokenURL
				  params:params
			  httpMethod:StrHttpMethod
				delegate:delegate];
}



/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
    [[kv objectAtIndex:1]
     stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
  return params;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//public

- (void)authorizeDelegate:(id<KaixinSessionDelegate>)delegate
{
    _sessionDelegate = delegate;
    
    [self authorizeWithKXAppAuth:NO safariAuth:NO];
}


- (void)logout:(id<KaixinSessionDelegate>)delegate {

  _sessionDelegate = delegate;

  [_accessToken release];
  _accessToken = nil;
  [_refreshToken release];
    _refreshToken = nil;   
  [_expirationDate release];
  _expirationDate = nil;

	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* KaixinCookies = [cookies cookiesForURL:
							  [NSURL URLWithString:kDialogBaseURL]];
	
	for (NSHTTPCookie* cookie in KaixinCookies) {
		[cookies deleteCookie:cookie];
	}

    
  if ([self.sessionDelegate respondsToSelector:@selector(KaixinDidLogout)]) {
    [_sessionDelegate KaixinDidLogout];
  }
	
  [self delUserSessionInfo];
	
}


- (NSString*)generateCallId {
	return [NSString stringWithFormat:@"%.2f", [[NSDate date] timeIntervalSince1970]];
}


- (KaixinRequest*)requestWithSeparateURL:(NSString*) requestURL 
                           andHttpMethod:(NSString *) StrHttpMethod
                             andDelegate:(id <KaixinRequestDelegate>)delegate{	
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                 self.accessToken, @"access_token", 
                                 nil];

	return [self openUrl:requestURL
				  params:params
			  httpMethod:StrHttpMethod
				delegate:delegate];
}


- (void)dialog:(NSString *)action
   andDelegate:(id<KaixinDialogDelegate>)delegate {
  NSMutableDictionary * params = [NSMutableDictionary dictionary];
  [self dialog:action andParams:params andDelegate:delegate];
}

- (void)dialog:(NSString *)action
     andParams:(NSMutableDictionary *)params
   andDelegate:(id <KaixinDialogDelegate>)delegate {

  [_KaixinDialog release];

  NSString *dialogURL = [kDialogBaseURL stringByAppendingString:action];
  [params setObject:@"touch" forKey:@"display"];
  [params setObject:_kRedirectURL forKey:@"redirect_uri"];
//    [params setObject:@"1" forKey:@"oauth_client"];
  if (action == kLogin) {
    _KaixinDialog = [[KaixinLoginDialog alloc] initWithURL:dialogURL loginParams:params delegate:self];
  } else {
    [params setObject:_appId forKey:@"app_id"];
    if ([self isSessionValid]) {
      [params setValue:[self.accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                forKey:@"access_token"];
    }
    _KaixinDialog = [[KaixinDialog alloc] initWithURL:dialogURL params:params delegate:delegate];
  }

  [_KaixinDialog show];
}


- (BOOL)isSessionValid {
  return (self.accessToken != nil && self.expirationDate != nil
           && NSOrderedDescending == [self.expirationDate compare:[NSDate date]]);

}

- (void)KaixinDialogLogin:(NSString *)token 
             refreshToken:(NSString *)refresh_token 
           expirationDate:(NSDate *)expirationDate {
    self.accessToken = token;
    self.refreshToken = refresh_token;
    self.expirationDate = expirationDate;
    if ([self.sessionDelegate respondsToSelector:@selector(KaixinDidLogin)]) {
        [_sessionDelegate KaixinDidLogin];
    }
	[_KaixinDialog dismissWithSuccess:YES animated:NO];
    [self createUserSessionInfo];	
    
}


- (void)KaixinDialogNotLogin:(BOOL)cancelled {
  if ([self.sessionDelegate respondsToSelector:@selector(KaixinDidNotLogin:)]) {
    [_sessionDelegate KaixinDidNotLogin:cancelled];
  }
}


- (void)request:(KaixinRequest*)request didFailWithError:(NSError*)error{
  NSLog(@"Failed to expire the session");
}


@end

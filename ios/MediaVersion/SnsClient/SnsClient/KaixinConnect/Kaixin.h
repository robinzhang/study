#import "KaixinLoginDialog.h"
#import "KaixinRequest.h"

@protocol KaixinSessionDelegate;

@interface Kaixin : NSObject<KaixinLoginDialogDelegate>{
  NSString* _accessToken;
  NSString* _refreshToken;
  NSDate* _expirationDate;
  id<KaixinSessionDelegate> _sessionDelegate;
  KaixinRequest* _request;
  KaixinDialog* _loginDialog;
  KaixinDialog* _KaixinDialog;
  NSString* _appId;
  NSString* _kRedirectURL;
  NSString* _secretKey;
}

@property(nonatomic, copy) NSString* accessToken;
@property(nonatomic, copy) NSString* refreshToken;
@property(nonatomic, copy) NSDate* expirationDate;
@property(nonatomic, assign) id<KaixinSessionDelegate> sessionDelegate;

- (id)initWithAppId:(NSString *)app_id reDirectURL:(NSString *)kRedirectURL secretKey:(NSString *)key;

- (void)authorizeDelegate:(id<KaixinSessionDelegate>)delegate;

- (void)logout:(id<KaixinSessionDelegate>)delegate;

- (KaixinRequest*)requestWithSeparateURL:(NSString*) requestURL 
                  andHttpMethod:(NSString *) StrHttpMethod
                  andDelegate:(id <KaixinRequestDelegate>)delegate;

- (KaixinRequest*)requestByRefreshTokenHttpMethod:(NSString *) StrHttpMethod
                                      andDelegate:(id <KaixinRequestDelegate>)delegate;


- (void)dialog:(NSString *)action
   andDelegate:(id<KaixinDialogDelegate>)delegate;

- (void)dialog:(NSString *)action
     andParams:(NSMutableDictionary *)params
   andDelegate:(id <KaixinDialogDelegate>)delegate;

- (BOOL)isSessionValid;

@end

////////////////////////////////////////////////////////////////////////////////

/**
 * Your application should implement this delegate to receive session callbacks.
 */
@protocol KaixinSessionDelegate <NSObject>

@optional

/**
 * Called when the user successfully logged in.
 */
- (void)KaixinDidLogin;

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)KaixinDidNotLogin:(BOOL)cancelled;

/**
 * Called when the user logged out.
 */
- (void)KaixinDidLogout;

@end

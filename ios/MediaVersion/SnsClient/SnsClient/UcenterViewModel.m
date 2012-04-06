//
//  UcenterViewModel.m
//  SnsClient
//
//  Created by  on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


#import "UcenterViewModel.h"
#import "UserHelper.h"

@implementation UcenterViewModel
@synthesize profie = _profie;
@synthesize userid = _userid;

-(id)initWithUserId:(NSString*)userid
{
    if (self = [super init]) {
        self.userid = userid;
        _profie = [[UserProfile alloc] init];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
   // TT_RELEASE_SAFELY(_userid);
   // TT_RELEASE_SAFELY(_profie);
    [super dealloc];
}

-(void)clearCache:(NSString*)userid
{
     NSString* url = [NSString stringWithFormat:URLUserProfile,KApi_Domain,_userid];
     NSString* key = [[TTURLCache sharedCache] keyForURL:url];
     [[TTURLCache sharedCache] removeKey:key];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (!self.isLoading ) {
        //_profie.UserID = @"";
       
        NSString* url = [NSString stringWithFormat:URLUserProfile,KApi_Domain,_userid];
        
        //NSLog(@"user frofile data request:%@",url);
        
        TTURLRequest* request = [TTURLRequest
                                 requestWithURL: url
                                 delegate: self];
        //if(!cachePolicy)
        //    cachePolicy = TTURLRequestCachePolicyDefault;
        
        request.cachePolicy =  TTURLRequestCachePolicyNoCache;
        
        [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
        [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
        [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        [UserHelper DegBugWidthLog:url title:@"uprofile"];
        [request send];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
       
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    NSDictionary* result = response.rootObject;
    NSDictionary* resultent = [result objectForKey:@"GetStrUserResult"];
    BOOL Success = [[resultent objectForKey:@"Success"] boolValue];
    if(resultent != nil && Success)
    {
        _profie.UserID = _userid;
        _profie.UserName = [resultent objectForKey:@"Name"];
        _profie.Email = [resultent objectForKey:@"Email"];
        _profie.UserFace = [resultent objectForKey:@"UserFace"];
        
        if(!TTIsStringWithAnyText([resultent objectForKey:@"Introduction"]))
            _profie.Intro = @"";
        else
            _profie.Intro = [resultent objectForKey:@"Introduction"];
        _profie.FriendCount = [[resultent objectForKey:@"TLikeCount"] intValue];
        _profie.FansCount = [[resultent objectForKey:@"TFansCount"] intValue];
        _profie.FollowerCount = [[resultent objectForKey:@"TFollowCount"] intValue];
        _profie.MessageCount = [[resultent objectForKey:@"TMessageCount"] intValue];
        _profie.UserType = [[resultent objectForKey:@"AccountType"] intValue];
        
        [UserHelper SetUserProfile:_profie];
    }
    else
    {
        _profie = [UserHelper GetUserProfile:self.userid]; 
        if(!_profie)
            _profie = [[UserProfile alloc] init];

    }
    
    [super requestDidFinishLoad:request];
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    if( [UserHelper GetUserProfile:self.userid])
    {
        _profie = [UserHelper GetUserProfile:self.userid];
        if(!_profie)
            _profie = [[UserProfile alloc] init];

    }
    [super request:request didFailLoadWithError:error];
}
@end

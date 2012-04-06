//
//  VersionChecker.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "VersionChecker.h"

@implementation VersionChecker
VersionChecker *shareVersionChecker;
+ (VersionChecker*)sharedInstance
{
    if(shareVersionChecker == nil)
    {
        shareVersionChecker = [[VersionChecker alloc] init];        
    }
    return shareVersionChecker;
}
- (void)cancel {
    [_loadingRequest cancel];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return !!_loadingRequest;
}
-(void)CheckVersionUpdate
{
    if(![self isLoading])
    {
    NSString *url = [NSString stringWithFormat:URLVersionChecker,KApi_Domain,KAppKValue];
    TTURLRequest *request = [TTURLRequest
                             requestWithURL:url
                             delegate: self];
    
    [request setUserInfo:@"URLVersionChecker"];
    
    //sec
    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    //end sec
    
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [UserHelper DegBugWidthLog:url title:@"URLVersionChecker"];
    [request send];
    }
}

- (void)requestDidStartLoad:(TTURLRequest*)request
{
    [_loadingRequest release];
    _loadingRequest = [request retain];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request
{
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    float resultent = [[response.rootObject objectForKey:@"GetViersionResult"] floatValue]; 
    
    SnUserAppInfo *uifo = [UserHelper GetUserAppInfo];
    if(resultent > uifo.LastVesion)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:[NSString stringWithFormat:@"程序有新版本%0.1f 可用，是否立即下载更新？",resultent] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
    }
    TT_RELEASE_SAFELY(_loadingRequest);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString *url = @"http://itunes.apple.com/cn/app/id479497594?ls=1&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
     TT_RELEASE_SAFELY(_loadingRequest);
     [UserHelper DegBugWidthLog:[error localizedDescription] title:@"URLVersionChecker Error"];
}

- (void)requestDidCancelLoad:(TTURLRequest*)request
{
    TT_RELEASE_SAFELY(_loadingRequest);
}

-(void)dealloc
{
    if(_loadingRequest && [_loadingRequest isLoading])
        [_loadingRequest cancel];
    if(_loadingRequest)
        TT_RELEASE_SAFELY(_loadingRequest);
    [super dealloc];
}
@end

//
//  SnNotificationDataKeyHelper.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnNotificationDataKeyHelper.h"
@implementation SnNotificationDataKeyHelper
SnNotificationDataKeyHelper *shareSnNotificationDataKeyHelper;
+ (SnNotificationDataKeyHelper*)sharedInstance
{
    if(shareSnNotificationDataKeyHelper == nil)
    {
        shareSnNotificationDataKeyHelper = [[SnNotificationDataKeyHelper alloc] init];        
    }
    return shareSnNotificationDataKeyHelper;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}


- (void)StartUpdateNotification{
    if (loopTimer && [loopTimer isKindOfClass:[NSTimer class]] && loopTimer.isValid) {
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:KPMSessionTimerInterval];    
        [loopTimer setFireDate:fireDate];
    }else{
        loopTimer=[NSTimer scheduledTimerWithTimeInterval:KPMSessionTimerInterval target:self selector:@selector(UpdateNotification) userInfo:nil repeats:NO];
    }
}


- (void)releaseTimer{
    if (loopTimer && [loopTimer isKindOfClass:[NSTimer class]]) {
        TT_INVALIDATE_TIMER(loopTimer);
    }
}



-(void)StopUpdateNotification
{
    [self releaseTimer];
    if([self isLoading])
        [_loadingRequest cancel];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return !!_loadingRequest;
}

-(void)ClearCommentCount
{
    if(![self isLoading])
    {
        NSString *uid = [UserHelper GetUserID];
        if(!TTIsStringWithAnyText(uid))
            return;
        
        NSString* url = [NSString stringWithFormat:URLUpdateUserNotifications,KApi_Domain,uid,10];
        TTURLRequest* _request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
        _request.cachePolicy = TTURLRequestCachePolicyNoCache;
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        _request.response = response;
        _request.userInfo = @"clear3";
        TT_RELEASE_SAFELY(response);
        [_request send];
    
        [UserHelper DegBugWidthLog:url title:@"GetUserNotifications"];
    
    
        SnUserAppInfo *info = [UserHelper GetUserAppInfo];
        info.CommentCount = 0;
        [UserHelper SetUserAppInfo:info];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SnNotificationDataKeySucc" object:nil];
    }
}

-(void)ClearPrivteMessageCount
{
    if(![self isLoading])
    {
        NSString *uid = [UserHelper GetUserID];
        if(!TTIsStringWithAnyText(uid))
        return;
    
        NSString* url = [NSString stringWithFormat:URLUpdateUserNotifications,KApi_Domain,uid,9];
        TTURLRequest* _request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
        _request.cachePolicy = TTURLRequestCachePolicyNoCache;
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        _request.response = response;
        _request.userInfo = @"clear9";
        TT_RELEASE_SAFELY(response);
        [_request send];
    
        [UserHelper DegBugWidthLog:url title:@"GetUserNotifications"];
    
        SnUserAppInfo *info = [UserHelper GetUserAppInfo];
        info.PrivteMessageCount = 0;
        [UserHelper SetUserAppInfo:info];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SnNotificationDataKeySucc" object:nil];
    }
}

#pragma mark updateSnNotification
- (void)UpdateNotification
{
    [self releaseTimer];
    if(![self isLoading])
    {
       // TT_INVALIDATE_TIMER(_progressTimer);
        NSString *uid = [UserHelper GetUserID];
        if(!TTIsStringWithAnyText(uid))
        return;
    
        NSString* url = [NSString stringWithFormat:URLGetUserNotifications,KApi_Domain,uid];
        TTURLRequest* _request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
        _request.cachePolicy = TTURLRequestCachePolicyNoCache;
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        _request.response = response;
        _request.userInfo = @"get";
        TT_RELEASE_SAFELY(response);
        [_request send];
    
        [UserHelper DegBugWidthLog:url title:@"开始：获取关键KEY通知"];
    }
}

//-(void)StartUpdateNotification
//{
//    NSTimer *timer;  
//    NSDate *date = [NSDate date];  
//    timer = [[NSTimer alloc] initWithFireDate:date interval:KPMSessionTimerInterval 
//                                       target:self       
//                                     selector:@selector(UpdateNotification) 
//                                     userInfo:nil 
//                                      repeats:YES];  
//   
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    _progressTimer = timer;      
//    [timer release]; 
//}

-(void)requestDidStartLoad:(TTURLRequest *)request
{
    [_loadingRequest release];
    _loadingRequest = [request retain];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request
{
    NSString *act = request.userInfo;
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    if([act isEqualToString:@"get"])
    {
        NSString *rootKey = @"GetUserNotificationsResult";
    
        NSDictionary* feed = [response.rootObject objectForKey:rootKey];
        BOOL Success = [[feed objectForKey:@"Success"] boolValue]; 
        if(Success)
        {
            SnUserAppInfo *info = [UserHelper GetUserAppInfo];
            if([act isEqualToString:@"get"])
            {
                    TTDASSERT([[feed objectForKey:@"Notifications"] isKindOfClass:[NSArray class]]);
                    NSArray* entries = [feed objectForKey:@"Notifications"];
                    if(entries.count > 0 )
                    {
                        for (NSDictionary* entry in entries) {
                                int datatype = [[entry objectForKey:@"DataKey"]  intValue];
                                ///// 评论数 ///////
                                if(datatype == 10)
                                    {
                                            info.CommentCount = [[entry objectForKey:@"DataValue"]  intValue];
                                    }
                                ///// 私信 爆料 /////
                                if(datatype == 9)
                                    {
                                            info.PrivteMessageCount = [[entry objectForKey:@"DataValue"]  intValue];
                                    }
                        }
                    }
                
                [self StartUpdateNotification];
                
   /////////  repeat it  ////////
   // [self performSelector:@selector(StartUpdateNotification) withObject:nil afterDelay:KPMSessionTimerInterval];
   // [self releaseTimer];
   // _progressTimer=[NSTimer scheduledTimerWithTimeInterval:KPMSessionTimerInterval target:self selector:@selector(StartUpdateNotification) userInfo:nil repeats:NO];
                
            }
            [UserHelper SetUserAppInfo:info];
            TT_RELEASE_SAFELY(_loadingRequest);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SnNotificationDataKeySucc" object:nil];
        }
    }
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error
{
    TT_RELEASE_SAFELY(_loadingRequest);
     [self StartUpdateNotification];
}

- (void)requestDidCancelLoad:(TTURLRequest*)request
{
    TT_RELEASE_SAFELY(_loadingRequest);
}

-(void)dealloc
{
    [self releaseTimer];
    if(_loadingRequest && [_loadingRequest isLoading])
        [_loadingRequest cancel];
    if(_loadingRequest)
          TT_RELEASE_SAFELY(_loadingRequest);
    [super dealloc];
}
@end

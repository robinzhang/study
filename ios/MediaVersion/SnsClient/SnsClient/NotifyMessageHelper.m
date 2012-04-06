//
//  NotifyMessageHelper.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NotifyMessageHelper.h"
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import <extThree20JSON/SBJsonParser.h>

@implementation NotifyMessageHelper
NotifyMessageHelper *shareNotifyMessageHelper;
+ (NotifyMessageHelper*)sharedInstance
{
    if(shareNotifyMessageHelper == nil)
    {
        shareNotifyMessageHelper = [[NotifyMessageHelper alloc] init];        
    }
    return shareNotifyMessageHelper;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        //userId = [UserHelper GetUserID];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return !!_loadingRequest;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)NotifyMessageByLocation:(CLLocation *)newLocation
{
    if(![self isLoading])
    {
        //[UserHelper  SetUserLocation:newLocation];
        NSString* userId = [UserHelper GetUserID];
        if(!TTIsStringWithAnyText(userId)){
            return ;
        }
   
        SnAppSetting *setting = [UserHelper GetAppSetting:userId];
        SnUserAppInfo *info = [UserHelper GetUserAppInfo];
    
        //check is in user time period
        NSDate *now=[NSDate date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"HH"];
        NSInteger cu=[[dateFormatter stringFromDate:now] integerValue];
        [dateFormatter release];
        NSInteger vNotifyStartTime=setting.KNotifyStartTime;
        NSInteger vNotifyEndTime=setting.KNotifyEndTime;
        BOOL inSpan=NO;
        if (vNotifyStartTime<vNotifyEndTime) {
            inSpan=(vNotifyStartTime<=cu) && (vNotifyEndTime>=cu);
        }else{
            inSpan=(vNotifyEndTime<=cu) && (vNotifyStartTime>=cu);
        }
    
        if (!inSpan) {
            return;
        }
    
    
        NSDate *lastNotifyTime= info.KLastNotifyTime;
            if ([[NSDate date] timeIntervalSinceDate:lastNotifyTime]<KNotifyInterval) {
            return;
        }
    
        info.KLastNotifyTime = [NSDate date];
        [UserHelper SetUserAppInfo:info];
    
        //load notify setting
        NSInteger notifySettingVal= setting.NotifySettings;
    
        //build request url
        NSString *url=[NSString stringWithFormat:URLGetNotify,KApi_Domain,
                         userId,
                         newLocation.coordinate.longitude,
                         newLocation.coordinate.latitude,
                         notifySettingVal];
    
        TTURLRequest *request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
        //sec
    
        [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
        [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
        [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
        //end sec
    
        [request setValue:KUserAgent forHTTPHeaderField:@"User-Agent"];
        request.cachePolicy = TTURLRequestCachePolicyNoCache;
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        [UserHelper DegBugWidthLog:url title:@"开始：获取本地消息通知"];
        [request send];
    }
}
    
-(void)dealloc
{
    if(_loadingRequest && [_loadingRequest isLoading])
        [_loadingRequest cancel];
    if(_loadingRequest)
        TT_RELEASE_SAFELY(_loadingRequest);
    [super dealloc];
}


-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
     TT_RELEASE_SAFELY(_loadingRequest);
}

- (void)requestDidCancelLoad:(TTURLRequest*)request
{
    TT_RELEASE_SAFELY(_loadingRequest);
}

-(void)requestDidStartLoad:(TTURLRequest *)request
{
    [_loadingRequest release];
    _loadingRequest = [request retain];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request
{ 
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    NSDictionary* result = response.rootObject;
    NSDictionary* feed = [result objectForKey:@"GetNotifysResult"];
    NSArray* entries = [feed objectForKey:@"Messages"];
    
    NSDate *now=[NSDate date];
    CLLocation *newLocation = [UserHelper GetUserLocation];
    for (NSDictionary* entry in entries) {
        
         UILocalNotification *notification=[[UILocalNotification alloc] init]; 
        SnMessage *post = [[SnMessage alloc] init];
        
        if([entry objectForKey:@"CreateDate"])
        {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
            [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
             post.PublicDate =  [dateFormatter dateFromString:[entry objectForKey:@"CreateDate"]];
            [dateFormatter release];
        }
        else
            post.PublicDate = [NSDate date];
        
        post.MessageID = [entry objectForKey:@"TMessageId"];
        post.UserID = [entry objectForKey:@"UserId"];
        post.MessageBody = [entry objectForKey:@"MessageBody"];
        post.CommentCount=[[entry objectForKey:@"CommentCount"] intValue];
        if([entry objectForKey:@"CloneCount"])
            post.ViewCount=[[entry objectForKey:@"CloneCount"] intValue];
        else
            post.ViewCount = 0;
        post.Latitude= [[entry objectForKey:@"Latitude"] floatValue];
        post.Longitude = [[entry objectForKey:@"Longitude"] doubleValue];
        post.UserName = [entry objectForKey:@"UserName"];
        post.UserType= [[entry objectForKey:@"AccountType"] intValue];
        post.UserFace = [entry objectForKey:@"UserFace"];
        
        NSArray *imgurls = [entry objectForKey:@"ImgUrl"];
        if(imgurls.count > 0)
        {
            post.PicPath = [imgurls objectAtIndex:0];
        }
        
        CLLocation *entryLocation= [[CLLocation alloc] initWithLatitude:post.Latitude longitude:post.Longitude];
        NSString *distance=[UserHelper getDistance:newLocation another:entryLocation];
        //[entryLocation release];
        notification.timeZone=[NSTimeZone defaultTimeZone]; 
        
        notification.alertAction = NSLocalizedString(@"Display", @"显示");
        notification.fireDate=[now dateByAddingTimeInterval:10];
        notification.alertBody=[NSString stringWithFormat:NSLocalizedString(@"%@:%@,%@,Away from you:%@", @"通知格式化字符串"),post.UserName,post.MessageBody,[post.PublicDate formatShortTime],distance]; 

        [notification setSoundName:UILocalNotificationDefaultSoundName];
        
        NSString *postUrl = [NSString stringWithFormat:@"tt://message/?messageid=%@&userid=%@&from=app"
                         ,post.MessageID
                         ,post.UserID];
        [post release];
        NSDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
        [dict setValue:postUrl forKey:@"message"];
        [notification setUserInfo:dict];
        [dict release];
        
        //[UIApplication sharedApplication].applicationIconBadgeNumber++;
        [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
        [notification release];
    }
    TT_RELEASE_SAFELY(_loadingRequest);
    
    //////////// 已经获得新通知 /////////
    if(entries.count >0)
    {
        ////////////////// have new message ///////////////
        SnUserAppInfo *info = [UserHelper GetUserAppInfo];
        info.HaveNewMessage = YES;
        [UserHelper SetUserAppInfo:info];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationHaveNewMessage" object:nil];
    }
}
@end

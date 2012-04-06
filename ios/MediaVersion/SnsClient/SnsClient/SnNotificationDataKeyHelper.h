//
//  SnNotificationDataKeyHelper.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnNotificationDataKeyHelper : NSObject<TTURLRequestDelegate>
{
    NSTimer *loopTimer;
    TTURLRequest *_loadingRequest;
}
-(void)StartUpdateNotification;
-(void)StopUpdateNotification;
-(void)ClearCommentCount;
-(void)ClearPrivteMessageCount;
- (BOOL)isLoading;
+ (SnNotificationDataKeyHelper*)sharedInstance;
@end

//
//  WeiBoHelper.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WBConnect.h"
@protocol SnAppWeiboDelegate;
@interface WeiBoHelper : NSObject<WBRequestDelegate,WBSessionDelegate>
{
    WeiBo* weibo;
    id<SnAppWeiboDelegate> _delegate;
    bool changeUser; 
}
@property (nonatomic, assign)  bool changeUser;
@property (nonatomic,assign,readonly) WeiBo* weibo;
@property (nonatomic, assign) id <SnAppWeiboDelegate> delegate;
- (void) sendWeibo:(NSString*)text image:(UIImage*)image andDelegate:(id<WBSendViewDelegate>)WBSendDelegate;
- (void) sendWeiboByPost:(NSString*)text image:(UIImage*)image andDelegate:(id<WBRequestDelegate>)WBReqDelegate;
- (void) dismissWeiboSendView;
- (void) weiboLogout;
- (void) weiboLogin;
- (bool) isWeiBoLogon;
NSString* encodeToPercentEscapeString(NSString *string);

+ (WeiBoHelper*)sharedInstance;
@end

#import <Foundation/Foundation.h>
@protocol SnAppWeiboDelegate<NSObject>
@optional
- (void)didAfterWeiboLogiout;
- (void)didAfterWeiBologin:(NSString*)uid;
- (void)didAfterWeiBologinError:(NSString*)error;
@end


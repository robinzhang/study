//
//  SinaWeiBoHelper.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import <extThree20JSON/extThree20JSON.h>
#import <extThree20JSON/SBJsonParser.h>
#import "SFHFKeychainUtils.h"
#import "WBConnect.h"

@interface SinaWeiBoHelper : NSObject<WBRequestDelegate,WBSessionDelegate>
{
     WeiBo* weibo;
}
@property (nonatomic,assign,readonly) WeiBo* weibo;
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) sendWeibo:(NSString*)text image:(UIImage*)image andDelegate:(id<WBSendViewDelegate>)WBSendDelegate;
- (void) sendWeiboByPost:(NSString*)text image:(UIImage*)image andDelegate:(id<WBRequestDelegate>)WBReqDelegate;
- (void) dismissWeiboSendView;
- (void) weiboLogout;
- (void) weiboLogin;
NSString* encodeToPercentEscapeString(NSString *string);
@end

//
//  MyGroupViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHelper.h"
#import <MessageUI/MessageUI.h>
#import "SnsClientAppDelegate.h"
#import "SnSecTableViewController.h"
#import "WeiBoHelper.h"

@interface MyGroupViewController : SnSecTableViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,WBSendViewDelegate,SnAppWeiboDelegate>
{
    NSString *_me;
}
@property (nonatomic, copy)   NSString* me;
@end

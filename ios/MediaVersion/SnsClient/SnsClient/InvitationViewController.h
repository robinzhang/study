//
//  InvitationViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SnsClientAppDelegate.h"
#import "WeiBoHelper.h"

@interface InvitationViewController : SnTableViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,WBSendViewDelegate,SnAppWeiboDelegate>
{

}
@end

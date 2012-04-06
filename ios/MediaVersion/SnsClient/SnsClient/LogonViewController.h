//
//  LogonViewController.h
//  SnsClient
//
//  Created by  on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol SnLogonDelegate<NSObject>
- (void)didAfterLogon:(NSString*)userid;
@end

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import "SnSectionedDataSource.h"
#import "SnsClientAppDelegate.h"
#import "MainViewController.h"
#import "UserGuideController.h"
#import "RegisterViewController.h"
#import "SnSecTableViewController.h"
#import "WeiBoHelper.h"

@interface LogonViewController : TTTableViewController<TTURLRequestDelegate,SnRegisterDelegate,SnAppWeiboDelegate>
{
    UITextField *txtUserName;
    UITextField *txtPassword;
    UIBarButtonItem *btnSubmit;
    UIBarButtonItem *ttloading;
    UIButton *buttonWeibo;
    id<SnLogonDelegate> _delegate;
}
@property (nonatomic, assign) id<SnLogonDelegate> delegate;
-(void)afterLogin:(NSString*)uid;
-(void)doAlert:(id)sender  title:(NSString*)title message:(NSString*)message;
@end

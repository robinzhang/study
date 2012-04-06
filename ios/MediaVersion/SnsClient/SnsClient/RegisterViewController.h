//
//  RegisterViewController.h
//  SnsClient
//
//  Created by  on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SnRegisterDelegate
- (void)didAfterRegister:(NSString*)userid;
@end

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import "SnSectionedDataSource.h"
#import "UserGuideController.h"
#import "SnSecTableViewController.h"

@interface RegisterViewController : TTTableViewController<TTURLRequestDelegate>
{
    UITextField *txtUserName;
    UITextField *txtPassword;
    UITextField *txtNickName;
    UIBarButtonItem *btnSubmit;
    UIBarButtonItem *ttloading;
    UISegmentedControl *sexControl;
    int _sex;
    UIButton *_agreeMent;
    id<SnRegisterDelegate> _delegate;
}
@property (nonatomic, assign) id<SnRegisterDelegate> delegate;
-(void)afterLogin:(NSString*)uid;
@end

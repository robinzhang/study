//
//  UcenterViewController.h
//  SnsClient
//
//  Created by  on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"
#import "EditProfileViewController.h"
#import "DetailImageViewController.h"
#import "SnInfoView.h"

@interface UcenterViewController : SnSecTableViewController<SnEditProfileDelegate,UIAlertViewDelegate>
{
    UIView *userinfoView;
    NSString *_me;
    UserProfile *_profile;
    UIBarButtonItem *ttloading;
    EditProfileViewController * editProfileViewController;
    TTLabel *_commentCountBadge;
    TTLabel *_messageCountBadge;
    SnInfoView *errorinfoview;
}
@property (nonatomic, copy)   NSString* me;
@property (nonatomic, readonly)   UserProfile* profie;
-(UIView*)initUinfo:(UserProfile*)profile;
@end

//
//  UserProfileViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileDataSource.h"
#import "UserRelationButton.h"
#import "UserHelper.h"
#import "DetailImageViewController.h"
#import "MainViewController.h"

@interface UserProfileViewController :SnSecTableViewController
{
    NSString *_me;
    NSString *_queryUserid;
    UIView *userinfoView;
    UserProfile* _profile;
    UserRelationButton *userRelationButton;
}
@property (nonatomic,copy) NSString *queryUserid;
@property (nonatomic,copy) NSString *me;
-(id)initWidthUserId:(NSString*)queryUserid;
-(UIView*)initUinfoView:(UserProfile*)profile;
@end

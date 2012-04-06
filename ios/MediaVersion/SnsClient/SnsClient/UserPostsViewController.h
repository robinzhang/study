//
//  UserPostsViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UserPostViewDataSource.h"
#import "UserHelper.h"
#import "MessageDetailController.h"
#import "UserPostViewModel.h"

@interface UserPostsViewController : SnTableViewController<UserPostUpdateDelegate>
{
    NSString *_me;
    NSString *_queryUserid;
    NSMutableArray*  _posts;
}
@property (nonatomic,copy) NSString *queryUserid;
@property (nonatomic,copy) NSString *me;
-(id)initWidthUserId:(NSString*)queryUserid;
@end

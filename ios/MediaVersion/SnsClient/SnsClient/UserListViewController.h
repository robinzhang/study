//
//  UserListViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHelper.h"
#import "UserListDataSource.h"
#import "UserListModel.h"

@interface UserListViewController : SnTableViewController
{
    NSString *_me;
    NSString *_queryUserid;
    int _sendtype;
}
@property (nonatomic, copy) NSString *queryUserid;
@property (nonatomic, assign) int sendtype;
-(id)initWidthFans:(NSString*)queryUserid;
-(id)initWidthFollow:(NSString*)queryUserid;
-(id)initWidthFriends:(NSString*)queryUserid;
@end

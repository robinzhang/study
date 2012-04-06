//
//  MediaUsersViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserHelper.h"
#import "MediaUsersDataSource.h"
#import "MediaUsersModel.h"

@interface MediaUsersViewController : SnTableViewController
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

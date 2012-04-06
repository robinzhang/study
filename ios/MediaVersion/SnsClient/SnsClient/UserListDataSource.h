//
//  UserListDataSource.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "SnListDataSource.h"
#import "UserListModel.h"
#import "UserProfile.h"

@interface UserListDataSource : SnListDataSource
{
    UserListModel *_searchFeedModel;
}
- (id)initWithSearchQuery:(NSString*)userid  sendType:(NSUInteger)sendType;


@end

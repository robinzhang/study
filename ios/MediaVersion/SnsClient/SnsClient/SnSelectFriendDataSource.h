//
//  SnSelectFriendDataSource.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnListDataSource.h"
#import "MediaUsersModel.h"
#import "SnTableSelectItem.h"

@interface SnSelectFriendDataSource :SnListDataSource
{
    MediaUsersModel *_searchFeedModel;
    NSMutableArray *_selecteditems;
}
@property (nonatomic, assign) NSMutableArray* selecteditems;
- (id)initWithSearchQuery:(NSString*)userid  sendType:(NSUInteger)sendType;
@end
//
//  SnSelectFriendsController.h
//  SnsClient
//
//  Created by  on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SnSelectFriendsDelegate
- (void)didSelectFriends:(NSString*)ids names:(NSString*)names;
@end


#import <UIKit/UIKit.h>
#import "SnSelectFriendDataSource.h"
#import "UserListModel.h"
#import "SnTableSelectItem.h"
#import "SnTableSelectItemCell.h"

@interface SnSelectFriendsController : TTTableViewController
{
    id<SnSelectFriendsDelegate> _delegate;
    NSString *_me;
    SnSelectFriendDataSource *_source;
    NSMutableArray *_seNames;
}
@property (nonatomic, assign) id<SnSelectFriendsDelegate> delegate;
@end

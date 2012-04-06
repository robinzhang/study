//
//  SnSelectFriendDataSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnSelectFriendDataSource.h"

@implementation SnSelectFriendDataSource
@synthesize selecteditems = _selecteditems;

- (id)initWithSearchQuery:(NSString*)userid  sendType:(NSUInteger)sendType
{
    if (self = [super init]) {
        _searchFeedModel = [[MediaUsersModel alloc] initWithSearchQuery:userid];
        _selecteditems = [[NSMutableArray alloc] init];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_searchFeedModel);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
    return _searchFeedModel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
    //if(_searchFeedModel.posts.count <= 0)
    //    return;
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    NSString *uid = [UserHelper GetUserID];
    for (UserProfile* post in _searchFeedModel.posts) {
        if(![uid isEqualToString:post.UserID])
        {
            BOOL ischeck = NO;
            for (int i=0; i<_selecteditems.count; ++i) {
                if( [_selecteditems objectAtIndex:i] == post.UserID)
                    ischeck = YES;
            }
            
            SnTableSelectItem *item = 
            [SnTableSelectItem  
             itemWithTitle:post.UserName
             caption:nil
             text:post.Intro 
             timestamp:nil
             URL:nil
             ];
        
        
            [item setImageURL:[NSString stringWithFormat:@"%@_80_80.jpg",post.UserFace]];
            item.userInfo = post;
            [item setSelected:ischeck];
            [item setUserid:post.UserID];
            [item setUserType:post.UserType];
            [items addObject:item];
        }
    }
    
    if (_searchFeedModel.finished  == NO) {
        [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
    }
    
    if(items.count <= 0)
    {
        [items addObject:[SnTableNoDataItem itemWithText:@"没有任何的媒体哦！"]];
    }
    
    self.items = items;
    TT_RELEASE_SAFELY(items);
}
@end

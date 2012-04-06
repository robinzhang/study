//
//  UserListDataSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserListDataSource.h"

@implementation UserListDataSource

- (id)initWithSearchQuery:(NSString*)userid  sendType:(NSUInteger)sendType
{
    if (self = [super init]) {
        _searchFeedModel = [[UserListModel alloc] initWithSearchQuery:userid  sendType:sendType];
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
   // if(_searchFeedModel.posts.count <= 0)
   //     return;
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for (UserProfile* post in _searchFeedModel.posts) {
        
        NSString *url = [NSString stringWithFormat:@"tt://uprofile/%@",post.UserID];
        
        SnTableMessageItem *item = 
        [SnTableMessageItem  
         itemWithTitle:post.UserName
         caption:nil
         text:post.Intro 
         timestamp:nil
         URL:url
         ];

        item.UserType = post.UserType;
        [item setImageURL:[NSString stringWithFormat:@"%@_80_80.jpg",post.UserFace]];
        item.userInfo = post;
        [items addObject:item];
    }
    
    if (_searchFeedModel.finished  == NO) {
        [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
    }
    
    if(items.count <= 0)
    {
        [items addObject:[SnTableNoDataItem itemWithText:@"没有任何的朋友哦！"]];
    }
    self.items = items;
    TT_RELEASE_SAFELY(items);
}

@end

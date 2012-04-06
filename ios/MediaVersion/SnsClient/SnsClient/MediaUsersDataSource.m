//
//  MediaUsersDataSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MediaUsersDataSource.h"

@implementation MediaUsersDataSource

- (id)initWithSearchQuery:(NSString*)userid
{
    if (self = [super init]) {
        _searchFeedModel = [[MediaUsersModel alloc] initWithSearchQuery:userid];
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
    //    return;
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for (UserProfile* post in _searchFeedModel.posts) {
        
        NSString *url = [NSString stringWithFormat:@"tt://uprofile/%@",post.UserID];
        
        SnTableMessageItem *item = 
        [SnTableMessageItem  
         itemWithTitle:post.UserName
         caption:nil
         text:post.Intro 
         timestamp:post.CreateTime 
         URL:url
         ];
        
        [item setImageURL:[NSString stringWithFormat:@"%@_80_80.jpg",post.UserFace]];
        item.userInfo = post;
        [items addObject:item];
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

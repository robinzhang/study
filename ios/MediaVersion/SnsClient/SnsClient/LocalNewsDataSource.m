//
//  LocalNewsDataSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LocalNewsDataSource.h"

@implementation LocalNewsDataSource




///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)userid locationType:(int)locationType range:(NSUInteger)range  sendType:(NSUInteger)sendType  sendModel:(NSUInteger)sendModel{
    if (self = [super init]) {
        _searchFeedModel = [[LocalNewsModel alloc] initWithSearchQuery:userid locationType:locationType range:range  sendType:sendType sendModel:sendModel];
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
    NSMutableArray* items = [[NSMutableArray alloc] init];
    if(_searchFeedModel.posts.count > 0)
    {
        CLLocation *nowLocatio = [UserHelper GetUserLocation];
        for (SnMessage* post in _searchFeedModel.posts) {
            [items addObject:[UserHelper buildMessageItem:post nowLocation:nowLocatio]];
        }
    
        if (!_searchFeedModel.finished ) {
            [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
        }
    }
    
    if(items.count <= 0)
    {
        [items addObject:[SnTableNoDataItem itemWithText:@"附近还没有新闻哦！"]];
    }
    self.items = items;
    TT_RELEASE_SAFELY(items);
}
@end

//
//  NewsForMeDataSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewsForMeDataSource.h"

@implementation NewsForMeDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)userid lat:(float)lat lon:(float)lon model:(int)model
{
    if (self = [super init]) {
        _searchFeedModel = [[NewsForMeModel alloc] initWithSearchQuery:userid lat:lat lon:lon model:model];
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
    
    CLLocation *nowLocatio = [UserHelper GetUserLocation];
    for (SnMessage* post in _searchFeedModel.posts) {
        [items addObject:[UserHelper buildMessageItem:post nowLocation:nowLocatio]];
    }
    
    if (!_searchFeedModel.finished) {
        [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
    }
    
    if(items.count <= 0)
        [items addObject:[SnTableNoDataItem itemWithText:@"还没有收到报料哦！"]];
    
    self.items = items;
    TT_RELEASE_SAFELY(items);
}
@end

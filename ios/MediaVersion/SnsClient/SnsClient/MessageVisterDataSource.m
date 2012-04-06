//
//  MessageVisterDataSource.m
//  Kanguo
//
//  Created by zhan xiaoping on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MessageVisterDataSource.h"


@implementation MessageVisterDataSource

- (id)initWithQuery:(NSString*)userid messageid:(NSString*)messageid
{
    if (self = [super init]) {
        _searchFeedModel = [[MessageVisterModel alloc] initWithQuery:userid messageid:messageid];
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
- (void)tableView:(UITableView*)tableView cell:(UITableViewCell*)cell
willAppearAtIndexPath:(NSIndexPath*)indexPath {
	[super tableView:tableView cell:cell
willAppearAtIndexPath:indexPath];
    
	if (indexPath.row == self.items.count-1 
        && [cell isKindOfClass:[TTTableMoreButtonCell class]]) 
    {
		TTTableMoreButton* moreLink = [(TTTableMoreButtonCell *)cell object];
		moreLink.isLoading = YES;
		[(TTTableMoreButtonCell *)cell setAnimating:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self.model load:TTURLRequestCachePolicyNoCache more:YES];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
    NSMutableArray* items = [[NSMutableArray alloc] init];
    if(_searchFeedModel.posts.count > 0)
    {
        for (UserProfile* post in _searchFeedModel.posts) {
        
            NSString *url = [NSString stringWithFormat:@"tt://uprofile/%@",post.UserID];
        
            SnTableMessageItem *item = 
            [SnTableMessageItem  
            itemWithTitle:post.UserName
            caption:@"" 
            text:post.Intro 
            timestamp:nil
            URL:url
            ];
        
            [item setImageURL:[NSString stringWithFormat:@"%@_80_80.jpg",post.UserFace]];
            [items addObject:item];
        
        }
    
        if (!_searchFeedModel.finished) {
            [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
        }
    }
    
    if(items.count <= 0)
    {
        [items addObject:[SnTableNoDataItem itemWithText:@"貌似还没有人看过，下拉可以刷新哦！"]];
    }
    
    self.items = items;
    TT_RELEASE_SAFELY(items);
}
@end

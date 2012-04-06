//
//  UeventDataSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UeventDataSource.h"
#import "UeventModel.h"

@implementation UeventDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init{
    if (self = [super init]) {
        _searchFeedModel = [[UeventModel alloc] init];
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
        for (SnMessage* post in _searchFeedModel.posts) {
            //NSString *distanceStr = @"";
            NSString *timeStr = [post.PublicDate formatRelativeTime];
            //NSString *text = [NSString stringWithFormat:@"%@ 距离:%@",timeStr,distanceStr];

            NSString *url = [NSString stringWithFormat:@"tt://message/?messageid=%@&userid=%@&username=%@&userface=%@"
                             ,post.MessageID
                             ,post.UserID
                             ,[post.UserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
                             ,post.UserFace];
            
            SnTableMessageItem *item = 
            [SnTableMessageItem  
             itemWithTitle:post.MessageBody
             caption:@"" 
             text:[NSString stringWithFormat:@"-- [%@]在%@发表了评论", post.UserName,timeStr]
             timestamp:nil 
             URL:url
             ];
            
            [item setUserType:post.UserType];
            [item setImageURL:[NSString stringWithFormat:@"%@_80_80.jpg",post.UserFace]];
            item.userInfo = post;
            item.PicFlag = 0;
            if(TTIsStringWithAnyText(post.PicPath))
                item.PicFlag = 1;
            [items addObject:item];
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

//
//  DeatilCommentDataSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DeatilCommentDataSource.h"

@implementation DeatilCommentDataSource
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)messageid userid:(NSString*)userid{
    if (self = [super init]) {
        _searchFeedModel = [[NewsCommentModel alloc] initWithSearchQuery:messageid userid:userid];
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
    NSMutableArray* section = [[NSMutableArray alloc] init];
    for (SnMessage* post in _searchFeedModel.posts) {
        
        NSString *url = [NSString stringWithFormat:@"tt://uprofile/%@",post.UserID];
        
        SnTableMessageItem *item = 
        [SnTableMessageItem  
         itemWithTitle:post.UserName
         caption:@"" 
         text:post.MessageBody 
         timestamp:post.PublicDate 
         URL:url
         ];
        
        [item setImageURL:[NSString stringWithFormat:@"%@_80_80.jpg",post.UserFace]];
        //[item setCommentCount:post.commentCount];
        //[item setMessageType:post.messageType];
        
        [item setUserType:post.UserType];
        [section addObject:item];
        
    }
    
    if (!_searchFeedModel.finished) {
        [section addObject:[TTTableMoreButton itemWithText:@"more…"]];
    }
    
    NSMutableArray* sections = [[NSMutableArray alloc] init];
    [sections addObject:@"评论"];
    [items addObject:section];
    
    self.items = items;
    self.sections = sections;
    TT_RELEASE_SAFELY(items);
    //TT_RELEASE_SAFELY(section);
    TT_RELEASE_SAFELY(sections);
}
@end

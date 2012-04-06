//
//  PublicViewDataSource.m
//  SnsClient
//
//  Created by  on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShareViewDataSource.h"

@implementation ShareViewDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)userid range:(NSUInteger)range location:(CLLocation*)location sendType:(NSUInteger)sendType sendModel:(NSUInteger)sendModel{
    if (self = [super init]) {
        _searchFeedModel = [[ShareViewModel alloc] initWithSearchQuery:userid range:range location:location sendType:sendType sendModel:sendModel];
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
    for (SnMessage* post in _searchFeedModel.posts) {
        
//        NSString *url = [NSString stringWithFormat:@"tt://message/?messageid=%@&userid=%@&username=%@&userface=%@"
//                         ,post.MessageID
//                         ,post.UserID
//                         ,[post.UserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
//                         ,post.UserFace];
        
        
        SnTableMessageItem *item = 
        [SnTableMessageItem  
         itemWithTitle:post.UserName
         caption:@"" 
         text:post.MessageBody 
         timestamp:post.PublicDate 
         URL:nil
         ];
        
        [item setImageURL:[NSString stringWithFormat:@"%@_80_80.jpg", post.UserFace]];
        
        item.userInfo = post;
        //[item setCommentCount:post.commentCount];
        //[item setMessageType:post.messageType];
        [items addObject:item];
    }
    
    if (_searchFeedModel.finished  == NO) {
        [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
    }
    
    self.items = items;
    TT_RELEASE_SAFELY(items);
}
@end

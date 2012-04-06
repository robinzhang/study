//
//  ShareViewOfflineSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShareViewOfflineSource.h"
#import "UserHelper.h"

@implementation ShareViewOfflineSource

- (id)initWidthMessageList:(NSMutableArray*)list;
{
    if (self = [super init]) {
        //NSString *key = [NSString stringWithFormat: @"share_list_%@",userid];
        NSMutableArray* items = [[NSMutableArray alloc] init];
        for (SnMessage* post in list) {
            
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
            
            [item setImageURL:post.UserFace];
            item.userInfo = post;
            //[item setCommentCount:post.commentCount];
            //[item setMessageType:post.messageType];
            [items addObject:item];
        }
        
        //if (_searchFeedModel.finished  == NO) {
        //    [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
        //}
        self.items = items;
        TT_RELEASE_SAFELY(items);
    }
    return self;
}
@end

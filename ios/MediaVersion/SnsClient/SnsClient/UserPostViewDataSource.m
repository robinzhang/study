//
//  HomeViewDataSource.m
//  SnsClient
//
//  Created by  on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserPostViewDataSource.h"


@implementation UserPostViewDataSource
@synthesize UpdateDelegate = _UpdateDelegate;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)userid accountid:(NSString*)accountid lat:(float)lat lon:(float)lon model:(int)model
{
    if (self = [super init]) {
        _searchFeedModel = [[UserPostViewModel alloc] initWithSearchQuery:userid accountid:accountid lat:lat lon:lon model:model];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    //TT_RELEASE_SAFELY(_searchFeedModel);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_searchFeedModel.userid isEqualToString:_searchFeedModel.accountid])
        return YES;
    else
        return NO;
}

//-(SnTableMessageItem*)buildMessageItem:(SnMessage*)post nowLocation:(CLLocation*)nowLocation
//{
//    //        NSString *url = [NSString stringWithFormat:@"tt://message/?messageid=%@&userid=%@"
//    //                                 ,post.MessageID
//    //                                 ,post.UserID];
//    
//    CLLocation* another = [[CLLocation alloc] initWithLatitude:post.Latitude longitude:post.Longitude];
//    NSString *distanceStr = [UserHelper getDistance:nowLocation another:another];
//    NSString *timeStr = [post.PublicDate formatRelativeTime];
//    //NSString *text = [NSString stringWithFormat:@"%@ 距离:%@ \r点击:%d 评论:%d",timeStr,distanceStr,post.ViewCount,post.CommentCount];
//    NSString *text = [NSString stringWithFormat:@"%@ 距离:%@",timeStr,distanceStr];
//    
//    NSString *url = [NSString stringWithFormat:@"tt://message/?messageid=%@&userid=%@&username=%@&userface=%@"
//                     ,post.MessageID
//                     ,post.UserID
//                     ,[post.UserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
//                     ,post.UserFace];
//    
//    SnTableMessageItem *item = 
//    [SnTableMessageItem  
//     itemWithTitle:post.MessageBody
//     caption:@"" 
//     text:text 
//     timestamp:nil 
//     URL:url
//     ];
//    
//    [item setUserType:post.UserType];
//    [item setImageURL:[NSString stringWithFormat:@"%@_80_80.jpg",post.UserFace]];
//    item.userInfo = post;
//    item.PicFlag = 0;
//    //item.viewcount = [NSString stringWithFormat:@"%d",post.ViewCount];
//    //item.commentCount = [NSString stringWithFormat:@"%d",post.CommentCount];
//    if(TTIsStringWithAnyText(post.PicPath))
//        item.PicFlag = 1;
//    //[item setCommentCount:post.commentCount];
//    //[item setMessageType:post.messageType];
//    
//    return item;
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        SnMessage *obj = [_searchFeedModel.posts objectAtIndex:indexPath.row];
        if(obj)
        {
            NSString* turl = [NSString 
                              stringWithFormat:URLDelMessages,KApi_Domain,
                              obj.UserID, obj.MessageID];
            NSURL *url = [ NSURL URLWithString:turl ];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setDefaultResponseEncoding:NSUTF8StringEncoding];
            [request setStringEncoding:NSUTF8StringEncoding];
            //[request setRequestMethod:@"POST"];
            //[request setDelegate:self];
            [request setUserAgent:KUserAgent];
            
            NSMutableDictionary *headers=[[NSMutableDictionary alloc] initWithCapacity:2];
            [headers setObject:[UserHelper GetSecToken] forKey:KUserSecToken];
            [headers setObject:[UserHelper GetUserID] forKey:KUserID];
            [headers setObject:KAppKValue forKey:KAppKey];
            [request setRequestHeaders:headers];
            [headers release];
            
            [UserHelper DegBugWidthLog:turl title:@"del message"];
            [request startSynchronous];
            
            if(!request.error)
            {
                 [_searchFeedModel.posts removeObject:obj];
                [self.UpdateDelegate didDeleteFinished:indexPath.row];
                //[self deleteItem:obj.UserID pid:obj.MessageID];
            
                //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                [UserHelper doAlert:self title:@"操作提示" message:@"删除失败！，请检查您的网络状态、或刷新后重试！"];
            }
        }
        //[tableView reloadData];
        [tableView setEditing:NO];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
//-(void)deleteItem:(NSString*)uid pid:(NSString*)pid
//{
            

//    NSString* url = [NSString 
//                     stringWithFormat:URLDelMessages,KApi_Domain,
//                     uid, pid];
//    
//    TTURLRequest *request = [TTURLRequest
//                              requestWithURL:url
//                              delegate: self];
//    
//    //sec
//    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
//    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
//[request setValue:KAppKValue forHTTPHeaderField:KAppKey];
//    //end sec
//    
//    [request setUserInfo:pid];
//    
//    request.cachePolicy = TTURLRequestCachePolicyNoCache;
//    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
//    request.response = response;
//    TT_RELEASE_SAFELY(response);
//    [UserHelper DegBugWidthLog:uid title:@"del message"];
//    [request send];
//}

//
///////////////////////////////////////////////////////
//- (void)requestDidFinishLoad:(TTURLRequest*)request
//{
//    NSString *pid = [NSString stringWithFormat:@"%@", request.userInfo];
//    [_searchFeedModel clearCache:_searchFeedModel.userid accountid:_searchFeedModel.accountid];
//    //[self.model load:TTURLRequestCachePolicyNoCache more:YES];
//    [self.UpdateDelegate  didDeleteFinished:pid];
//}
//
//- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error
//{
//    [self.UpdateDelegate didDeleteError];
//}


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

    
        if (!_searchFeedModel.finished) {
            [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
        }
    }
    
    if(items.count <= 0)
    {
        if(!TTIsStringWithAnyText(_searchFeedModel.accountid) && ![UserHelper isLogon])
            [items addObject:[SnTableNoDataItem itemWithText:@"你还没有登录哦，点击登录！"]];
        else
            [items addObject:[SnTableNoDataItem itemWithText:@"还没有发布过新闻哦！"]];
    }
    
    self.items = items;
    TT_RELEASE_SAFELY(items);
}


@end

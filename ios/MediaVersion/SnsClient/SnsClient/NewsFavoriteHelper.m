//
//  NewsFavoriteHelper.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewsFavoriteHelper.h"

@implementation NewsFavoriteHelper
@synthesize delegate = _delegate;

-(void)addFavorite:(NSString*)userid muserid:(NSString*)muserid messgeid:(NSString*)messgeid
{
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url=[NSString stringWithFormat:URLAddFavourite,KApi_Domain,userid,muserid,messgeid,0];
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    request.cachePolicy =  TTURLRequestCachePolicyNoCache;
    request.userInfo = @"add";
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [request send];
    
    [UserHelper DegBugWidthLog:url title:@"Add Favourite"];
}

-(void)delFavorite:(NSString*)userid muserid:(NSString*)muserid messgeid:(NSString*)messgeid
{
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url=[NSString stringWithFormat:URLAddFavourite,KApi_Domain,userid,muserid,messgeid,1];
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    request.cachePolicy =  TTURLRequestCachePolicyNoCache;
    request.userInfo = @"del";
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [request send];
    
    [UserHelper DegBugWidthLog:url title:@"del Favourite"];
}

-(void)checkFavorite:(NSString*)userid muserid:(NSString*)muserid  messgeid:(NSString*)messgeid
{
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url=[NSString stringWithFormat:URLCheckFavorite,KApi_Domain,userid,muserid,messgeid];
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    request.cachePolicy =  TTURLRequestCachePolicyNoCache;
    request.userInfo = @"check";
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [request send];
    
    [UserHelper DegBugWidthLog:url title:@"check Favourite"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request
{
    NSString *act = [NSString stringWithFormat:@"%@", request.userInfo];
    
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    NSDictionary* result = response.rootObject;
    
    if([act isEqualToString:@"add"])
    {
        NSDictionary* feed = [result objectForKey:@"GetFavouriteResult"];
        //NSString* ErrorMessage = [NSString stringWithFormat:@"%@", [feed objectForKey:@"ErrorMessage"]];
        BOOL Success = [[feed objectForKey:@"Success"] boolValue];
        if(Success)
        {
            //[UserHelper doAlert:self title:NSLocalizedString(@"Favorite", @"Favorite") message:NSLocalizedString(@"添加收藏成功!", @"添加收藏成功!")];
        }
        else
        {
//            NSString *msg = @"添加收藏失败!";
//            if(ErrorMessage && ![ErrorMessage isEqualToString:@"(null)"])
//                msg = [NSString stringWithFormat:@"%@",ErrorMessage];
//            [UserHelper doAlert:self title:NSLocalizedString(@"Favorite", @"Favorite") message:msg];
        }
    }
    else if ([act isEqualToString:@"del"])
    {
        NSDictionary* feed = [result objectForKey:@"GetFavouriteResult"];
        // NSString* ErrorMessage = [NSString stringWithFormat:@"%@", [feed objectForKey:@"ErrorMessage"]];
        BOOL Success = [[feed objectForKey:@"Success"] boolValue];
        if(Success)
        {
            //[UserHelper doAlert:self title:NSLocalizedString(@"Favorite", @"Favorite") message:NSLocalizedString(@"取消收藏成功!", @"添加收藏成功!")];
        }
        else
        {
//            NSString *msg = @"取消收藏失败!";
//            if(ErrorMessage && ![ErrorMessage isEqualToString:@"(null)"])
//                msg = [NSString stringWithFormat:@"%@",ErrorMessage];
//            [UserHelper doAlert:self title:NSLocalizedString(@"Favorite", @"Favorite") message:msg];
        }
    }
    else if ([act isEqualToString:@"check"])
    {
        if([result objectForKey:@"IsNewsInCollectionResult"])
        {
            int val = [[result objectForKey:@"IsNewsInCollectionResult"] intValue];
            [self.delegate CheckNewsFavoriteSuccess:val];
//            [[NSNotificationCenter defaultCenter]
//            postNotificationName:@"CheckFavoriteSuccess" object:[result objectForKey:@"IsNewsInCollectionResult"]];
        }
    }
}
@end

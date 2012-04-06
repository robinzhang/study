//
//  UserRelationHelper.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserRelationHelper.h"

@implementation UserRelationHelper
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}


#pragma mark -TTURLRequestDelegate
- (void)requestDidStartLoad:(TTURLRequest*)request
{
    //[super requestDidStartLoad:request];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)doAlert:(id)sender  title:(NSString*)title message:(NSString*)message{
	UIAlertView *alertDialog;
    
    alertDialog = [[UIAlertView alloc] 
                   initWithTitle: title 
                   message:message
                   delegate: nil 
                   cancelButtonTitle: NSLocalizedString(@"Done", @"确定")
                   otherButtonTitles: nil];
    
    [alertDialog show];
	[alertDialog release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)follow:(NSString*)myselfUserId willFollowUserId:(NSString*)willFollowUserId{
    if([myselfUserId isEqualToString:willFollowUserId])
    {
        [self doAlert:self title:NSLocalizedString(@"Can't Follow Yourself", @"不能关注自己哦！") message:nil];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:URLFollow,KApi_Domain,myselfUserId , willFollowUserId];
    
    /// clear sharedCache
    NSString* url1 = [NSString stringWithFormat:URLGetUserRelation,KApi_Domain,myselfUserId , willFollowUserId];
    NSString* key = [[TTURLCache sharedCache] keyForURL:url1];
    [[TTURLCache sharedCache] removeKey:key];
    
    //NSLog(@"follow:%@",url);
    TTURLRequest *request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
    [request setUserInfo:@"Follow"];
    
    //sec
    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    //end sec
    
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [UserHelper DegBugWidthLog:url title:@"Follow"];
    [request send];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)unFollow:(NSString*)myselfUserId willUnFollowUserId:(NSString*)willUnFollowUserId{
    
    if([myselfUserId isEqualToString:willUnFollowUserId])
    {
        [self doAlert:self title:NSLocalizedString(@"Can't Follow Yourself", @"不能关注自己哦！") message:nil];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:URLUnFollow,KApi_Domain,myselfUserId , willUnFollowUserId];
    
    /// clear sharedCache
    NSString* url1 = [NSString stringWithFormat:URLGetUserRelation,KApi_Domain,myselfUserId , willUnFollowUserId];
    NSString* key = [[TTURLCache sharedCache] keyForURL:url1];
    [[TTURLCache sharedCache] removeKey:key];
    
    TTURLRequest *request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
    [request setUserInfo:@"UnFollow"];
    
    //sec
    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    //end sec
    
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [UserHelper DegBugWidthLog:url title:@"UnFollow"];
    [request send];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)checkUserRelation:(NSString*)myselfUserId otherUserId:(NSString*)otherUserId{
    if([myselfUserId isEqualToString:otherUserId])
    {
        return;
    }

    NSString* url = [NSString stringWithFormat:URLGetUserRelation,KApi_Domain,myselfUserId , otherUserId];
    if([[TTURLCache sharedCache] dataForURL:url])
    {
        NSString *string = [[NSString alloc] initWithData:[[TTURLCache sharedCache] dataForURL:url] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
        NSError* parserError = nil;
        id result = [jsonParser objectWithString:string error:&parserError];
        [string release];
        [jsonParser release];
        if(! parserError && [result isKindOfClass:[NSDictionary class]])
        {
            [UserHelper DegBugWidthLog:[result valueForKey:@"GetUserRelationStringResult"] title:@"vv"];
//            [[NSNotificationCenter defaultCenter]  postNotificationName:@"CheckUserRelationSuccess" object:[result valueForKey:@"GetUserRelationStringResult"]];
            //int val = [[result valueForKey:@"GetUserRelationStringResult"]  intValue];
                [self.delegate CheckUserRelationSuccess:[[result valueForKey:@"GetUserRelationStringResult"]  intValue]];
            return;
        }
    }
    
    TTURLRequest *request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
    [request setUserInfo:@"checkUserRelation"];
    
    //sec
    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    //end sec
    
    request.cachePolicy = TTURLRequestCachePolicyDefault;
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [UserHelper DegBugWidthLog:url title:@"checkUserRelation"];
    [request send];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    //NSLog([error localizedDescription]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request
{
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    NSDictionary* result = response.rootObject;
    
    //NSLog(@"uinfo requestDidFinishLoad");
    
    NSString *act =[NSString stringWithFormat:@"%@", request.userInfo];
    if([act isEqualToString:@"Follow"])
    {
        id resultent = [result objectForKey:@"FollowResult"];
        BOOL rtv = [[resultent objectForKey:@"Success"] boolValue];
        
        if(rtv)
        {
            //[self doAlert:nil title:NSLocalizedString(@"Follow Success", @"关注成功") message:@""];
        }
    }
    
    if([act isEqualToString:@"UnFollow"])
    {
        id resultent = [result objectForKey:@"UnFollowResult"];
        BOOL rtv = [[resultent objectForKey:@"Success"] boolValue];
        
        if(rtv)
            
        {
            //[self doAlert:nil title:NSLocalizedString(@"UnFollow Success", @"取消关注成功") message:@""];
        }
    }
    
    if([act isEqualToString:@"checkUserRelation"])
    {
        if([result objectForKey:@"GetUserRelationStringResult"])
        {
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:@"CheckUserRelationSuccess" object:[result objectForKey:@"GetUserRelationStringResult"]];
            [self.delegate CheckUserRelationSuccess: [[result objectForKey:@"GetUserRelationStringResult"]  intValue]];
        }
    }
}

-(void)dealloc
{
    [super dealloc];
}
@end
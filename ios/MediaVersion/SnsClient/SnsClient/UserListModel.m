//
//  UserListModel.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserListModel.h"
@implementation UserListModel

@synthesize userid = _userid;
@synthesize posts      = _posts;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;
@synthesize sendType    =_sendType;

- (id)initWithSearchQuery:(NSString*)userId  sendType:(NSUInteger)sendType
{
    if (self = [super init]) {
        self.userid = userId;
        self.sendType=sendType;
        _resultsPerPage = 10;
        _page = 1;
        _finished = YES;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
//    TT_RELEASE_SAFELY(_userid);
//    TT_RELEASE_SAFELY(_posts);
    [super dealloc];
}

-(void)clearCache:(NSString*)userid  sendType:(NSUInteger)sendType
{
    NSString* url = [NSString stringWithFormat:URLGetUserList, KApi_Domain,
                     1,
                     _resultsPerPage,
                     userid,
                     sendType];
    NSString* key = [[TTURLCache sharedCache] keyForURL:url];
    [[TTURLCache sharedCache] removeKey:key];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (!self.isLoading ) { //&& TTIsStringWithAnyText(_userid)
        
        if (more) {
            _page++;
        }
        else {
            _page = 1;
            _finished = NO;
            [_posts removeAllObjects];
        }
        
        NSString* url = [NSString stringWithFormat:URLGetUserList, KApi_Domain,
                         _page,
                         _resultsPerPage,
                         _userid,
                         _sendType];
        
        //NSLog(@"userlist request:%@",url);
        
        TTURLRequest* request = [TTURLRequest
                                 requestWithURL: url
                                 delegate: self];
        
        if(!cachePolicy)
            cachePolicy = TTURLRequestCachePolicyDefault;
        
        request.cachePolicy =  cachePolicy;
        
        [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
        [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
        [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
        //request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
        [UserHelper DegBugWidthLog:url title:@"userlist"];
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        [request send];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = [response.rootObject objectForKey:@"GetUserRelationListResult"];
    
    NSArray* entries = [feed objectForKey:@"Models"];
    TTDASSERT([entries isKindOfClass:[NSArray class]]);
    BOOL Success = [[feed objectForKey:@"Success"] boolValue];
    if(Success && entries.count > 0 )
    {
        NSMutableArray* posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
        [posts addObjectsFromArray:_posts];
        TT_RELEASE_SAFELY(_posts);
        int i = 0;
        
        for (NSDictionary* entry in entries) {
            UserProfile* post = [[UserProfile alloc] init];
            post.UserName = [entry objectForKey:@"Name"];
            post.FansCount = [[entry objectForKey:@"TFansCount"] intValue];
            post.FollowerCount =[[entry objectForKey:@"TFollowCount"] intValue];
            post.MessageCount = [[entry objectForKey:@"TMessageCount"] intValue];
            post.UserFace = [entry objectForKey:@"UserFace"];
            post.UserID = [entry objectForKey:@"UserId"];
            post.UserType = [[entry objectForKey:@"AccountType"] intValue];
            post.Sex = [[entry objectForKey:@"Sex"] intValue];
            if(!TTIsStringWithAnyText([entry objectForKey:@"Introduction"]))
                post.Intro = @"";
            else
                post.Intro = [entry objectForKey:@"Introduction"];
            [posts addObject:post];
            TT_RELEASE_SAFELY(post);
            i ++;   
        }
        _finished = i < _resultsPerPage;
        _posts = posts;
    }
    else
        _finished = YES; 
    [super requestDidFinishLoad:request];
}
@end

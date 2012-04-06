//
//  MediaUsersModel.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MediaUsersModel.h"

@implementation MediaUsersModel

@synthesize posts      = _posts;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;

- (id)initWithSearchQuery:(NSString*)userId 
{
    if (self = [super init]) {
        _resultsPerPage = 10;
        _page = 1;
        _finished = YES;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    [super dealloc];
}

-(void)clearCache:(NSString*)userid
{
    NSString* url = [NSString stringWithFormat:URLMediaUsersList, 
                     KApi_Domain,
                     1,
                     _resultsPerPage]
    ;
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
        
        NSString* url = [NSString stringWithFormat:URLMediaUsersList, 
                         KApi_Domain,
                         _page,
                         _resultsPerPage];
        
        NSLog(@"userlist request:%@",url);
        
        TTURLRequest* request = [TTURLRequest
                                 requestWithURL: url
                                 delegate: self];
        
        if(!cachePolicy)
            cachePolicy = TTURLRequestCachePolicyDefault;
        
        request.cachePolicy =  cachePolicy;
        
        [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
        [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
        [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
        request.cacheExpirationAge = (60*30);
        
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
    
    NSDictionary* feed = [response.rootObject objectForKey:@"GetMediaUsersListResult"];
    
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
            post.UserType = [[entry objectForKey:@"AccountType"] intValue];
            post.UserID = [entry objectForKey:@"UserId"];
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

//
//  UeventModel.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UeventModel.h"
#define  K_resultsPerPage 10


@implementation UeventModel

@synthesize userid = _userid;
@synthesize posts      = _posts;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;

-(id)init
{
    self = [super init];
    if(self){
        _userid = [UserHelper GetUserID];
        _resultsPerPage = K_resultsPerPage;
        _page = 1;
        _finished = YES;
        _posts = [[NSMutableArray alloc] init];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    _userid = [UserHelper GetUserID];
    if (!self.isLoading && TTIsStringWithAnyText(_userid) ) { //
        
        if (more) {
            _page++;
        }
        else {
            _page = 1;
            _finished = NO;
            [_posts removeAllObjects];
        }
        
        
        NSString* url = [NSString stringWithFormat:URLGetNewsComment, KApi_Domain,
                         _userid,
                         _page,
                         _resultsPerPage
                         ];
        
        TTURLRequest* request = [TTURLRequest
                                 requestWithURL: url
                                 delegate: self];
        
        // if(!cachePolicy)
        //     cachePolicy = TTURLRequestCachePolicyDefault;
        
        request.cachePolicy =  TTURLRequestCachePolicyNoCache;
        
        [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
        [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
        [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
        
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        
        [request send];
        [UserHelper DegBugWidthLog:url title:@"URLGetNewsComment"];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = [response.rootObject objectForKey:@"GetNewsCommentByPageResult"];
    BOOL Success = [[feed objectForKey:@"Success"] boolValue];  
    TTDASSERT([[feed objectForKey:@"Messages"] isKindOfClass:[NSArray class]]);
    NSArray* entries = [feed objectForKey:@"Messages"];
    if(Success && entries.count > 0 )
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
        NSMutableArray* posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
        [posts addObjectsFromArray:_posts];
        TT_RELEASE_SAFELY(_posts);
        int i = 0;
        for (NSDictionary* entry in entries) {
            SnMessage *post = [[SnMessage alloc] init];
            
            if([entry objectForKey:@"CreateDate"])
                post.PublicDate = [dateFormatter dateFromString:[entry objectForKey:@"CreateDate"]];
            else
                post.PublicDate = [NSDate date];
            
            post.MessageID = [entry objectForKey:@"TMessageId"];
            post.UserID = [entry objectForKey:@"UserId"];
            post.MessageBody = [entry objectForKey:@"MessageBody"];
            post.CommentCount=[[entry objectForKey:@"CommentCount"] intValue];
            
            if([entry objectForKey:@"CloneCount"])
                post.ViewCount=[[entry objectForKey:@"CloneCount"] intValue];
            else
                post.ViewCount = 0;
            
            post.Latitude= [[entry objectForKey:@"Latitude"] floatValue];
            post.Longitude = [[entry objectForKey:@"Longitude"] doubleValue];
            post.UserType= [[entry objectForKey:@"AccountType"] intValue];
            post.UserName = [entry objectForKey:@"UserName"];
            post.UserFace =  [entry objectForKey:@"UserFace"];
            
            NSArray *imgurls = [entry objectForKey:@"ImgUrl"];
            if(imgurls.count > 0)
            {
                post.PicPath = [imgurls objectAtIndex:0];
            }
            
            [posts addObject:post];
            TT_RELEASE_SAFELY(post);
            i ++;  
        }
        _finished = i < _resultsPerPage; // posts.count > totalCount ;
        _posts = posts;
        TT_RELEASE_SAFELY(dateFormatter);
    }
    [super requestDidFinishLoad:request];
}

- (void)clearThisCache
{
    _userid = [UserHelper GetUserID];
    NSString* url = [NSString stringWithFormat:URLGetNewsComment, KApi_Domain,
                     _userid,
                     _page,
                     _resultsPerPage
                     ];

    NSString* key = [[TTURLCache sharedCache] keyForURL:url];
    [[TTURLCache sharedCache] removeKey:key];
}
@end

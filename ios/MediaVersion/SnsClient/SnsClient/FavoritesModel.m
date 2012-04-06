//
//  FavoritesModel.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FavoritesModel.h"

@implementation FavoritesModel
@synthesize userid = _userid;
@synthesize posts      = _posts;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)userid{
    if (self = [super init]) {
        self.userid = userid;
        
        _resultsPerPage = 10;
        _page = 1;
        _finished = YES;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    TT_RELEASE_SAFELY(_userid);
    TT_RELEASE_SAFELY(_posts);
    [super dealloc];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (!self.isLoading && TTIsStringWithAnyText(_userid)) {
        
        if (more) {
            _page++;
        }
        else {
            _page = 1;
            _finished = NO;
            [_posts removeAllObjects];
        }
        
        NSString* url = [NSString stringWithFormat:URLMessageGetFavourite, 
                         KApi_Domain,
                         _userid,
                         _page,
                         _resultsPerPage];
        
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
        
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        [UserHelper DegBugWidthLog:url title:@"GetFavourite"];
        [request send];
    }
}

-(void)clearCache:(NSString*)userid
{
    NSString* url = [NSString stringWithFormat:URLMessageGetFavourite, 
                     KApi_Domain,
                     _userid,
                     1,
                     _resultsPerPage];
    
    NSString* key = [[TTURLCache sharedCache] keyForURL:url];
    [[TTURLCache sharedCache] removeKey:key];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = [response.rootObject objectForKey:@"GetFavouriteResult"];
    TTDASSERT([[feed objectForKey:@"Messages"] isKindOfClass:[NSArray class]]);
    
    BOOL Success = [[feed objectForKey:@"Success"] boolValue];  
    NSArray* entries = [feed objectForKey:@"Messages"];
    if(Success && entries.count > 0 )
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
        
        //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
        NSMutableArray* posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
        [posts addObjectsFromArray:_posts];
        TT_RELEASE_SAFELY(_posts);
        //int totalCount =  [[feed objectForKey:@"Count"] intValue];
        int i = 0;
        for (NSDictionary* entry in entries) {
            SnMessage *post = [[SnMessage alloc] init];
            
            //NSDate* date = [dateFormatter dateFromString:[entry objectForKey:@"CreateDate"]];
            //post.PublicDate = date;
            NSString *dateString = [NSString stringWithFormat:@"%@",[entry objectForKey:@"CreateDate"]];
            
            if(TTIsStringWithAnyText(dateString))
                post.PublicDate  = [dateFormatter dateFromString:dateString];
            else
                post.PublicDate = [NSDate date];
            
            //post.postId = [NSNumber numberWithLongLong:
            //[[entry objectForKey:@"id"] longLongValue]];
            //post.source = @"iPhone";//[entry objectForKey:@"source"];
            //post.messageType = [entry objectForKey:@"MessageType"];
            NSArray *imgurls = [entry objectForKey:@"ImgUrl"];
            if(imgurls.count > 0)
            {
                post.PicPath = [imgurls objectAtIndex:0];
            }
            //[imgurls release];
            
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
            
            [posts addObject:post];
            TT_RELEASE_SAFELY(post);
            i ++;   
        }
        _finished = i < _resultsPerPage; // posts.count > totalCount ;
        _posts = posts;
        TT_RELEASE_SAFELY(dateFormatter);
    }
    else
    {
        _finished = YES;
    }
    [super requestDidFinishLoad:request];
}

@end
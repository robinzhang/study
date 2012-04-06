//
//  MessageVisterModel.m
//  Kanguo
//
//  Created by zhan xiaoping on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MessageVisterModel.h"

@implementation MessageVisterModel
@synthesize userid = _userid;
@synthesize messageid = _messageid;
@synthesize posts      = _posts;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;
@synthesize location = _location;

- (id)initWithQuery:(NSString*)userid messageid:(NSString*)messageid
{
    if (self = [super init]) {
        self.userid = userid;
        self.messageid =messageid;
        
        self.location = [[CLLocation alloc] initWithLatitude:39.916250 longitude:116.525130];
        
        _resultsPerPage = 10;
        _page = 1;
        _finished = YES;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    TT_RELEASE_SAFELY(_userid);
    TT_RELEASE_SAFELY(_messageid);
    TT_RELEASE_SAFELY(_posts);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (!self.isLoading && TTIsStringWithAnyText(_userid)) {
        
        self.location=[UserHelper GetUserLocation];
        
        
        if (more) {
            _page++;
        }
        else {
            _page = 1;
            _finished = NO;
            [_posts removeAllObjects];
        }
        
        
        NSString* url = [NSString stringWithFormat:URLGetMessageVisitors, KApi_Domain, self.userid, self.messageid,_page,_resultsPerPage];
        

        TTURLRequest *request = [TTURLRequest
                                  requestWithURL:url
                                  delegate: self];
        
        //sec
        [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
        [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
        [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
        //end sec
        
        //if(!cachePolicy)
            cachePolicy = TTURLRequestCachePolicyNoCache;
        request.cachePolicy = cachePolicy; 
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        
        [UserHelper DegBugWidthLog:url title:@"MessageVisitors"];
        [request send];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = [response.rootObject objectForKey:@"GetMessageVisterResult"];
    TTDASSERT([[feed objectForKey:@"Models"] isKindOfClass:[NSArray class]]);
    NSArray* entries = [feed objectForKey:@"Models"];
    
    BOOL Success = [[feed objectForKey:@"Success"] boolValue];
    if(Success && entries.count > 0 )
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        
        NSMutableArray* posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
        [posts addObjectsFromArray:_posts];
        TT_RELEASE_SAFELY(_posts);
        int i = 0;
        
        for (NSDictionary* entry in entries) {
            
            UserProfile* post = [[UserProfile alloc] init];
           
            post.UserID =   [entry objectForKey:@"UserId"];
            post.UserName =   [entry objectForKey:@"Name"];
            post.Intro = [entry objectForKey:@"Introduction"];
            if(!TTIsStringWithAnyText(post.Intro))
                post.Intro = NSLocalizedString(@"No Personal Introduction", @"这家伙很懒,什么都没留下.");
            
            post.UserFace = [entry objectForKey:@"UserFace"];
            
            post.MessageCount = [[entry objectForKey:@"TMessageCount"] intValue];
            post.FansCount = [[entry objectForKey:@"TFansCount"] intValue];
            post.FollowerCount = [[entry objectForKey:@"TFollowCount"] intValue];
            post.Sex = [[entry objectForKey:@"Sex"] intValue];
            
            if ([entry objectForKey:@"Latitude"]) {
                post.Latitude = [[entry objectForKey:@"Latitude"] doubleValue];
            }
            if ([entry objectForKey:@"Longitude"]) {
                post.Longitude = [[entry objectForKey:@"Longitude"] doubleValue];
            }
            
            post.CreateTime =  [dateFormatter dateFromString:[entry objectForKey:@"CreateTime"]];
            
            [posts addObject:post];
            TT_RELEASE_SAFELY(post);
            i ++;   
        }
        
        _finished = i < _resultsPerPage;
        _posts = posts;
        
         TT_RELEASE_SAFELY(dateFormatter);
    }
    else
        _finished = YES;
    
    [super requestDidFinishLoad:request];
}
@end

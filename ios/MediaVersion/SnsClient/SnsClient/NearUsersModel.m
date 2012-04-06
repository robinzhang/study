//
//  HomeViewModel.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import "NearUsersModel.h"

@implementation NearUsersModel
@synthesize location = _location;
@synthesize range= _range;
@synthesize posts      = _posts;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;

- (id)initWithSearchQuery:(CLLocation*)location range:(NSString*)range{
    if (self = [super init]) {
        
        self.location =[UserHelper GetUserLocation];
        self.range =range;
        _resultsPerPage = 10;
        _page = 1;
        _location = location;
        _finished = YES;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    TT_RELEASE_SAFELY(_location);
    TT_RELEASE_SAFELY(_range);
    TT_RELEASE_SAFELY(_posts);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (!self.isLoading) {
        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        if ([userDefaults floatForKey:KLastLat])
//            self.location =[[CLLocation alloc] initWithLatitude:[userDefaults floatForKey:KLastLat] longitude:[userDefaults floatForKey:KLastLng]];
//        else
//            self.location = [[CLLocation alloc] initWithLatitude:39.916250 longitude:116.525130];
        
        if (more) {
            _page++;
        }
        else {
            _page = 1;
            _finished = NO;
            [_posts removeAllObjects];
        }
        
        
        NSString* url = [NSString stringWithFormat:URLGetAroundUsers,KApi_Domain,self.location.coordinate.longitude,self.location.coordinate.latitude,_range, _page,_resultsPerPage];
        
        
        NSLog(@"%@",url);
        
        TTURLRequest* request = [TTURLRequest
                                 requestWithURL: url
                                 delegate: self];
        //sec
        [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
        [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
        [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
        //end sec
        if(!cachePolicy)
            cachePolicy = TTURLRequestCachePolicyDefault;
        request.cachePolicy = cachePolicy;
        request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
        
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        [UserHelper DegBugWidthLog:url title:@"nearnews"];
        [request send];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = [response.rootObject objectForKey:@"GetAroundUsersResult"];
    TTDASSERT([[feed objectForKey:@"Models"] isKindOfClass:[NSArray class]]);
    NSArray* entries = [feed objectForKey:@"Models"];
    
    NSMutableArray* posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
    [posts addObjectsFromArray:_posts];
    TT_RELEASE_SAFELY(_posts);
    
    BOOL Success = [[feed objectForKey:@"Success"] boolValue];
    if(Success && entries.count > 0 )
    {
        int i = 0;
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        for (NSDictionary* entry in entries) {
            UserProfile* post = [[UserProfile alloc] init];
            post.UserID =   [entry objectForKey:@"UserId"];
            post.UserName =   [entry objectForKey:@"Name"];
            post.Intro = [entry objectForKey:@"Introduction"];
            if(!TTIsStringWithAnyText(post.Intro))
                post.Intro = @"";
            
            post.UserFace = [entry objectForKey:@"UserFace"];
            
            post.MessageCount = [[entry objectForKey:@"TMessageCount"] intValue];
            post.FansCount = [[entry objectForKey:@"TFansCount"] intValue];
            post.UserType = [[entry objectForKey:@"AccountType"] intValue];
            post.FollowerCount = [[entry objectForKey:@"TFollowCount"] intValue];
            //post.Sex = [[entry objectForKey:@"Sex"] intValue];
            //if(!TTIsStringWithAnyText( [entry objectForKey:@"Sex"]))
            //    post.Sex = 1;
            //else
            post.Sex = [[entry objectForKey:@"Sex"] intValue];
            
            post.Latitude = [[entry objectForKey:@"Latitude"] doubleValue];
            post.Longitude = [[entry objectForKey:@"Longitude"] doubleValue];
            post.CreateTime =  [dateFormatter dateFromString:[entry objectForKey:@"CreateTime"]];
            
            //NSLog(@"%@",[entry objectForKey:@"CreateTime"]);
            //post.FriendCount = [[entry objectForKey:@"TMessageCount"] intValue];
            
            [posts addObject:post];
            TT_RELEASE_SAFELY(post);
            i ++;   
        }
        _finished = i < _resultsPerPage;
        TT_RELEASE_SAFELY(dateFormatter);
    }
    else
        _finished = YES; 
    
    _posts = posts;
    [super requestDidFinishLoad:request];
}

@end

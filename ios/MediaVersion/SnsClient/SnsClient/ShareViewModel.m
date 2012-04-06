//
//  ShareViewModel.m
//  SnsClient
//
//  Created by  on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SnMessage.h"
#import "ShareViewModel.h"
#import "UserHelper.h"

@implementation ShareViewModel
@synthesize userid = _userid;
@synthesize range= _range;
@synthesize posts      = _posts;
@synthesize location    =_location;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;
@synthesize sendType    =_sendType;
@synthesize sendModel    =_sendModel;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)userid range:(NSUInteger)range location:(CLLocation*)location sendType:(NSUInteger)sendType sendModel:(NSUInteger)sendModel {
    if (self = [super init]) {
        self.userid = userid;
        self.range =range;
        self.location=location;
        self.sendType=sendType;
        self.sendModel=sendModel;
        //_location = location;
        _resultsPerPage = 100;
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

- (void)clearCache:(NSString*)userid range:(NSUInteger)range location:(CLLocation*)location sendType:(NSUInteger)sendType sendModel:(NSUInteger)sendModel
{
    if(!_location)
        _location = [UserHelper GetUserLocation];
    
    NSString * lo = [NSString stringWithFormat:@"%f", _location.coordinate.longitude];
    NSString * la = [NSString stringWithFormat:@"%f", _location.coordinate.latitude];  
    
    NSString* url = [NSString stringWithFormat:URLSnMessageShareList, KApi_Domain,
                     _userid,
                     lo,
                     la,
                     _range,
                     1,
                     _resultsPerPage,
                     _sendModel,
                     _sendType];
    
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
        
        if(!_location)
            _location = [UserHelper GetUserLocation];
        
        NSString * lo = [NSString stringWithFormat:@"%f", _location.coordinate.longitude];
        NSString * la = [NSString stringWithFormat:@"%f", _location.coordinate.latitude];  
        
        NSString* url = [NSString stringWithFormat:URLSnMessageShareList, KApi_Domain,
                         _userid,
                         lo,
                         la,
                         _range,
                         _page,
                         _resultsPerPage,
                         _sendModel,
                         _sendType];
        
        //NSLog(@"share data request:%@",url);
        
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
        [UserHelper DegBugWidthLog:url title:@"share news"];
        [request send];
    }
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
       
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = [response.rootObject objectForKey:@"PullNewsAroundResult"];
    BOOL Success = [[feed objectForKey:@"Success"] boolValue];  
//    if(!Success)
//        return;
    
    TTDASSERT([[feed objectForKey:@"Messages"] isKindOfClass:[NSArray class]]);
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
            
//            NSDate* date = [dateFormatter dateFromString:[entry objectForKey:@"CreateDate"]];
//            post.PublicDate = date;
            if([entry objectForKey:@"CreateDate"])
            {
                post.PublicDate = [dateFormatter dateFromString:[entry objectForKey:@"CreateDate"]];
                
            }
            else
            {
               post.PublicDate = [NSDate date];
            }
            
            //post.postId = [NSNumber numberWithLongLong:
            //[[entry objectForKey:@"id"] longLongValue]];
            post.MessageID = [entry objectForKey:@"TMessageId"];
            post.UserID = [entry objectForKey:@"UserId"];
            post.MessageBody = [entry objectForKey:@"MessageBody"];
            post.CommentCount=[[entry objectForKey:@"CommentCount"] intValue];
            if([entry objectForKey:@"CloneCount"])
                post.ViewCount=[[entry objectForKey:@"CloneCount"] intValue];
            else
                post.ViewCount = 0;
            //post.source = @"iPhone";//[entry objectForKey:@"source"];
            //post.messageType = [entry objectForKey:@"MessageType"];
            
            //CLLocationDegrees lat=[[entry objectForKey:@"Latitude"] floatValue];
            //CLLocationDegrees lng=[[entry objectForKey:@"Longitude"] doubleValue];
            post.Latitude= [[entry objectForKey:@"Latitude"] floatValue];
            post.Longitude = [[entry objectForKey:@"Longitude"] doubleValue];
            post.UserName = [entry objectForKey:@"UserName"];
            post.UserType= [[entry objectForKey:@"AccountType"] intValue];
            post.UserFace = [entry objectForKey:@"UserFace"];
            
            NSArray *imgurls = [entry objectForKey:@"ImgUrl"];
            if(imgurls.count > 0)
            {
                post.PicPath = [imgurls objectAtIndex:0];
            }
            
            //post.url = [NSString stringWithFormat:@"tt://message?messageid=%@&userid=%@",
            //            [entry objectForKey:@"TMessageId"],
            //            [entry objectForKey:@"UserId"]
            //            ];
            
            [posts addObject:post];
            TT_RELEASE_SAFELY(post);
            i ++;   
        }
        _finished = i < _resultsPerPage; // posts.count > totalCount ;
        _posts = posts;
        
        TT_RELEASE_SAFELY(dateFormatter);
        NSString *me = [UserHelper GetUserID];
        if(_page == 1 && [me isEqualToString:_userid])
        {
            NSString *key = [NSString stringWithFormat: @"share_list_%@",_userid];
            [UserHelper SetMessageList:posts key:key];
        }
    }
    else
    {
        _finished = YES;
    }
    [super requestDidFinishLoad:request];
}

@end

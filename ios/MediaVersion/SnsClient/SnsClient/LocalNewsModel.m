//
//  LocalNewsModel.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LocalNewsModel.h"

@implementation LocalNewsModel
@synthesize userid = _userid;
@synthesize range= _range;
@synthesize posts      = _posts;
@synthesize locationType    =_locationType;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;
@synthesize sendType    =_sendType;
@synthesize sendModel    =_sendModel;
#define  K_resultsPerPage  10
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)userid locationType:(int)locationType range:(NSUInteger)range  sendType:(NSUInteger)sendType  sendModel:(NSUInteger)sendModel{
    if (self = [super init]) {
        self.userid = userid;
        self.range =range;
        //self.location=location;
        self.sendType=sendType;
        self.sendModel=sendModel;
        self.locationType = locationType;
        _resultsPerPage = K_resultsPerPage;
        _page = 1;
        _finished = YES;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    //TT_RELEASE_SAFELY(_userid);
    //TT_RELEASE_SAFELY(_posts);
    [super dealloc];
}


/*
+ (void)clearCache:(NSString*)userid range:(NSUInteger)range  sendType:(NSUInteger)sendType  sendModel:(NSUInteger)sendModel
{
 
    CLLocation* location = [UserHelper GetUserLocation];
    NSString *lo = [NSString stringWithFormat:@"%f",  location.coordinate.longitude];
    NSString *la =  [NSString stringWithFormat:@"%f", location.coordinate.latitude]; 
   if(_locationType == 1)
   {
       SnUserAppInfo *info = [UserHelper GetUserAppInfo];
       lo = [NSString stringWithFormat:@"%f",  info.MapCenterLo];
       la =  [NSString stringWithFormat:@"%f", info.MapCenterLa]; 
 _range = info.LastMapRange;
   }
    
    //if(location && location.coordinate.longitude > 0)
    //    lo = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    //if(location && location.coordinate.latitude > 0)
    //    la = [NSString stringWithFormat:@"%f", location.coordinate.latitude]; 
    
    NSString* url = [NSString stringWithFormat:URLSnMessageShareList, KApi_Domain,
                     userid,
                     lo,
                     la,
                     range,
                     1,
                     K_resultsPerPage,
                     sendModel,
                     sendType];
    
    NSString* key = [[TTURLCache sharedCache] keyForURL:url];
    [[TTURLCache sharedCache] removeKey:key];
}
*/

- (void)clearThisCache
{
    
    CLLocation* location = [UserHelper GetUserLocation];
    NSString *lo = [NSString stringWithFormat:@"%f",  location.coordinate.longitude];
    NSString *la =  [NSString stringWithFormat:@"%f", location.coordinate.latitude]; 
    if(_locationType == 1)
    {
        SnUserAppInfo *info = [UserHelper GetUserAppInfo];
        lo = [NSString stringWithFormat:@"%f",  info.MapCenterLo];
        la =  [NSString stringWithFormat:@"%f", info.MapCenterLa]; 
        _range = info.LastMapRange;
    }
    
    
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
    if (!self.isLoading && TTIsStringWithAnyText(_userid) ) { //
        
        if (more) {
            _page++;
        }
        else {
            _page = 1;
            _finished = NO;
            [_posts removeAllObjects];
        }
        
        // NSLog(@"share data request:%@",[[NSNumber numberWithDouble: _location.coordinate.latitude] stringValue]);
        
        CLLocation* location = [UserHelper GetUserLocation];
        NSString *lo = [NSString stringWithFormat:@"%f",  location.coordinate.longitude];
        NSString *la =  [NSString stringWithFormat:@"%f", location.coordinate.latitude]; 
         
        if(_locationType == 1)
        {
            SnUserAppInfo *info = [UserHelper GetUserAppInfo];
            lo = [NSString stringWithFormat:@"%f",  info.MapCenterLo];
            la =  [NSString stringWithFormat:@"%f", info.MapCenterLa]; 
            _range = info.LastMapRange;
        }
        
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
        request.cacheExpirationAge = (60*30);
        
        [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
        [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
        [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
        //request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
        
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        
        [request send];
        [UserHelper DegBugWidthLog:url title:@"localnews"];
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
            
            if([entry objectForKey:@"CreateDate"])
                 post.PublicDate = [dateFormatter dateFromString:[entry objectForKey:@"CreateDate"]];
            else
                post.PublicDate = [NSDate date];
            
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
            post.UserType= [[entry objectForKey:@"AccountType"] intValue];
            post.UserName = [entry objectForKey:@"UserName"];
            post.UserFace =  [entry objectForKey:@"UserFace"];
            
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
            NSString *key = [NSString stringWithFormat: @"local_list_%@",_userid];
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

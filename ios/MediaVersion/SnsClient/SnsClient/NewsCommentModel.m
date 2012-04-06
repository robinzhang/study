//
//  NewsCommentModel.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewsCommentModel.h"

@implementation NewsCommentModel
@synthesize userid = _userid;
@synthesize messageid = _messageid;
@synthesize posts      = _posts;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;
@synthesize totalCount = _totalCount;

- (id)initWithSearchQuery:(NSString*)messageid userid:(NSString*)userid
{
    if (self = [super init]) {
        _resultsPerPage = 10;
        _page = 1;
        _userid = userid;
        _messageid = messageid;
        _finished = YES;
        _totalCount = 0;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    TT_RELEASE_SAFELY(_posts);
    [super dealloc];
}

- (void)clearCache:(NSString*)messageid userid:(NSString*)userid
{
    NSString* url = [NSString stringWithFormat:URLNewsComment, KApi_Domain,userid, messageid,1,_resultsPerPage];
    NSString* key = [[TTURLCache sharedCache] keyForURL:url];
    [[TTURLCache sharedCache] removeKey:key];
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
        
        NSString* url = [NSString stringWithFormat:URLNewsComment, KApi_Domain,self.userid, self.messageid,_page,_resultsPerPage];
        TTURLRequest *request = [TTURLRequest
                                  requestWithURL:url
                                  delegate: self];
        
     
        [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
        [request setValue:[UserHelper GetUserID]  forHTTPHeaderField:KUserID];
        [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
        //end sec
        
        //if(!cachePolicy)
            cachePolicy = TTURLRequestCachePolicyNoCache;
        request.cachePolicy = cachePolicy;
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        [UserHelper DegBugWidthLog:url title:@"GetMessageComment"];
        [request send];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = [response.rootObject objectForKey:@"GetMessageCommentResult"];
    
    BOOL Success = [[feed objectForKey:@"Success"] boolValue];
//    if(!Success)
//        return;
    
    TTDASSERT([[feed objectForKey:@"Messages"] isKindOfClass:[NSArray class]]);
    TTDASSERT([[feed objectForKey:@"orgionalMessage"] isKindOfClass:[NSDictionary class]]);
    
//    NSDictionary* userinfoent = [feed objectForKey:@"orgionalMessage"];    
//    _orgionalMessage = [[TMessagePost alloc] init];
//    _orgionalMessage.messageType = [userinfoent objectForKey:@"MessageType"];
//    _orgionalMessage.userface =  [userinfoent objectForKey:@"UserFace"];
//    _orgionalMessage.name = [userinfoent objectForKey:@"UserName"];
//    _orgionalMessage.userId = [userinfoent objectForKey:@"UserId"];
//    NSObject *Introduction =  [feed objectForKey:@"Introduction"];
//    if(TTIsStringWithAnyText(Introduction))
//        _orgionalMessage.intro =  [NSString stringWithFormat:[feed objectForKey:@"Introduction"],@""];
//    else
//        _orgionalMessage.intro = @"这家伙真懒什么都不写...";
//    
//    _orgionalMessage.created = [Helper formatDateByString:[[Helper formatDateByString:[userinfoent objectForKey:@"CreateDate"]] formatShortTime]];
//    _orgionalMessage.source = [userinfoent objectForKey:@"Source"];
//    _orgionalMessage.text = [userinfoent objectForKey:@"MessageBody"];
//    _orgionalMessage.commentCount = [[userinfoent objectForKey:@"CommentCount"] intValue];
//    _orgionalMessage.viewCount = [[userinfoent objectForKey:@"CloneCount"] intValue];
//    
//    
//    CLLocationDegrees lat=[[userinfoent objectForKey:@"Latitude"] floatValue];
//    CLLocationDegrees lng=[[userinfoent objectForKey:@"Longitude"] doubleValue];
//    _orgionalMessage.location = [[CLLocation alloc] initWithLatitude:lat longitude:lng].coordinate;
//    
//    NSArray *imgurls = [userinfoent objectForKey:@"ImgUrl"];
//    if(imgurls.count > 0)
//        _orgionalMessage.detailImg = [imgurls objectAtIndex:0];
  
    
    NSArray* entries = [feed objectForKey:@"Messages"];
    if(Success && entries.count > 0)
    {
        if([feed objectForKey:@"Count"])
           _totalCount = [[feed objectForKey:@"Count"] intValue];
        else
            _totalCount = 0;
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
        
        NSMutableArray* posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
        [posts addObjectsFromArray:_posts];
        TT_RELEASE_SAFELY(_posts);
        int i = 0;
        
        for (NSDictionary* entry in entries) {
            SnMessage   * post = [[SnMessage alloc] init];
            
            post.UserID = [entry objectForKey:@"UserId"];
            post.UserType= [[entry objectForKey:@"AccountType"] intValue];
            post.UserName = [entry objectForKey:@"UserName"];
            post.MessageBody = [entry objectForKey:@"MessageBody"];
            post.UserFace = [entry objectForKey:@"UserFace"];
            post.UserType = [[entry objectForKey:@"AccountType"] intValue];
            post.PublicDate = [dateFormatter dateFromString:[entry objectForKey:@"CreateDate"]];
            
            [posts addObject:post];
            TT_RELEASE_SAFELY(post);
            i ++;   
        }
        _finished = (i < _resultsPerPage);
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

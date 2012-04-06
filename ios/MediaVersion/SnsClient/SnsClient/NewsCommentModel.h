//
//  NewsCommentModel.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import <MapKit/MapKit.h>
#import "SnMessage.h"

@interface NewsCommentModel : TTURLRequestModel
{
    NSString* _messageid;
    NSString* _userid;
    NSMutableArray *  _posts;
    NSUInteger _page;             // page of search request
    NSUInteger _resultsPerPage;   // results per page, once the initial query is made
    BOOL _finished;
    NSUInteger _totalCount; 
}

@property (nonatomic, assign)   NSString* userid;
@property (nonatomic, copy)     NSString* messageid;
@property (nonatomic, readonly) NSMutableArray*  posts;
@property (nonatomic, assign)   NSUInteger      resultsPerPage;
@property (nonatomic, assign)   NSUInteger      totalCount;
@property (nonatomic, readonly) BOOL            finished;

- (id)initWithSearchQuery:(NSString*)messageid userid:(NSString*)userid;
- (void)clearCache:(NSString*)messageid userid:(NSString*)userid;
@end

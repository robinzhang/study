//
//  HomeViewModel.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import <MapKit/MapKit.h>
#import "UserProfile.h"


@interface NearUsersModel : TTURLRequestModel
{
    CLLocation* _location;
    NSString* _range;
    NSMutableArray *  _posts;
    NSUInteger _page;             // page of search request
    NSUInteger _resultsPerPage;   // results per page, once the initial query is made
    BOOL _finished;
}

@property (nonatomic, assign)   CLLocation* location;
@property (nonatomic, copy)     NSString* range;
@property (nonatomic, readonly) NSMutableArray*  posts;
@property (nonatomic, assign)   NSUInteger      resultsPerPage;
@property (nonatomic, readonly) BOOL            finished;

- (id)initWithSearchQuery:(CLLocation*)location range:(NSString*)range;
@end

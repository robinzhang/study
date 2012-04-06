//
//  MediaUsersModel.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import "UserHelper.h"
#import "UserProfile.h"


@interface MediaUsersModel : TTURLRequestModel
{
    NSMutableArray*  _posts;
    NSUInteger _page;
    NSUInteger _resultsPerPage;
    BOOL _finished;
}
@property (nonatomic, readonly)   NSMutableArray*  posts;
@property (nonatomic, assign)     NSUInteger      resultsPerPage;
@property (nonatomic, readonly)   BOOL            finished;

- (id)initWithSearchQuery:(NSString*)userid;
-(void)clearCache:(NSString*)userid;
@end

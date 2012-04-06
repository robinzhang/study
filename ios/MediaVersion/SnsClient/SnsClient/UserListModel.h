//
//  UserListModel.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import "UserHelper.h"
#import "UserProfile.h"

@interface UserListModel : TTURLRequestModel
{
    NSString* _userid;
    NSUInteger _sendType;
    NSMutableArray*  _posts;
    NSUInteger _page;
    NSUInteger _resultsPerPage;
    BOOL _finished;
}
@property (nonatomic, copy)       NSString* userid;
@property (nonatomic, assign)     NSUInteger sendType;
@property (nonatomic, readonly)   NSMutableArray*  posts;
@property (nonatomic, assign)     NSUInteger      resultsPerPage;
@property (nonatomic, readonly)   BOOL            finished;

- (id)initWithSearchQuery:(NSString*)userid  sendType:(NSUInteger)sendType;
-(void)clearCache:(NSString*)userid  sendType:(NSUInteger)sendType;
@end

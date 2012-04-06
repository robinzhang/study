//
//  UeventModel.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UeventModel : TTURLRequestModel
{
    NSString* _userid;
    NSMutableArray*  _posts;
    NSUInteger _page;
    NSUInteger _resultsPerPage;
    BOOL _finished;
}
@property (nonatomic, copy)       NSString* userid;
@property (nonatomic, readonly)   NSMutableArray*  posts;
@property (nonatomic, assign)     NSUInteger      resultsPerPage;
@property (nonatomic, readonly)   BOOL            finished;
@end

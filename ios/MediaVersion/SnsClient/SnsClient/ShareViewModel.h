//
//  ShareViewModel.h
//  SnsClient
//
//  Created by  on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <CoreLocation/CoreLocation.h>
#import <extThree20JSON/extThree20JSON.h>
#import "SnMessage.h"
#import "UserHelper.h"

@interface ShareViewModel : TTURLRequestModel {
    NSString* _userid;
    NSUInteger _range;
    CLLocation* _location;
    NSUInteger _sendType;
    NSUInteger _sendModel;
    NSMutableArray*  _posts;
    NSUInteger _page;
    NSUInteger _resultsPerPage;
    BOOL _finished;

}

@property (nonatomic, copy)       NSString* userid;
@property (nonatomic, assign)     NSUInteger range;
@property (nonatomic, assign)     NSUInteger sendType;
@property (nonatomic, assign)     NSUInteger sendModel;
@property (nonatomic, readonly)   NSMutableArray*  posts;
@property (nonatomic, copy)       CLLocation* location;
@property (nonatomic, assign)     NSUInteger      resultsPerPage;
@property (nonatomic, readonly)   BOOL            finished;

- (id)initWithSearchQuery:(NSString*)userid range:(NSUInteger)range location:(CLLocation*)location sendType:(NSUInteger)sendType sendModel:(NSUInteger)sendModel;
- (void)clearCache:(NSString*)userid range:(NSUInteger)range location:(CLLocation*)location sendType:(NSUInteger)sendType sendModel:(NSUInteger)sendModel;
@end

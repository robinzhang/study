//
//  NewsForMeModel.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <CoreLocation/CoreLocation.h>
#import <extThree20JSON/extThree20JSON.h>
#import "SnMessage.h"

@interface NewsForMeModel: TTURLRequestModel {
    NSString* _userid;
    NSMutableArray*  _posts;
    NSUInteger _page;
    NSUInteger _resultsPerPage;
    BOOL _finished;
    int _model;
    float _lat;
    float _lon;
}
@property (nonatomic, assign)     float lat;
@property (nonatomic, assign)     float lon;
@property (nonatomic, assign)     int model;
@property (nonatomic, copy)       NSString* userid;
@property (nonatomic, readonly)   NSMutableArray*  posts;
@property (nonatomic, assign)     NSUInteger       resultsPerPage;
@property (nonatomic, readonly)   BOOL             finished;

- (id)initWithSearchQuery:(NSString*)userid lat:(float)lat lon:(float)lon model:(int)model;
-(void)clearThisCache;
+(void)clearCache:(NSString*)userid lat:(float)lat lon:(float)lon model:(int)model;
@end

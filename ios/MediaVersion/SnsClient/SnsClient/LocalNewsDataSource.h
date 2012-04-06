//
//  LocalNewsDataSource.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SnListDataSource.h"
#import "LocalNewsModel.h"
#import <MapKit/MapKit.h>

@interface LocalNewsDataSource : SnListDataSource
{
    LocalNewsModel *_searchFeedModel;
}
- (id)initWithSearchQuery:(NSString*)userid locationType:(int)locationType range:(NSUInteger)range sendType:(NSUInteger)sendType  sendModel:(NSUInteger)sendModel;
@end

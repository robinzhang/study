//
//  NewsForMeDataSource.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <CoreLocation/CoreLocation.h>
#import "SnListDataSource.h"
#import "NewsForMeModel.h"
#import "SnMessage.h"

@interface NewsForMeDataSource  : SnListDataSource
{
    NewsForMeModel *_searchFeedModel;
}
- (id)initWithSearchQuery:(NSString*)userid lat:(float)lat lon:(float)lon model:(int)model;
@end

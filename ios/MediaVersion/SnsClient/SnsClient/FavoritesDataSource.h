//
//  FavoritesDataSource.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <CoreLocation/CoreLocation.h>
#import "SnListDataSource.h"
#import "FavoritesModel.h"
#import "SnMessage.h"

@interface FavoritesDataSource : SnListDataSource
{
    FavoritesModel *_searchFeedModel;
}
- (id)initWithSearchQuery:(NSString*)userid;
@end

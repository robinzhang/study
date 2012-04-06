//
//  DeatilCommentDataSource.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <CoreLocation/CoreLocation.h>
#import "SnSectionedDataSource.h"
#import "NewsCommentModel.h"
#import "SnMessage.h"


@interface DeatilCommentDataSource :  SnSectionedDataSource
{
    NewsCommentModel *_searchFeedModel;
}
- (id)initWithSearchQuery:(NSString*)messageid userid:(NSString*)userid;
@end

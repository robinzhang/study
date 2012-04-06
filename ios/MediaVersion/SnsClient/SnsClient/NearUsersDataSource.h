//
//  HomeViewDataSource.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNListDataSource.h"
#import "NearUsersModel.h"
#import "UserHelper.h"

@interface NearUsersDataSource : SnListDataSource
{
    NearUsersModel* _searchFeedModel;
}
- (id)initWithSearchQuery:(CLLocation*)location range:(NSString*)range;
@end

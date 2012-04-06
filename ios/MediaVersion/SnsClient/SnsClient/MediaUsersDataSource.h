//
//  MediaUsersDataSource.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnListDataSource.h"
#import "MediaUsersModel.h"
#import "UserProfile.h"

@interface MediaUsersDataSource : SnListDataSource
{
    MediaUsersModel *_searchFeedModel;
}
- (id)initWithSearchQuery:(NSString*)userid;


@end

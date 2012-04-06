//
//  UeventDataSource.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnListDataSource.h"
#import "UeventModel.h"

@interface UeventDataSource : SnListDataSource
{
      UeventModel *_searchFeedModel;
}
@end

//
//  MessageVisterDataSource.h
//  Kanguo
//
//  Created by zhan xiaoping on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageVisterModel.h"
#import "SnListDataSource.h"
#import "SnTableMessageItem.h"

@interface MessageVisterDataSource : SnListDataSource
{
    MessageVisterModel* _searchFeedModel;
}
- (id)initWithQuery:(NSString*)userid messageid:(NSString*)messageid;
@end

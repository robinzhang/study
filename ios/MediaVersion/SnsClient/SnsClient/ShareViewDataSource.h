//
//  PublicViewDataSource.h
//  SnsClient
//
//  Created by  on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnListDataSource.h"
#import "ShareViewModel.h"

@interface ShareViewDataSource : SnListDataSource
{
     ShareViewModel *_searchFeedModel;
}
- (id)initWithSearchQuery:(NSString*)userid range:(NSUInteger)range location:(CLLocation*)location sendType:(NSUInteger)sendType sendModel:(NSUInteger)sendModel;
@end

//
//  HomeViewDataSource.h
//  SnsClient
//
//  Created by  on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol UserPostUpdateDelegate
- (void)didDeleteFinished:(int)index;
//- (void)didDeleteError;
//- (void)didStartDelete;
@end


#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import "ASIFormDataRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "SnListDataSource.h"
#import "UserPostViewModel.h"
#import "SnMessage.h"


@interface UserPostViewDataSource : SnListDataSource
{
    UserPostViewModel *_searchFeedModel;
    id<UserPostUpdateDelegate> _UpdateDelegate;
}
- (id)initWithSearchQuery:(NSString*)userid accountid:(NSString*)accountid lat:(float)lat lon:(float)lon model:(int)model;
//-(void)deleteItem:(NSString*)uid pid:(NSString*)pid;
@property (nonatomic, assign) id<UserPostUpdateDelegate> UpdateDelegate;
@end

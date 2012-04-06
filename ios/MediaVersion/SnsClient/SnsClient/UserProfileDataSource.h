//
//  UserProfileDataSource.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnSectionedDataSource.h"
#import "UcenterViewModel.h"
#import "StyleSheet.h"
#import "UserHelper.h"

@interface UserProfileDataSource : SnSectionedDataSource<UIAlertViewDelegate>
{
    UcenterViewModel *_UcenterViewModel;
}
-(id)initWithUserId:(NSString*)userid;
@end

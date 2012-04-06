//
//  UcenterViewDataSource.h
//  SnsClient
//
//  Created by  on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnSectionedDataSource.h"
#import "UcenterViewModel.h"
#import "StyleSheet.h"
#import "UserHelper.h"
#import "LogonViewController.h"

@interface UcenterViewDataSource : SnSectionedDataSource<UIAlertViewDelegate>
{
    UcenterViewModel *_UcenterViewModel;
}
-(id)initWithUserId:(NSString*)userid;
-(id)initWithProfile:(UserProfile *)profile;
-(void)SetItemsByProfile:(UserProfile *)profile;
@end

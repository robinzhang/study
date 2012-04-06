//
//  LocalNewsViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalNewsModel.h"
#import "LocalNewsDataSource.h"
#import "MessageDetailController.h"
#import "UserPostViewDataSource.h"
#import "UserPostViewModel.h"
#import "SnListDataSource.h"
#import "SnInfoView.h"

@interface LocalNewsViewController : SnTableViewController<TTTabDelegate>
{
    //CLLocation *_currentLocation;
    NSMutableArray*  _posts;
    NSString *_me;
    LocalNewsDataSource *datasource0;
    LocalNewsDataSource *datasource1;
    int _seIndex;
    SnInfoView *errorinfoview;
}
//@property (nonatomic, retain) CLLocation* currentLocation;
@property (nonatomic, copy)  NSString *me;
@end

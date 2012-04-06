//
//  FavoritesViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHelper.h"
#import "FavoritesDataSource.h"
#import "FavoritesModel.h"
#import "MessageDetailController.h"

@interface FavoritesViewController : SnTableViewController
{
    NSString *_me;
    NSString *_queryUserid;
    NSMutableArray*  _posts;
}
@property (nonatomic,copy) NSString *queryUserid;
@property (nonatomic,copy) NSString *me;
-(id)initWidthUserId:(NSString*)queryUserid;
@end

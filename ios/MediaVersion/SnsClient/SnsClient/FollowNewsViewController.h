//
//  FollowNewsViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPostViewDataSource.h"
#import "MessageDetailController.h"

@interface FollowNewsViewController : SnTableViewController<TTTabDelegate>
{
    NSString *_me;
    //NSString *_queryUserid;
    NSMutableArray *_posts;
    UserPostViewDataSource *datasource0;
    UserPostViewDataSource *datasource1;
}
//@property (nonatomic,copy) NSString *queryUserid;
@property (nonatomic,copy) NSString *me;
-(id)initWidthUserId:(NSString*)queryUserid;
@end

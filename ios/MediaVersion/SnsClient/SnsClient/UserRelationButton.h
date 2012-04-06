//
//  UserRelationButton.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRelationHelper.h"


@interface UserRelationButton : UIButton<UserRelationHelperDelegate>
{
    NSString* myUserId;
    NSString* otherUserId;
    NSString* title;
    UserRelationHelper* userUtil;
}

@property (nonatomic,retain)  NSString* myUserId;
@property (nonatomic,retain) NSString* otherUserId;

-(void)checkStatus;
- (id)initWithUserid:(NSString*)myselfUserId aotherUserId:(NSString*)aotherUserId;
@end

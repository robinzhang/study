//
//  UserRelationHelper.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserRelationHelperDelegate
- (void)CheckUserRelationSuccess:(int)tag;
@end

#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import <extThree20JSON/SBJsonParser.h>


@interface UserRelationHelper : NSObject<TTURLRequestDelegate>
{
    id<UserRelationHelperDelegate> _delegate;
}
@property (nonatomic, assign) id<UserRelationHelperDelegate> delegate;
-(void)follow:(NSString*)myselfUserId willFollowUserId:(NSString*)willFollowUserId;
-(void)unFollow:(NSString*)myselfUserId willUnFollowUserId:(NSString*)willUnFollowUserId;
-(void)checkUserRelation:(NSString*)myselfUserId otherUserId:(NSString*)otherUserId;
@end

//
//  UserRelationButton.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserRelationButton.h"

@implementation UserRelationButton 
@synthesize myUserId=myUserId,otherUserId=otherUserId;


- (void)checkStatus{
    if(!userUtil)
        userUtil = [[UserRelationHelper alloc] init];
    [userUtil checkUserRelation:self.myUserId otherUserId:otherUserId];
}


- (void)onClick{
    if(![UserHelper isLogon])
    {
        TTOpenURL(@"tt://logon");
        return;
    }
    
    if(!userUtil)
        userUtil = [[UserRelationHelper alloc] init];
    self.enabled = NO;
    switch (self.tag) {
        case 0:
            [userUtil follow:self.myUserId willFollowUserId:otherUserId];
            break;
        case 1:
            [userUtil unFollow:self.myUserId willUnFollowUserId:otherUserId];
            break;
        case 2:
            [userUtil follow:self.myUserId willFollowUserId:otherUserId];
            break;
        case 3:
            [userUtil unFollow:self.myUserId willUnFollowUserId:otherUserId];
            break;
        default:
            break;
    }
    [self checkStatus];
}


//- (void)loadStatus:(NSNotification*)notification{
- (void)CheckUserRelationSuccess:(int)tag
{
    self.tag=tag;
    switch (tag) {
        case 0:
            //[self setTitle:NSLocalizedString(@"   Follow", @"   Follow") forState:UIControlStateNormal];
            [self setBackgroundImage:TTIMAGE(@"bundle://annu_Rec_ygz.png") forState:UIControlStateNormal];
            break;
        case 1:
            //[self setTitle:NSLocalizedString(@"   UnFollow", @"   Follow") forState:UIControlStateNormal];
            [self setBackgroundImage:TTIMAGE(@"bundle://annu_Rec_gz.png") forState:UIControlStateNormal];
            break;
        case 3: 
            //[self setTitle:NSLocalizedString(@"   UnFollow", @"   Follow") forState:UIControlStateNormal];
            [self setBackgroundImage:TTIMAGE(@"bundle://annu_Rec_gz.png") forState:UIControlStateNormal];
            break;
        case 2:
            //[self setTitle:NSLocalizedString(@"   Follow", @"   Follow") forState:UIControlStateNormal];
            [self setBackgroundImage:TTIMAGE(@"bundle://annu_Rec_ygz.png") forState:UIControlStateNormal];
            break;
        default:
            //[self setTitle:NSLocalizedString(@"   Follow", @"   Follow") forState:UIControlStateNormal];
            [self setBackgroundImage:TTIMAGE(@"bundle://annu_Rec_ygz.png") forState:UIControlStateNormal];
            break;
    }
    self.enabled = YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUserid:(NSString*)myselfUserId aotherUserId:(NSString*)aotherUserId
{
    self = [super init];
    if (self) {
        //[self init];
        self.myUserId=myselfUserId;
        self.otherUserId=aotherUserId;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self 
//                                                      selector:@selector(loadStatus:) 
//                                                          name:@"CheckUserRelationSuccess" 
//                                                        object:nil];
        userUtil = [[UserRelationHelper alloc] init];
        userUtil.delegate = self;
        
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void)dealloc
{
    [userUtil release];
    [super dealloc];
}

@end


//
//  UserProfile.h
//  SnsClient
//
//  Created by  on 11-10-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject <NSCoding>
{
    NSString *_UserName; 
    NSString *_UserID;
    NSString *_Email;
    NSString *_Intro;
    NSString *_UserFace;

    int _FansCount;
    int _FollowerCount;
    int _FriendCount;
    int _MessageCount;
    
    NSDate *_CreateTime;
    double _Latitude;
    double _Longitude;
    int _Sex;
    int _UserType;
}
@property (nonatomic,assign) int UserType;
@property (nonatomic,assign) int Sex;
@property (nonatomic,copy) NSString *Email;
@property (nonatomic,copy) NSString *UserName;
@property (nonatomic,copy) NSString *UserID;
@property (nonatomic,copy) NSString *Intro;
@property (nonatomic,copy) NSString *UserFace;
@property (nonatomic,assign) int FansCount;
@property (nonatomic,assign) int FriendCount;
@property (nonatomic,assign) int FollowerCount;
@property (nonatomic,assign) int MessageCount;

@property (nonatomic,copy) NSDate *CreateTime;
@property (nonatomic,assign) double Latitude;
@property (nonatomic,assign) double Longitude;
@end

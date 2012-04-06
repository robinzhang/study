//
//  UserProfile.m
//  SnsClient
//
//  Created by  on 11-10-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile
@synthesize UserName = _UserName;
@synthesize UserID = _UserID;
@synthesize Email = _Email;
@synthesize Intro = _Intro;
@synthesize MessageCount = _MessageCount;
@synthesize FansCount = _FansCount;
@synthesize FollowerCount = _FollowerCount;
@synthesize FriendCount = _FriendCount;
@synthesize UserFace = _UserFace;
@synthesize Longitude = _Longitude;
@synthesize Latitude = _Latitude;
@synthesize CreateTime = _CreateTime;
@synthesize Sex = _Sex;
@synthesize UserType = _UserType;

-(id)init
{
    self = [super init];
    if(self)
    {
        self.UserName = @"";
        self.UserID = @"";
        self.Email = @"";
        self.Intro = @"";
        self.MessageCount = 0;
        self.FansCount = 0;
        self.FollowerCount = 0;
        self.FriendCount = 0;
        self.UserFace = @"";
        self.Sex = 2;
        self.UserType = 0;
        self.Longitude = KDefaultLatitude;
        self.Latitude = KDefaultLongitude;
        self.CreateTime = [NSDate date];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
	self = [self init];
    if (self) {
        self.UserName = [NSString stringWithFormat:@"%@", [decoder decodeObjectForKey:@"u_UserName"]];
        self.UserID = [NSString stringWithFormat:@"%@", [decoder decodeObjectForKey:@"u_UserID"]];
        self.Email = [NSString stringWithFormat:@"%@", [decoder decodeObjectForKey:@"u_Email"]];
        self.Intro = [NSString stringWithFormat:@"%@", [decoder decodeObjectForKey:@"u_Intro"]];
        self.MessageCount = [[decoder decodeObjectForKey:@"u_MessageCount"] intValue];
        self.FansCount = [[decoder decodeObjectForKey:@"u_FansCount"] intValue];
        self.FollowerCount = [[decoder decodeObjectForKey:@"u_FollowerCount"] intValue];
        self.FriendCount = [[decoder decodeObjectForKey:@"u_FriendCount"] intValue];
        self.UserFace = [decoder decodeObjectForKey:@"u_UserFace"];
        self.Sex = [[decoder decodeObjectForKey:@"u_Sex"] intValue];
        self.UserType = [[decoder decodeObjectForKey:@"UserType"] intValue];
        if(TTIsStringWithAnyText([decoder decodeObjectForKey:@"u_Longitude"]))
            self.Longitude = [[decoder decodeObjectForKey:@"u_Longitude"] doubleValue];
        if(TTIsStringWithAnyText([decoder decodeObjectForKey:@"u_Latitude"]))
            self.Latitude = [[decoder decodeObjectForKey:@"u_Latitude"] doubleValue];
        if(TTIsStringWithAnyText([decoder decodeObjectForKey:@"u_CreateTime"]))
            self.CreateTime = [decoder decodeObjectForKey:@"u_CreateTime"];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    //[super encodeWithCoder:encoder];
    if(self.UserName)
        [encoder encodeObject:self.UserName forKey:@"u_UserName"];
    if(self.UserID)
        [encoder encodeObject:self.UserID forKey:@"u_UserID"];
    if(self.Email)
        [encoder encodeObject:self.Email forKey:@"u_Email"];
    if(self.Intro)
        [encoder encodeObject:self.Intro forKey:@"u_Intro"];
    if(self.Sex)
        [encoder encodeObject:[NSString stringWithFormat:@"%d", self.Sex] forKey:@"u_Sex"];
    if(self.UserType)
        [encoder encodeObject:[NSString stringWithFormat:@"%d", self.UserType] forKey:@"UserType"];
    if(self.MessageCount)
        [encoder encodeObject:[NSString stringWithFormat:@"%d", self.MessageCount] forKey:@"u_MessageCount"];
    if(self.FansCount)
        [encoder encodeObject:[NSString stringWithFormat:@"%d", self.FansCount] forKey:@"u_FansCount"];
    if(self.FollowerCount)
        [encoder encodeObject:[NSString stringWithFormat:@"%d", self.FollowerCount] forKey:@"u_FollowerCount"];
    if(self.FriendCount)
        [encoder encodeObject:[NSString stringWithFormat:@"%d", self.FriendCount] forKey:@"u_FriendCount"];
    if(self.UserFace)
        [encoder encodeObject:self.UserFace forKey:@"u_UserFace"];
    if(self.Longitude)
        [encoder encodeObject:[NSString stringWithFormat:@"%f",self.Longitude] forKey:@"u_Longitude"];
    if(self.Latitude)
        [encoder encodeObject:[NSString stringWithFormat:@"%f",self.Latitude] forKey:@"u_Latitude"];
    if(self.CreateTime)
        //    {
        //NSString *timeStr = [self.CreateTime formatDateTime]; 
        [encoder encodeObject:self.CreateTime   forKey:@"u_CreateTime"];
    //    }
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_UserFace)
    TT_RELEASE_SAFELY(_Intro)
    TT_RELEASE_SAFELY(_Email)
    TT_RELEASE_SAFELY(_UserName)
    TT_RELEASE_SAFELY(_UserID)
    TT_RELEASE_SAFELY(_CreateTime)
    [super dealloc];
}
@end

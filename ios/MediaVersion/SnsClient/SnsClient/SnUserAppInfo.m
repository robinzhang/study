//
//  SnUserAppInfo.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnUserAppInfo.h"

@implementation SnUserAppInfo
@synthesize UserID = _UserID;
@synthesize LastMapRange = _LastMapRange;
@synthesize LastMapZoomX = _LastMapZoomX;
@synthesize LastMapZoomY = _LastMapZoomY;
@synthesize MapCenterLa = _MapCenterLa;
@synthesize MapCenterLo = _MapCenterLo;
@synthesize KLastNotifyTime = _KLastNotifyTime;
@synthesize LastVesion = _LastVesion;
@synthesize WeiBoUserID = _WeiBoUserID;
@synthesize HaveNewMessage = _HaveNewMessage;
@synthesize CommentCount = _CommentCount;
@synthesize PrivteMessageCount = _PrivteMessageCount;
@synthesize LocationDidChange = _LocationDidChange;
@synthesize MapCenterChange = _MapCenterChange;
-(id)init
{
    self = [super init];
    if(self) 
    {
        self.LastMapRange  = 15000;
        self.MapCenterLa =KDefaultLatitude;
        self.MapCenterLo =KDefaultLongitude;
        self.LastMapZoomX = 0.1f;
        self.LastMapZoomY = 0.1f;
        self.KLastNotifyTime = [NSDate date];
        self.LastVesion = 0;
        self.WeiBoUserID = @"";
        self.HaveNewMessage = YES;
        self.PrivteMessageCount = 0;
        self.CommentCount = 0;
        self.WeiBoUserID = @"";
        self.LocationDidChange = NO;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
	self = [self init];
    if (self) {
        self.UserID = [NSString stringWithFormat:@"%@", [decoder decodeObjectForKey:@"UserID"]];
        self.WeiBoUserID = [decoder decodeObjectForKey:@"WeiBoUserID"];
        self.LastMapRange = [decoder decodeIntegerForKey:@"LastMapRange"];
        if([decoder decodeFloatForKey:@"LastMapZoomX"])
            self.LastMapZoomX = [decoder decodeFloatForKey:@"LastMapZoomX"];
        if([decoder decodeFloatForKey:@"LastMapZoomY"])
            self.LastMapZoomY = [decoder decodeFloatForKey:@"LastMapZoomY"];
        self.HaveNewMessage = [decoder decodeBoolForKey:@"HaveNewMessage"];
        self.LocationDidChange = [decoder decodeBoolForKey:@"LocationDidChange"];
        self.MapCenterChange = [decoder decodeBoolForKey:@"MapCenterChange"];
        self.PrivteMessageCount = [decoder decodeIntForKey:@"PrivteMessageCount"];
        self.CommentCount = [decoder decodeIntForKey:@"CommentCount"];
        
        if([decoder  decodeObjectForKey:@"KLastNotifyTime"])
            self.KLastNotifyTime = [decoder  decodeObjectForKey:@"KLastNotifyTime"];
        if( [decoder  decodeFloatForKey:@"LastVesion"])
            self.LastVesion = [decoder  decodeFloatForKey:@"LastVesion"];
        
        if([decoder decodeFloatForKey:@"Latitude"] &&  [decoder decodeFloatForKey:@"Longitude"])
        {
            self.MapCenterLa = [decoder decodeFloatForKey:@"Latitude"];
            self.MapCenterLo  = [decoder decodeFloatForKey:@"Longitude"];
        }
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    if(self.UserID)
        [encoder encodeObject:self.UserID forKey:@"UserID"];
    if(self.WeiBoUserID)
        [encoder encodeObject:self.WeiBoUserID forKey:@"WeiBoUserID"];
    if(self.LastMapRange)
        [encoder  encodeInteger:self.LastMapRange forKey:@"LastMapRange"];
    if(self.LastMapZoomX)
        [encoder encodeFloat:self.LastMapZoomX forKey:@"LastMapZoomX"];
    if(self.LastMapZoomY)
        [encoder encodeFloat:self.LastMapZoomY forKey:@"LastMapZoomY"];
    if(self.MapCenterLa && self.MapCenterLo)
    {
        [encoder encodeFloat:self.MapCenterLa forKey:@"Latitude"];
        [encoder encodeFloat:self.MapCenterLo forKey:@"Longitude"];
    }
    
    if(self.KLastNotifyTime)
        [encoder encodeObject:self.KLastNotifyTime   forKey:@"KLastNotifyTime"];
    if(self.LastVesion)
        [encoder encodeFloat:self.LastVesion forKey:@"LastVesion"];
    
    [encoder encodeBool:self.MapCenterChange forKey:@"MapCenterChange"];
    [encoder encodeBool:self.HaveNewMessage forKey:@"HaveNewMessage"];
    [encoder encodeBool:self.LocationDidChange forKey:@"LocationDidChange"];
    [encoder encodeInt:self.CommentCount forKey:@"CommentCount"];
    [encoder encodeInt:self.PrivteMessageCount forKey:@"PrivteMessageCount"];
}


- (void)dealloc {
    TT_RELEASE_SAFELY(_WeiBoUserID);
    TT_RELEASE_SAFELY(_UserID);
    [super dealloc];
}
@end

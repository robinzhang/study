//
//  SnAppSetting.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnAppSetting.h"

@implementation SnAppSetting
@synthesize UserID = _UserID;
@synthesize NotifySettings = _NotifySettings;
@synthesize KPMNotifySetting = _KPMNotifySetting;
@synthesize KNotifyStartTime = _KNotifyStartTime;
@synthesize KNotifyEndTime = _KNotifyEndTime;
@synthesize KBatterySaveMode = _KBatterySaveMode;

-(id)init
{
    self = [super init];
    if(self) 
    {
        self.KNotifyStartTime  =6;
        self.KNotifyEndTime  = 24;
        self.NotifySettings = 256 | 512;
        self.KPMNotifySetting = 1;
        self.KBatterySaveMode = 1;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
	self = [self init];
    if (self) {
        self.UserID = [NSString stringWithFormat:@"%@", [decoder decodeObjectForKey:@"UserID"]];
        self.NotifySettings = [decoder decodeIntegerForKey:@"NotifySettings"];
        self.KPMNotifySetting = [decoder decodeIntegerForKey:@"KPMNotifySetting"];
        self.KNotifyStartTime =  [decoder decodeIntegerForKey:@"KNotifyStartTime"];
//        if(self.KNotifyStartTime <= 0)
//            self.KNotifyStartTime = 6;
        self.KNotifyEndTime = [decoder decodeIntegerForKey:@"KNotifyEndTime"];
//        if(self.KNotifyEndTime <= 0)
//            self.KNotifyEndTime = 24;
        self.KBatterySaveMode = [decoder decodeBoolForKey:@"KBatterySaveMode"];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    if(self.UserID)
        [encoder encodeObject:self.UserID forKey:@"UserID"];
    if(self.NotifySettings)
         [encoder  encodeInteger:self.NotifySettings forKey:@"NotifySettings"];
    if(self.KPMNotifySetting)
         [encoder encodeInteger:self.KPMNotifySetting forKey:@"KNotifyStartTime"];
    if(self.KNotifyStartTime)
         [encoder encodeInteger:self.KNotifyStartTime forKey:@"KNotifyStartTime"];
    if(self.KNotifyEndTime)
       [encoder encodeInteger:self.KNotifyEndTime forKey:@"KNotifyEndTime"];
    
    [encoder encodeBool:self.KBatterySaveMode forKey:@"KBatterySaveMode"];
}


- (void)dealloc {
    TT_RELEASE_SAFELY(_UserID)
    [super dealloc];
}
@end

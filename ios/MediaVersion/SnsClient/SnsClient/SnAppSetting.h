//
//  SnAppSetting.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnAppSetting : NSObject<NSCoding>
{
     NSString *_UserID;
     NSInteger _NotifySettings;
     NSInteger _KPMNotifySetting;
     NSInteger _KNotifyStartTime;
     NSInteger _KNotifyEndTime;
     bool _KBatterySaveMode;
}
@property (nonatomic,copy) NSString *UserID;
@property (nonatomic,assign) NSInteger NotifySettings;
@property (nonatomic,assign) NSInteger KPMNotifySetting;
@property (nonatomic,assign) NSInteger KNotifyStartTime;
@property (nonatomic,assign) NSInteger KNotifyEndTime;
@property (nonatomic,assign) bool KBatterySaveMode;
@end

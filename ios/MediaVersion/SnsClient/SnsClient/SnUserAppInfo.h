//
//  SnUserAppInfo.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SnUserAppInfo :  NSObject<NSCoding>
{
     NSString *_UserID;
     NSInteger _LastMapRange;
     float _LastMapZoomX;
     float _LastMapZoomY;
     float _MapCenterLa;
     float _MapCenterLo;
     bool _MapCenterChange;
     NSDate * _KLastNotifyTime;
     float _LastVesion;
     NSString *_WeiBoUserID;
     bool _HaveNewMessage;
     bool _LocationDidChange;
     int _CommentCount;
     int _PrivteMessageCount;
}
@property (nonatomic,assign) int CommentCount;
@property (nonatomic,assign) int PrivteMessageCount;
@property (nonatomic,assign) bool HaveNewMessage;
@property (nonatomic,assign) bool LocationDidChange;
@property (nonatomic,assign) bool MapCenterChange;
@property (nonatomic,assign) float LastVesion;
@property (nonatomic,copy) NSString *UserID;
@property (nonatomic,copy) NSString *WeiBoUserID;
@property (nonatomic,assign) NSInteger LastMapRange;
@property (nonatomic,assign) float LastMapZoomX;
@property (nonatomic,assign) float LastMapZoomY;
@property (nonatomic,assign) float MapCenterLa;
@property (nonatomic,assign) float MapCenterLo;
@property (nonatomic,copy) NSDate* KLastNotifyTime;
@end

//
//  LocaltionHelper.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@protocol SnAppLocationDelegate<NSObject>
- (void)didGetUserLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
@end


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface LocaltionHelper : NSObject<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    id<SnAppLocationDelegate> _delegate;
     CLLocationManager* locManager;
     bool _useMonitoringSignificantLocationChanges;
}
@property (nonatomic,assign) CLLocationManager* locManager;
@property (nonatomic,assign) bool useMonitoringSignificantLocationChanges;
@property (nonatomic,assign) id<SnAppLocationDelegate> delegate;
-(void)startUpdatingLocation;

+ (LocaltionHelper*)sharedInstance;
@end

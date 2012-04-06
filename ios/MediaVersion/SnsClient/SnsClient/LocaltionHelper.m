//
//  LocaltionHelper.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LocaltionHelper.h"
#import "NotifyMessageHelper.h"

@implementation LocaltionHelper
@synthesize delegate = _delegate ,locManager,useMonitoringSignificantLocationChanges = _useMonitoringSignificantLocationChanges;

LocaltionHelper *shareLocaltionHelper;
+ (LocaltionHelper*)sharedInstance
{
    if(shareLocaltionHelper == nil)
    {
        shareLocaltionHelper = [[LocaltionHelper alloc] init];     
        shareLocaltionHelper.useMonitoringSignificantLocationChanges = YES;
    }
    return shareLocaltionHelper;
}


-(id)init
{
    self = [super init];
    if(self)
    {
        _useMonitoringSignificantLocationChanges = NO;
    }
    return  self;
}

-(void)startUpdatingLocation
{
    [self.locManager startUpdatingLocation];
}

- (CLLocationManager *)locManager{
	
    if (locManager != nil) {
		return locManager;
	}
	
	locManager = [[CLLocationManager alloc]  init];
	[locManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locManager setDelegate:self];
	return locManager;
}


#pragma mark locationManager
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"index:%d",buttonIndex);
    if (alertView.tag == 234 &&  buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status!=kCLAuthorizationStatusAuthorized) {
        //NSLog(@"kCLAuthorizationStatusAuthorized");
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (error.code==kCLErrorDenied) {
        if ([userDefaults boolForKey:KLocationReqireAlerted]) {
            return;
        }
        
        UIAlertView *alertDialog;
        
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: NSLocalizedString(@"Notice", @"警告") 
                       message:NSLocalizedString(@"Location Permission Request", @"不允许看过使用定位服务会使您无法收到来自朋友的任何消息，请在系统设置中重新打开。")
                       delegate: self 
                       cancelButtonTitle: NSLocalizedString(@"Cancel", @"Cancel")
                       otherButtonTitles: @"设置",nil];
        
        alertDialog.tag = 234;
        [alertDialog show];
        [alertDialog release];
        
        [userDefaults setBool:YES forKey:KLocationReqireAlerted];
        [userDefaults synchronize];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    
    [manager stopUpdatingLocation];
    if ([newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp]<2) {
        return;
    }
    
    CLLocation *location = [locManager location];
    //////////// 通知获得新位置 ////////////
    if([self.delegate respondsToSelector:@selector(didGetUserLocation:fromLocation:)])
    {
        [UserHelper DegBugWidthLog:@"" title:@"定位：普通成功"];
        [self.delegate didGetUserLocation:location fromLocation:oldLocation];
    }

    if (location.speed>5) {
        manager.desiredAccuracy=kCLLocationAccuracyThreeKilometers;
    }
    else
    {
        manager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    }

    [UserHelper SetUserLocation:location];
    if(self.useMonitoringSignificantLocationChanges)
        [manager startMonitoringSignificantLocationChanges];
    
    /////////// 位置改变 开始取通知 /////////////
    NotifyMessageHelper *notifyMessageHelper = [NotifyMessageHelper sharedInstance];
    [notifyMessageHelper NotifyMessageByLocation:location];
    //[notifyMessageHelper release];
    
    ////////// 位置改变周边数据需要刷新 ///////////
    SnUserAppInfo *info = [UserHelper GetUserAppInfo];
    info.LocationDidChange = YES;
    [UserHelper SetUserAppInfo:info];
    
//    if(!self.useMonitoringSignificantLocationChanges)
//        return;

    [UserHelper DegBugWidthLog:@"" title:@"定位：成功，即将本地通知"];
    //NSString *userid = [UserHelper GetUserID];
    //if(TTIsStringWithAnyText(userid))
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"userDidUpdateToLocationSucc" object:nil];
    
    //////////// do at new threed ////////////////
//    NSDate *da = [NSDate date];
//    NSString *daStr = @"myQueue_notifyMessage";
//    const char *queueName = [daStr UTF8String];
//    dispatch_queue_t myQueue = dispatch_queue_create(queueName, NULL);
//    dispatch_async(myQueue, ^{
//    });
}
-(void)dealloc
{
    [locManager release];
    [super dealloc];
}
@end

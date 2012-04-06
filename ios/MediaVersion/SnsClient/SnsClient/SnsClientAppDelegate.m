//
//  SnsClientAppDelegate.m
//  SnsClient
//
//  Created by  on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import "StyleSheet.h"
#import "NotifyMessageHelper.h"
#import "SnNotificationDataKeyHelper.h"
#import "NotifyMessageHelper.h"
#import "SnsClientAppDelegate.h"
#import "BuildGuestViewController.h"
#import "MainViewController.h"
#import "NearUsersViewController.h"
#import "PublishViewController.h"
#import "ShareViewController.h"
#import "UcenterViewController.h"
#import "MoreViewController.h"
#import "LogonViewController.h"
#import "RegisterViewController.h"
#import "UeventViewController.h"
#import "MessageDetailController.h"
#import "HotAreasViewController.h"
#import "SettingViewController.h"
#import "LocalNewsViewController.h"
#import "MyGroupViewController.h"
#import "UserProfileViewController.h"
#import "UserListViewController.h"
#import "NewsForMeViewController.h"
#import "FollowNewsViewController.h"
#import "InvitationViewController.h"
#import "UserPostsViewController.h"
#import "FavoritesViewController.h"
#import "AboutViewController.h"
#import "UserGuideController.h"
#import "WeiBoHelper.h"
#import "LocaltionHelper.h"
#import "VersionChecker.h"
#import "SnNotificationDataKeyHelper.h"

@implementation SnsClientAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ///////////////  clear location manager key /////////
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:KLocationReqireAlerted];
    [userDefaults synchronize];
    
    /////////// init TTStyleSheet  ////////////
    [TTStyleSheet setGlobalStyleSheet:[[[StyleSheet alloc] init] autorelease]];
    /////////// init nav system //////////////
    [self loadNavigationSystem];
    
    id locationValue = [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey];
	if (locationValue)
	{
		[self beginUpdateLocation];
        return YES;
	}
    
    /////////// local notification ////////////
    UILocalNotification *localNotifyValue=[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotifyValue)
    {
        NSString *uid = [UserHelper GetUserID];
        NSString *sec = [UserHelper GetSecToken];
        if(TTIsStringWithAnyText(uid) && TTIsStringWithAnyText(sec))
        {
            NSDictionary *userInfo= localNotifyValue.userInfo;
            TTOpenURL([userInfo objectForKey:@"message"]);
            //application.applicationIconBadgeNumber--;
        }
    }
    
    //////////// remote notification //////////
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        //Helper *helper=[[Helper alloc] init];
        //NSDictionary *payload=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        //        NSString *uid=[payload objectForKey:@"userId"];
        //        NSString *tid=[payload objectForKey:@"messageId"];
        //        NSString *url=[NSString stringWithFormat:@"tt://message?messageid=%@&userid=%@",tid,uid];
        //        TTOpenURL(url);
        //[helper log:url];
        //[helper release];
    }
    //[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    //ga
    [[GANTracker sharedTracker] startTrackerWithAccountID:GAID
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
    
    [self beginUpdateLocation];
    
    [self performSelector:@selector(beginCheckVersionUpdate) withObject:nil afterDelay:5.0f];  
    return YES;
}

-(void)beginCheckVersionUpdate
{
    [[VersionChecker sharedInstance] CheckVersionUpdate];
}

- (void)loadNavigationSystem
{
    //navigation 
//    TTNavigator* navigator = [TTNavigator navigator];
//    navigator.supportsShakeToReload = YES;
//    navigator.persistenceMode = TTNavigatorPersistenceModeNone;
//    navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeNone;
    
    TTURLMap* map = navigator.URLMap;
    
    //no match url mapping 
    [map            from:@"*" 
        toViewController:[TTWebController class]];
    
    [map            from:@"tt://main"
  toSharedViewController:[MainViewController class]];
    
    [map            from:@"tt://nearusers" 
        toViewController:[NearUsersViewController class]];
    
    [map            from:@"tt://localnews" 
        toViewController:[LocalNewsViewController class]];
    
    
    [map            from:@"tt://mygroup" 
        toViewController:[MyGroupViewController class]];
    

    [map            from:@"tt://share" 
        toViewController:[ShareViewController class]];
    
    [map            from:@"tt://publish" 
                  parent:@"tt://share"
    toModalViewController:[PublishViewController class]
                selector:nil 
              transition:0
     ];
    
    [map            from:@"tt://ucenter" 
        toViewController:[UcenterViewController class]];
    
    [map            from:@"tt://more" 
        toViewController:[MoreViewController class]];
    
    [map            from:@"tt://logon" 
        toModalViewController:[LogonViewController class] 
              transition:0];

    
    [map            from:@"tt://register" 
        toViewController:[RegisterViewController class]];
    
    [map            from:@"tt://uevent" 
        toViewController:[UeventViewController class]];
    
    
    [map            from:@"tt://hotareas" 
        toViewController:[HotAreasViewController class]];
    
    [map            from:@"tt://setting" 
        toViewController:[SettingViewController class]];
    
//    [map            from:@"tt://message"
//        toViewController:[MessageDetailController class]];
    
    [map            from:@"tt://message?messageid=(initWidthMessageid:)"
        toViewController:[MessageDetailController class]];
    
    [map            from:@"tt://uprofile/(initWidthUserId:)" 
        toViewController:[UserProfileViewController class]];
    
    [map            from:@"tt://myfans/(initWidthFans:)" 
        toViewController:[UserListViewController class]];
    
    [map            from:@"tt://myfollow/(initWidthFollow:)" 
        toViewController:[UserListViewController class]];
    
    [map            from:@"tt://myfriends/(initWidthFriends:)" 
        toViewController:[UserListViewController class]];
    
    [map            from:@"tt://newsforme/(initWidthUserId:)" 
        toViewController:[NewsForMeViewController class]];
    
    [map            from:@"tt://follownews/(initWidthUserId:)" 
        toViewController:[FollowNewsViewController class]];
    
    [map            from:@"tt://invitation" 
        toViewController:[InvitationViewController class]];
    
    [map            from:@"tt://myposts" 
        toViewController:[UserPostsViewController class]];
    
    [map            from:@"tt://userposts/(initWidthUserId:)" 
        toViewController:[UserPostsViewController class]];
    
    [map            from:@"tt://myfavorites" 
        toViewController:[FavoritesViewController class]];
    
    [map            from:@"tt://userfavorites/(initWidthUserId:)" 
        toViewController:[FavoritesViewController class]];
    
    [map            from:@"tt://about" 
       toModalViewController:[AboutViewController class]];
    
    [map            from:@"tt://userguide" 
      toModalViewController:[UserGuideController class]];
    
    [map            from:@"tt://buildguest" 
        toViewController:[BuildGuestViewController class] ];

    if (![navigator restoreViewControllers]) {
        SnUserAppInfo *uifo = [UserHelper GetUserAppInfo];
        if(uifo.LastVesion < NowVesion)
            [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://userguide"]];
        else if([UserHelper isLogon] || [UserHelper isGuestLogon])
            [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://main"]];
        else
            [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://buildguest"]];
    }
}


#pragma mark applicatio
- (void)applicationWillResignActive:(UIApplication *)application
{
     [[SnNotificationDataKeyHelper sharedInstance] StopUpdateNotification];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

-(void)beginNotificationDataKey
{
    [[SnNotificationDataKeyHelper sharedInstance] StartUpdateNotification];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self performSelector:@selector(beginNotificationDataKey) withObject:nil afterDelay:10.0f];
    
}


-(void)beginUpdateLocation
{
    //////////// do at new threed ////////////////
    LocaltionHelper *helper = [LocaltionHelper sharedInstance];
    [helper startUpdatingLocation];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    ///////// 下次打开就是本地 ///////////////
    NSString*uid = [UserHelper GetUserID];
    if(TTIsStringWithAnyText(uid))
    {
        SnUserAppInfo* setting = [UserHelper GetUserAppInfo];
        setting.MapCenterLa = [UserHelper GetUserLocation].coordinate.latitude;
        setting.MapCenterLo = [UserHelper GetUserLocation].coordinate.longitude;

        [UserHelper SetUserAppInfo:setting];
        [setting release];
    }
}

- (void)dealloc
{
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    WeiBoHelper *weiBoHelper = [WeiBoHelper sharedInstance];
	if( [weiBoHelper.weibo handleOpenURL:url] )
		return TRUE;
	
	return TRUE;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    WeiBoHelper *weiBoHelper = [WeiBoHelper sharedInstance];
	if([weiBoHelper.weibo handleOpenURL:url] )
		return TRUE;
	
	return TRUE;
}
@end

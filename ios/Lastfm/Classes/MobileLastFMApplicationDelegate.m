/* MobileLastFMApplication.m - Main application controller
 * 
 * Copyright 2011 Last.fm Ltd.
 *   - Primarily authored by Sam Steele <sam@last.fm>
 *
 * This file is part of MobileLastFM.
 *
 * MobileLastFM is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * MobileLastFM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MobileLastFM.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "Three20/Three20.h"
#import "NSString+MD5.h"
#import "MobileLastFMApplicationDelegate.h"
#import "ProfileViewController.h"
#import "RadioListViewController.h"
#import "PlaybackViewController.h"
#import "EventsTabViewController.h"
#include "version.h"
#include <SystemConfiguration/SCNetworkReachability.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NSString+URLEscaped.h"
#import "NSData+Compress.h"
#import "HomeViewController.h"
#import "SHK.h"
#import "UIApplication+openURLWithWarning.h"
#if !(TARGET_IPHONE_SIMULATOR)
#import "FlurryAnalytics.h"
#endif
#ifndef DISTRIBUTION
#import "TestFlight.h"
#endif

NSString *kUserAgent;

@implementation MobileLastFMAppWindow
- (void)remoteControlReceivedWithEvent:(UIEvent*)theEvent {
	if (theEvent.type == UIEventTypeRemoteControl) {
		switch(theEvent.subtype) {
			case UIEventSubtypeRemoteControlPlay:
				[[LastFMRadio sharedInstance] play];
				break;
			case UIEventSubtypeRemoteControlPause:
				[[LastFMRadio sharedInstance] pause];
				break;
			case UIEventSubtypeRemoteControlTogglePlayPause:
				if([LastFMRadio sharedInstance].state == TRACK_PAUSED) {
					[[LastFMRadio sharedInstance] play];
				} else {
					[[LastFMRadio sharedInstance] pause];
				}
				break;
			case UIEventSubtypeRemoteControlStop:
				[[LastFMRadio sharedInstance] stop];
				[(MobileLastFMApplicationDelegate *)[UIApplication sharedApplication].delegate hidePlaybackView];
				break;
			case UIEventSubtypeRemoteControlNextTrack:
				[(MobileLastFMApplicationDelegate *)[UIApplication sharedApplication].delegate skipButtonPressed:nil];
				break;
			case UIEventSubtypeRemoteControlBeginSeekingBackward:
				if(((MobileLastFMApplicationDelegate *)[UIApplication sharedApplication].delegate).playbackViewController)
					[(MobileLastFMApplicationDelegate *)[UIApplication sharedApplication].delegate loveButtonPressed:((MobileLastFMApplicationDelegate *)[UIApplication sharedApplication].delegate).playbackViewController.loveBtn];
				break;
			case UIEventSubtypeRemoteControlBeginSeekingForward:
				[(MobileLastFMApplicationDelegate *)[UIApplication sharedApplication].delegate banButtonPressed:nil];
				break;
			default:
				return;
		}
	}
}
@end

@implementation MobileLastFMApplicationDelegate

@synthesize window;
@synthesize firstRunView;
@synthesize playbackViewController;
@synthesize rootViewController;

- (void)applicationWillTerminate:(UIApplication *)application {
	if([[LastFMRadio sharedInstance] state] != RADIO_IDLE)
		[[LastFMRadio sharedInstance] stop];
	
	[_scrobbler saveQueue];
}
-(void)_cleanCache {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[NSThread setThreadPriority:0.1];
	
	NSDirectoryEnumerator *e = [[NSFileManager defaultManager] enumeratorAtPath:NSTemporaryDirectory()];
	NSString *file;
	
	NSLog(@"Checking for stale cache files in the background...\n");
	while((file = [e nextObject])) {
		NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:file];
		NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
		if([attr objectForKey:NSFileType] == NSFileTypeRegular && 
			 ![file isEqualToString:@"recent.db"] &&
			 ![file isEqualToString:@"queue.plist"] &&
			 ([[attr objectForKey:NSFileModificationDate] timeIntervalSinceNow] * -1) > 7*DAYS) {
			NSLog(@"Removing stale cache file: %@ (%f days old)\n", file, ([[attr objectForKey:NSFileModificationDate] timeIntervalSinceNow] * -1) / DAYS);
			[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
		}
	}
	NSLog(@"Finished checking for stale cache files.\n");
	[pool release];
}
- (id)init {
	if (self = [super init]) {
		kUserAgent = [[NSString alloc] initWithFormat:@"MobileLastFM/%@ (%@; %@; %@ %@)", VERSION, [UIDevice currentDevice].model, [[[NSUserDefaults standardUserDefaults] objectForKey: @"AppleLanguages"] objectAtIndex:0], [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
		NSLog(@"%@", kUserAgent);
		if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
			NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
		}
		[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
																														 [NSNumber numberWithFloat: 0.8], @"volume",
																														 @"YES", @"scrobbling",
																														 @"YES", @"disableautolock",
																														 @"YES", @"showontour",
																														 @"64", @"bitrate",
																														 @"0", @"trial_playsleft",
																														 @"0", @"trial_expired",
																														 @"0", @"trial_playselapsed",
																														 @"YES", @"kEnablePinchMediaStatsCollection",
																														 @"YES", @"headsetinterrupt",
																														 nil]];
		if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"scrobbling"] isKindOfClass:[NSString class]])
			[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"scrobbling"];
		
		if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"kEnablePinchMediaStatsCollection"] isKindOfClass:[NSString class]])
			[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"kEnablePinchMediaStatsCollection"];
		
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[NSThread detachNewThreadSelector:@selector(_cleanCache) toTarget:self withObject:nil];
	}
	return self;
}
- (void)_logout {
	if([[LastFMRadio sharedInstance] state] != RADIO_IDLE)
		[[LastFMRadio sharedInstance] stop];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastfm_user"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastfm_session"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[LastFMService sharedInstance].session = nil;
	[[LastFMRadio sharedInstance] purgeRecentURLs];
	[_scrobbler cancelTimer];
	[_scrobbler release];
	_scrobbler = nil;
	NSDirectoryEnumerator *e = [[NSFileManager defaultManager] enumeratorAtPath:NSTemporaryDirectory()];
	NSString *file;
	
	NSLog(@"Emptying cache...\n");
	while((file = [e nextObject])) {
		NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:file];
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	}
	NSLog(@"Finished emptying cache\n");
	[self showFirstRunView:YES];
}
- (void)logoutButtonPressed:(id)sender {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOGOUT_TITLE", @"Logout confirmation title")
																									 message:NSLocalizedString(@"LOGOUT_BODY",@"Logout confirmation")
																									delegate:self
																				 cancelButtonTitle:NSLocalizedString(@"Cancel", @"cancel")
																				 otherButtonTitles:NSLocalizedString(@"Logout", @"Logout"), nil] autorelease];
	[alert show];
}
- (void)applicationWillResignActive:(UIApplication *)application {
	_locked = YES;
	if(playbackViewController != nil)
		[playbackViewController resignActive];
	if(![self isPlaying]) {
		if( [[UIApplication sharedApplication] respondsToSelector:@selector(endReceivingRemoteControlEvents)])
			[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	}
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
	[window makeKeyAndVisible];
	[((UINavigationController *)rootViewController.selectedViewController) performSelector:@selector(viewWillAppear:) withObject:nil afterDelay:0.1];
	_locked = NO;
	if(_pendingAlert)
		[_pendingAlert show];
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[LastFMRadio sharedInstance] lowOnMemory];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Logout", @"Logout")])
		[self performSelectorOnMainThread:@selector(_logout) withObject:nil waitUntilDone:YES];
	if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Info"])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.last.fm/stationchanges2010"]];
	if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Start Trial"]) {
		[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"trial_playselapsed"];
		[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"trial_almost_over_warning"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self performSelector:@selector(playRadioStation:animated:) withObject:_trialAlertStation afterDelay:1];
	}

	if(_pendingAlert) {
		[_pendingAlert release];
		_pendingAlert = nil;
	}
	if(_trialAlert) {
		[_trialAlert release];
		_trialAlert = nil;
		[_trialAlertStation release];
		_trialAlertStation = nil;
	}
}
- (void)showProfileView:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	if(!_scrobbler) {
		_scrobbler = [[Scrobbler alloc] init];
	}

	[LastFMService sharedInstance].session = [[NSUserDefaults standardUserDefaults] objectForKey: @"lastfm_session"];
	NSDictionary *info = [[LastFMService sharedInstance] getSessionInfo];

	if([[info objectForKey:@"country"] length]) {
		[[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"country"] forKey:@"country"];
	}
	if([[info objectForKey:@"subscriber"] length]) {
		[[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"subscriber"] forKey:@"lastfm_subscriber"];
	}
	if([[info objectForKey:@"trial_enabled"] length]) {
		[[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"trial_enabled"] forKey:@"trial_enabled"];
	}
	if([[info objectForKey:@"trial_playsleft"] length]) {
		[[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"trial_playsleft"] forKey:@"trial_playsleft"];
	}
	if([[info objectForKey:@"trial_expired"] length]) {
		[[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"trial_expired"] forKey:@"trial_expired"];
	}
	if([[info objectForKey:@"trial_playselapsed"] length]) {
		[[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"trial_playselapsed"] forKey:@"trial_playselapsed"];
	}

	[rootViewController release];
	rootViewController = [[HomeViewController alloc] initWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastfm_user"]];
	[SHK setRootViewController:rootViewController];
#if !(TARGET_IPHONE_SIMULATOR)
	[FlurryAnalytics logAllPageViews:rootViewController];
#endif
	
	if(animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:_mainView cache:YES];
		[UIView setAnimationDuration:0.4];
	}
	[[_mainView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[_mainView addSubview:[rootViewController view]];
	if(animated)
		[UIView commitAnimations];

	[firstRunView release];
	firstRunView = nil;
	if(_launchURL) {
        [[UIApplication sharedApplication] openURLWithWarning:[NSURL URLWithString:_launchURL]];
		[_launchURL release];
		_launchURL = nil;
	}

	_launched = YES;
}
-(void)showFirstRunView:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
	if(!firstRunView) {
		firstRunView = [[FirstRunViewController alloc] initWithNibName:@"FirstRunView" bundle:nil];
		firstRunView.view.frame = [UIScreen mainScreen].applicationFrame;
	}
#if !(TARGET_IPHONE_SIMULATOR)
	[FlurryAnalytics logAllPageViews:firstRunView];
#endif
	if(animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_mainView cache:YES];
		[UIView setAnimationDuration:0.4];
	}
	[[_mainView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[_mainView addSubview:firstRunView.view];
	if(animated)
		[UIView commitAnimations];
}
- (void)_loadProfile {
	[self showProfileView:YES];
	[_loadingView removeFromSuperview];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if !(TARGET_IPHONE_SIMULATOR)
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"kEnablePinchMediaStatsCollection"] isEqualToString:@"YES"]) {
		NSLog(@"Flurry is enabled");
		[FlurryAnalytics startSession:PINCHMEDIA_ID];
	}
#endif
    [TestFlight takeOff:TESTFLIGHT_KEY];
#ifndef DISTRIBUTION
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
	[LastFMService sharedInstance].session = [[NSUserDefaults standardUserDefaults] objectForKey: @"lastfm_session"];
	[[TTNavigator navigator].URLMap from:@"*" toObject:[UIApplication sharedApplication] selector:@selector(openURLWithWarning:)];
	
	_mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window addSubview:_mainView];

	if([[[NSUserDefaults standardUserDefaults] objectForKey: @"lastfm_session"] length] > 0) {
		NSMutableArray *frames = [[NSMutableArray alloc] init];
		int i;
		for(i=1; i<=68; i++) {
			NSString *filename = [NSString stringWithFormat:@"logo_animation_cropped%04i.png", i];
			[frames addObject:[UIImage imageNamed:filename]];
		}
		_loadingViewLogo.animationImages = frames;
		[frames release];
		_loadingViewLogo.animationDuration = 2;
		[_loadingViewLogo startAnimating];
		_loadingView.frame = [UIScreen mainScreen].applicationFrame;
		[_mainView addSubview:_loadingView];
		[self performSelector:@selector(_loadProfile) withObject:nil afterDelay:0.01];
		_scrobbler = [[Scrobbler alloc] init];
	} else {
		[self showFirstRunView:NO];
	}
	
	[window makeKeyAndVisible];
	return YES;
}
- (IBAction)loveButtonPressed:(UIButton *)sender {
#if !(TARGET_IPHONE_SIMULATOR)
	[FlurryAnalytics logEvent:@"love"];
#endif
	NSDictionary *track = [self trackInfo];
	if(_scrobbler && track) {
		if(!sender.selected) {
			[_scrobbler rateTrack:[track objectForKey:@"title"]
									 byArtist:[track objectForKey:@"creator"]
										onAlbum:[track objectForKey:@"album"]
							withStartTime:[[track objectForKey:@"startTime"] intValue]
							 withDuration:[[track objectForKey:@"duration"] intValue]
								 fromSource:[track objectForKey:@"source"]
										 rating:@"L"];
			sender.selected = YES;
		} else {
			[_scrobbler rateTrack:[track objectForKey:@"title"]
									 byArtist:[track objectForKey:@"creator"]
										onAlbum:[track objectForKey:@"album"]
							withStartTime:[[track objectForKey:@"startTime"] intValue]
							 withDuration:[[track objectForKey:@"duration"] intValue]
								 fromSource:[track objectForKey:@"source"]
										 rating:@""];
			sender.selected = NO;
		}
	}
}
- (IBAction)banButtonPressed:(UIButton *)sender {
#if !(TARGET_IPHONE_SIMULATOR)
	[FlurryAnalytics logEvent:@"ban"];
#endif
	NSDictionary *track = [self trackInfo];
	if(_scrobbler && track) {
		[_scrobbler rateTrack:[track objectForKey:@"title"]
								 byArtist:[track objectForKey:@"creator"]
									onAlbum:[track objectForKey:@"album"]
						withStartTime:[[track objectForKey:@"startTime"] intValue]
						 withDuration:[[track objectForKey:@"duration"] intValue]
							 fromSource:[track objectForKey:@"source"]
									 rating:@"B"];
		sender.alpha = 0.4;
	}
	[[LastFMRadio sharedInstance] skip];
}
- (IBAction)skipButtonPressed:(id)sender {
#if !(TARGET_IPHONE_SIMULATOR)
	[FlurryAnalytics logEvent:@"skip"];
#endif
	[[LastFMRadio sharedInstance] skip];
}
-(IBAction)pauseButtonPressed:(id)sender {
	if([LastFMRadio sharedInstance].state == TRACK_PAUSED) {
		[[LastFMRadio sharedInstance] play];
		if([sender isKindOfClass:[UIButton class]])
			[(UIButton *)sender setImage:[UIImage imageNamed:@"controlbar_pause.png"] forState:UIControlStateNormal];
	} else {
		[[LastFMRadio sharedInstance] pause];
		if([sender isKindOfClass:[UIButton class]])
			[(UIButton *)sender setImage:[UIImage imageNamed:@"controlbar_play.png"] forState:UIControlStateNormal];
	}
}
-(BOOL)isPlaying {
	return [[LastFMRadio sharedInstance] state] != RADIO_IDLE;
}
-(BOOL)isPaused {
	return [[LastFMRadio sharedInstance] state] == TRACK_PAUSED;
}
-(NSDictionary *)trackInfo {
	if([[LastFMRadio sharedInstance] state] != RADIO_IDLE) {
		NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[[LastFMRadio sharedInstance] trackInfo]];
		[info setObject:[info objectForKey:@"trackauth"] forKey:@"source"];
		[info setObject:[[LastFMRadio sharedInstance] station] forKey:@"station"];
		[info setObject:[NSNumber numberWithDouble:[[LastFMRadio sharedInstance] startTime]] forKey:@"startTime"];
		return info;
	} else {
		return nil;
	}
}
-(int) radioState {
	return [[LastFMRadio sharedInstance] state];
}
-(int)trackPosition {
	if([[LastFMRadio sharedInstance] state] != RADIO_IDLE) {
		return [[LastFMRadio sharedInstance] trackPosition];
	} else {
		return 0;
	}
}
-(BOOL)hasNetworkConnection {
	SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "ws.audioscrobbler.com");
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(reach, &flags);
	BOOL ret = (kSCNetworkReachabilityFlagsReachable & flags) || (kSCNetworkReachabilityFlagsConnectionRequired & flags);
	CFRelease(reach);
	reach = nil;
	return ret;
}
-(BOOL)hasWiFiConnection {
	SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "ws.audioscrobbler.com");
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(reach, &flags);
	BOOL ret = (kSCNetworkFlagsReachable & flags) && !(kSCNetworkReachabilityFlagsIsWWAN & flags);
	CFRelease(reach);
	reach = nil;
	return ret;
}
-(NSURLRequest *)requestWithURL:(NSURL *)url { 
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url]; 
	[req setValue:kUserAgent forHTTPHeaderField:@"User-Agent"];
	[req setTimeoutInterval:[self hasWiFiConnection]?40:60];
	return req; 
} 
- (void)reportError:(NSError *)error {
#ifndef DISTRIBUTION
	if([error.userInfo objectForKey:NSLocalizedDescriptionKey])
		NSLog(@"Error encountered: %@\n", error);
#endif
#if !(TARGET_IPHONE_SIMULATOR)
	if([error.userInfo objectForKey:NSLocalizedDescriptionKey])
		[FlurryAnalytics logError:error.domain message:[NSString stringWithFormat:@"Error code %i: %@",error.code,[error.userInfo objectForKey:NSLocalizedDescriptionKey]] error:error];
#endif
	if([error.domain isEqualToString:NSURLErrorDomain]) {
		[self displayError:NSLocalizedString(@"ERROR_NONETWORK", @"Network error") withTitle:NSLocalizedString(@"ERROR_NONETWORK_TITLE", @"Network error title")];
		return;
	} else if([error.domain isEqualToString:LastFMServiceErrorDomain]) {
		int code = error.code;
		
		if(error.code == errorCodeAuthenticationFailed && [[[error userInfo] objectForKey:@"method"] hasPrefix:@"radio"])
			code = errorCodeGeoRestricted;
		
		switch(code) {
			case errorCodeInvalidAPIKey:
				[self displayError:NSLocalizedString(@"ERROR_UPGRADE", @"Upgrade required error") withTitle:NSLocalizedString(@"ERROR_UPGRADE_TITLE", @"Upgrade required error title")];
				return;
			case errorCodeAuthenticationFailed:
			case errorCodeInvalidSession:
				[self performSelectorOnMainThread:@selector(_logout) withObject:nil waitUntilDone:YES];
				[self displayError:NSLocalizedString(@"ERROR_SESSION", @"Invalid session error") withTitle:NSLocalizedString(@"ERROR_SESSION_TITLE", @"Invalid session error title")];
				return;
			case errorCodeSubscribersOnly:
				[self displayError:NSLocalizedString(@"ERROR_SUBSCRIPTION", @"Subscription required error") withTitle:NSLocalizedString(@"ERROR_SUBSCRIPTION_TITLE", @"Subscription required error title")];
				return;
			case errorCodeDeprecated:
				[self displayError:@"This station is no longer available for streaming." withTitle:@"Station No Longer Available"];
				return;
			case errorCodeGeoRestricted:
				[self displayError:@"Last.fm Radio is currently unavailable on mobile devices in this country." withTitle:@"Radio Not Available"];
				return;
			case errorCodeTrialExpired:
				if([[[NSUserDefaults standardUserDefaults] objectForKey:@"trial_enabled"] isEqualToString:@"1"] && [[[error userInfo] objectForKey:@"method"] hasPrefix:@"radio"]) {
					_pendingAlert = [[UIAlertView alloc] initWithTitle:@"Your Free Trial Is Over" message:
																 [NSString stringWithFormat:@"Your free trial of Last.fm radio is over.  Subscribe now to get personalized radio on your %@ at http://last.fm/subscribe", [UIDevice currentDevice].model]
																													delegate:[UIApplication sharedApplication].delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
					if(!_locked)
						[_pendingAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
					[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"trial_expired"];
					[[NSUserDefaults standardUserDefaults] synchronize];
				}
				return;
		}
	}
	if([error.userInfo objectForKey:NSLocalizedDescriptionKey])
		[self displayError:[NSString stringWithFormat:@"%@\n\n%@", NSLocalizedString(@"ERROR_SERVER_UNAVAILABLE", @"Servers are temporarily unavailable"), [error.userInfo objectForKey:NSLocalizedDescriptionKey]] withTitle:NSLocalizedString(@"ERROR_SERVER_UNAVAILABLE_TITLE", @"Servers are temporarily unavailable title")];
	else
		[self displayError:NSLocalizedString(@"ERROR_SERVER_UNAVAILABLE", @"Servers are temporarily unavailable") withTitle:NSLocalizedString(@"ERROR_SERVER_UNAVAILABLE_TITLE", @"Servers are temporarily unavailable title")];
}
- (BOOL)_playRadioStation:(NSString *)station {
	if(![[LastFMRadio sharedInstance] play]) {
		return FALSE;
	}
	return TRUE;
}
- (BOOL)playRadioStation:(NSString *)station animated:(BOOL)animated {
	NSLog(@"Playing radio station: %@\n", station);
	
	if(!_trialAlert && !(([[LastFMRadio sharedInstance] state] != RADIO_IDLE) && [[[LastFMRadio sharedInstance] stationURL] isEqualToString:station])) {
		if([[LastFMRadio sharedInstance] state] != RADIO_IDLE) {
			[[LastFMRadio sharedInstance] stop];
		}
		if([[[NSUserDefaults standardUserDefaults] objectForKey:@"trial_enabled"] isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"trial_playselapsed"] isEqualToString:@"0"]) {
			_trialAlert = [[UIAlertView alloc] initWithTitle:@"Start Free Trial" message:
										 [NSString stringWithFormat:@"Radio is a subscriber only feature.  Try it now with a free %@ track trial.", [[NSUserDefaults standardUserDefaults] objectForKey:@"trial_playsleft"]]
																								delegate:[UIApplication sharedApplication].delegate cancelButtonTitle:@"Later" otherButtonTitles:@"Start Trial", nil];
		}
		else if(![[LastFMRadio sharedInstance] selectStation:station]) {
			[self reportError:[LastFMService sharedInstance].error];
			return FALSE;
		}
	}
	
	if(_trialAlert) {
		_trialAlertStation = [station retain];
		[_trialAlert show];
		return TRUE;
	} else {
		BOOL result = [self _playRadioStation:station];
		if(result && animated) {
			[self showPlaybackView];
		}
		return result;
	}
}
-(void)showPlaybackView {
	if(playbackViewController == nil) {
		playbackViewController = [[PlaybackViewController alloc] initWithNibName:@"PlaybackView" bundle:nil];
		playbackViewController.hidesBottomBarWhenPushed = YES;
		if(!playbackViewController) {
			NSLog(@"Failed to load playback view!\n");
		}
	}

	if(playbackViewController)
		[(UINavigationController *)(rootViewController.selectedViewController) pushViewController:playbackViewController animated:YES];
}
-(void)hidePlaybackView {
	[(UINavigationController *)(rootViewController.selectedViewController) popViewControllerAnimated:YES];
	[playbackViewController release];
	playbackViewController = nil;
}
-(void)displayError:(NSString *)error withTitle:(NSString *)title {
	_pendingAlert = [[UIAlertView alloc] initWithTitle:title message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
	if(!_locked)
		[_pendingAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	if([url.scheme isEqualToString:@"lastfm"] && [url.host isEqualToString:@"registration"]) {
		NSArray *args = [url.path componentsSeparatedByString:@"/"];
		[[NSUserDefaults standardUserDefaults] setObject:[args objectAtIndex:1] forKey:@"lastfm_user"];
		if([args count] == 3) {
			[[NSUserDefaults standardUserDefaults] setObject:[args objectAtIndex:2] forKey:@"lastfm_session"];
			[self showProfileView:NO];
		} else {
			[self showFirstRunView:NO];
		}
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else {
		_launchURL = [[url absoluteString] retain];
		if(_launched)
			[[UIApplication sharedApplication] openURLWithWarning:url];
	}
	return TRUE;
}
- (void)dealloc {
	[window release];
	[super dealloc];
}
@end

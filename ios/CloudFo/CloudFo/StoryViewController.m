//
//  StoryViewController.m
//  CloudFo
//
//  Created by robin on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()

@end

@implementation StoryViewController
///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"万网域名";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"first.png"] tag:1] autorelease]; 
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
    [super loadView];
    
    _launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
    //_launcherView.backgroundColor = [UIColor blackColor];
    _launcherView.delegate = self;
    _launcherView.columnCount = 4;
    _launcherView.pages = [NSArray arrayWithObjects:
                           [NSArray arrayWithObjects:
                            [[[TTLauncherItem alloc] initWithTitle:@"域名查询"
                                                             image:@"bundle://Icon.png"
                                                               URL:nil canDelete:YES] autorelease],
                            [[[TTLauncherItem alloc] initWithTitle:@"域名体检"
                                                             image:@"bundle://Icon.png"
                                                               URL:nil canDelete:YES] autorelease],
                            [[[TTLauncherItem alloc] initWithTitle:@"Button 3"
                                                             image:@"bundle://Icon.png"
                                                               URL:@"fb://item3" canDelete:YES] autorelease],
                            [[[TTLauncherItem alloc] initWithTitle:@"Button 4"
                                                             image:@"bundle://Icon.png"
                                                               URL:@"fb://item4" canDelete:YES] autorelease],
                            [[[TTLauncherItem alloc] initWithTitle:@"Button 5"
                                                             image:@"bundle://Icon.png"
                                                               URL:@"fb://item5" canDelete:YES] autorelease],
                            [[[TTLauncherItem alloc] initWithTitle:@"Button 6"
                                                             image:@"bundle://Icon.png"
                                                               URL:@"fb://item6" canDelete:YES] autorelease],
                            [[[TTLauncherItem alloc] initWithTitle:@"Button 7"
                                                             image:@"bundle://Icon.png"
                                                               URL:@"fb://item7" canDelete:YES] autorelease],
                            nil],
                           [NSArray arrayWithObjects:
                            [[[TTLauncherItem alloc] initWithTitle:@"Button 8"
                                                             image:@"bundle://Icon.png"
                                                               URL:nil canDelete:YES] autorelease],
                            [[[TTLauncherItem alloc] initWithTitle:@"Button 9"
                                                             image:@"bundle://Icon.png"
                                                               URL:nil canDelete:YES] autorelease],
                            nil],
                           nil
                           ];
    [self.view addSubview:_launcherView];
    
    TTLauncherItem* item = [_launcherView itemWithURL:@"fb://item3"];
    item.badgeNumber = 4;
    
    item = [_launcherView itemWithURL:@"fb://item4"];
    item.badgeNumber = 0;
    
    item = [_launcherView itemWithURL:@"fb://item5"];
    item.badgeValue = @"100!";
    
    item = [_launcherView itemWithURL:@"fb://item6"];
    item.badgeValue = @"Off";
    
    item = [_launcherView itemWithURL:@"fb://item7"];
    item.badgeNumber = 300;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTLauncherViewDelegate

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
    [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                 target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

@end

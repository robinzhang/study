//
//  MainViewController.m
//  CloudFo
//
//  Created by robin on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import <Three20/Three20.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(UserDidLogonSuccess:) 
                                                     name:@"UserDidLogonSuccess" 
                                                   object:nil];
    }
    return self;
}

- (void)UserDidLogonSuccess:(NSNotification*)notification{
    
    [self setLogonUrls];
    self.selectedIndex = 0;
}

#pragma mark - View lifecycle
-(void)setView:(UIView *)view
{
    if(view == nil)
        return;
    
    [super setView:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLogonUrls];
    self.selectedIndex = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserDidLogonSuccess"  object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setLogonUrls
{
    [self setTabURLs:[NSArray arrayWithObjects:
                      @"tt://book", 
                      @"tt://music",
                      @"tt://story",
                      @"tt://setting",
                      nil]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; 
}

@end

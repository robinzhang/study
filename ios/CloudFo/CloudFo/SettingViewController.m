//
//  SettingViewController.m
//  CloudFo
//
//  Created by robin on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"setting.png"] tag:1] autorelease]; }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden=YES;
    
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)clearChache
{
    
}

-(void)setErrorView:(UIView *)errorView
{
    if(errorView)
    {
        
    }
    else
    {
        
    }
}

-(void)removeErrorView
{
    
}

//
-(void)doRefresh
{
    
}

//-(void)userDidUpdateToLocationSucc
//{
//    [self clearChache];
//}

-(void)NotificationHaveNewMessage
{
    [self clearChache];
    self.tabBarItem.badgeValue = @"new";
}

-(void)createModel
{   
    
    
}


-(void)modelDidFinishLoad:(id<TTModel>)model
{
    
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

#pragma mark - View lifecycle

- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex
{
    
}

#pragma mark - View lifecycle
-(void)setView:(UIView *)view
{
    if(view == nil)
        return;
    
    [super setView:view];
}

- (void)didReceiveMemoryWarning
{
    
}

-(void)viewDidUnload
{
}

-(void)dealloc
{
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end


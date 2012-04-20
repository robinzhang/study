//
//  MusicViewController.m
//  CloudFo
//
//  Created by robin on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MusicViewController.h"

@interface MusicViewController ()

@end

@implementation MusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"佛典寓言";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"second.png"] tag:1] autorelease]; }
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
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"佛典寓言",
                       [TTTableImageItem itemWithText:@"对面不识佛菩萨(图文)" imageURL:@"bundle://dmbsps.png" URL:@"tt://detail?doc=Doc09.html"],
                       [TTTableImageItem itemWithText:@"给孤独夫妇(图文)" imageURL:@"bundle://gdff.png" URL:@"tt://detail?doc=Doc10.html"],
                       [TTTableImageItem itemWithText:@"贪和爱(图文)" imageURL:@"bundle://tha.png" URL:@"tt://detail?doc=Doc11.html"],
                       [TTTableImageItem itemWithText:@"天堂与地狱(图文)" imageURL:@"bundle://ttdy.png" URL:@"tt://detail/3"],
                       @"因果报应",
                       [TTTableImageItem itemWithText:@"对面不识佛菩萨(图文)" imageURL:@"bundle://dmbsps.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"给孤独夫妇(图文)" imageURL:@"bundle://gdff.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"贪和爱(图文)" imageURL:@"bundle://tha.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"天堂与地狱(图文)" imageURL:@"bundle://ttdy.png" URL:@"tt://music"],
                       @"成败故事",
                       [TTTableImageItem itemWithText:@"对面不识佛菩萨(图文)" imageURL:@"bundle://dmbsps.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"给孤独夫妇(图文)" imageURL:@"bundle://gdff.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"贪和爱(图文)" imageURL:@"bundle://tha.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"天堂与地狱(图文)" imageURL:@"bundle://ttdy.png" URL:@"tt://music"],
                       @"智慧故事",
                       [TTTableImageItem itemWithText:@"对面不识佛菩萨(图文)" imageURL:@"bundle://dmbsps.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"给孤独夫妇(图文)" imageURL:@"bundle://gdff.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"贪和爱(图文)" imageURL:@"bundle://tha.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"天堂与地狱(图文)" imageURL:@"bundle://ttdy.png" URL:@"tt://music"],
                       @"生活故事",
                       [TTTableImageItem itemWithText:@"对面不识佛菩萨(图文)" imageURL:@"bundle://dmbsps.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"给孤独夫妇(图文)" imageURL:@"bundle://gdff.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"贪和爱(图文)" imageURL:@"bundle://tha.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"天堂与地狱(图文)" imageURL:@"bundle://ttdy.png" URL:@"tt://music"],
                       @"感应故事",
                       [TTTableImageItem itemWithText:@"对面不识佛菩萨(图文)" imageURL:@"bundle://dmbsps.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"给孤独夫妇(图文)" imageURL:@"bundle://gdff.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"贪和爱(图文)" imageURL:@"bundle://tha.png" URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"天堂与地狱(图文)" imageURL:@"bundle://ttdy.png" URL:@"tt://music"],
                       nil];

}


-(void)modelDidFinishLoad:(id<TTModel>)model
{
    self.tabBarItem.badgeValue = nil;
    [super modelDidFinishLoad:model];
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

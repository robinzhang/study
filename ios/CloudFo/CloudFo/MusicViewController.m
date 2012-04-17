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
    
    NSString* fozuImgUrl = @"bundle://icon.png";
     NSString* dizangImgUrl = @"bundle://icon_dizangpus.png";
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"佛",
                       [TTTableImageItem itemWithText:@"天堂与地狱" imageURL:fozuImgUrl
                                                  URL:@"tt://detail"],
                       @"菩萨",
                       [TTTableImageItem itemWithText:@"大慈大悲观世音菩萨" imageURL:fozuImgUrl
                                                  URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"解救苦难地藏菩萨" imageURL:dizangImgUrl
                                                  URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"般若智慧文殊菩萨" imageURL:fozuImgUrl
                                                  URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"德行圆满普贤菩萨" imageURL:fozuImgUrl
                                                  URL:@"tt://music"],
                       @"罗汉/尊者",
                       [TTTableImageItem itemWithText:@"智慧第一的舍利弗" imageURL:fozuImgUrl
                                                  URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"神足第一的目犍连" imageURL:fozuImgUrl
                                                  URL:@"tt://music"],
                       [TTTableImageItem itemWithText:@"拈花心传的大迦叶" imageURL:fozuImgUrl
                                                  URL:@"tt://music"],
                       
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

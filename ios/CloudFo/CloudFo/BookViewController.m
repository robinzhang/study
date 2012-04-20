//
//  BookViewController.m
//  CloudFo
//
//  Created by robin on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookViewController.h"
#import <Three20/Three20.h>
#define tabHeight 36
@implementation BookViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"佛教人物";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"first.png"] tag:1] autorelease]; }
    self.variableHeightRows = YES;
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
        if(!errorinfoview)
        {
            errorinfoview = [[SnInfoView alloc] initWithFrame:CGRectMake(80, 135, 160,80) msg:@"出错了，请检查您的网络环境！"];
        }
        if(![errorinfoview superview])
            [self.view addSubview:errorinfoview];
        
        [self performSelector:@selector(removeErrorView) withObject:nil afterDelay:3.0];
    }
    else
    {
        if(errorinfoview && [errorinfoview superview])
            [errorinfoview removeFromSuperview];
    }
}


-(void)removeErrorView
{
    if(errorinfoview && [errorinfoview superview])
        [errorinfoview removeFromSuperview];
}

//
-(void)doRefresh
{
    
}


-(void)NotificationHaveNewMessage
{
    [self clearChache];
    self.tabBarItem.badgeValue = @"new";
}

- (void) createModel {
    NSString* fozuImgUrl = @"bundle://icon_fz.png";
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"佛",
                       [TTTableImageItem itemWithText:@"至尊佛陀的一生" imageURL:fozuImgUrl  URL:@"tt://detail?doc=Doc01.html"],
                       @"菩萨",
                       [TTTableImageItem itemWithText:@"大慈大悲观世音菩萨" imageURL:@"bundle://pusa.png" URL:@"tt://detail?doc=Doc02.html"],
                       [TTTableImageItem itemWithText:@"解救苦难地藏菩萨" imageURL:@"bundle://dz.png"  URL:@"tt://detail?doc=Doc03.html"],
                       [TTTableImageItem itemWithText:@"般若智慧文殊菩萨" imageURL:@"bundle://ws.png"  URL:@"tt://detail?doc=Doc04.html"],
                       [TTTableImageItem itemWithText:@"德行圆满普贤菩萨" imageURL:@"bundle://px.png"  URL:@"tt://detail?doc=Doc05.html"],
                       @"罗汉/尊者",
                       [TTTableImageItem itemWithText:@"智慧第一的舍利弗" imageURL:@"bundle://slf.png"  URL:@"tt://detail?doc=Doc06.html"],
                       [TTTableImageItem itemWithText:@"神足第一的目犍连" imageURL:@"bundle://mjl.png"  URL:@"tt://detail?doc=Doc07.html"],
                       [TTTableImageItem itemWithText:@"拈花心传的大迦叶" imageURL:@"bundle://djy.png"  URL:@"tt://detail?doc=Doc08.html"],
                       nil];
}


-(void)modelDidFinishLoad:(id<TTModel>)model
{
    self.tabBarItem.badgeValue = nil;
    [super modelDidFinishLoad:model];
}

- (void)loadView {
    [super loadView];
    
    self.tableView.rowHeight = 330;
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
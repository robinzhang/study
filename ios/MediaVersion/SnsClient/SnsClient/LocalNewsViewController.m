//
//  LocalNewsViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LocalNewsViewController.h"
#define tabHeight 36
#define k_SendType 128
#define k_SendModel 2

@implementation LocalNewsViewController
//@synthesize currentLocation = _currentLocation;
@synthesize me = _me;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"佛经";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_read.png"] tag:1] autorelease];
        
        self.me = [UserHelper GetUserID];
        self.variableHeightRows = YES;
        
        //[[NSNotificationCenter defaultCenter] addObserver:self 
        //                                         selector:@selector(userDidUpdateToLocationSucc) 
        //                                             name:@"userDidUpdateToLocationSucc" 
        //                                           object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(NotificationHaveNewMessage) 
                                                     name:@"NotificationHaveNewMessage" 
                                                   object:nil];
        
        
        CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
        TTTabBar *_tabBar2 = [[TTTabBar alloc] initWithFrame:CGRectMake(0, -1, applicationFrame.size.width, tabHeight)];
        _tabBar2.style = TTSTYLE(newsTabBar);
        _tabBar2.tabStyle = @"newsTab:";
        
        _tabBar2.tabItems = [NSArray arrayWithObjects:
                             [[[TTTabItem alloc] initWithTitle:@"我附近的"] autorelease],
                             [[[TTTabItem alloc] initWithTitle:@"所选区域"] autorelease],
                             nil];
        
        _tabBar2.delegate = self;
        _tabBar2.contentMode = UIViewContentModeScaleToFill;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tabBar2];
        
        

    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    TTButton *btn = [TTButton buttonWithStyle:@"blueImgToolbarButton:" title:nil]; 
    [btn setImage:@"bundle://btn_icon_refresh_wt.png" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doRefresh) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 36, 34)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn]; 
}

-(void)viewWillAppear:(BOOL)animated
{
    self.me = [UserHelper GetUserID];
    self.navigationController.toolbarHidden=YES;

    [super viewWillAppear:animated];
    
    //////////////  get new  clear chache //////////////
    SnUserAppInfo *info = [UserHelper GetUserAppInfo];
    if(info.HaveNewMessage || info.LocationDidChange)
    {
        if(self.model)
        {
            LocalNewsModel *model = (LocalNewsModel*)self.model;
            if(model.locationType != 1)
            {
                [model reset];
                [model clearThisCache];
                [self.model load:TTURLRequestCachePolicyDefault more:NO];
            }
         }
    }
    else
    {
        self.tabBarItem.badgeValue = nil;
    }
    
    if(info.MapCenterChange)
    {
         LocalNewsModel *model = (LocalNewsModel*)self.model;
         if(model.locationType == 1)
         {
             [model reset];
             [model clearThisCache];
             [self.model load:TTURLRequestCachePolicyDefault more:NO];
         }
    }
    
    CGRect frame = self.view.bounds;
    [self.tableView setFrame:CGRectMake(0,tabHeight, frame.size.width, frame.size.height - tabHeight)];
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)clearChache
{
    //if([self.model isKindOfClass:[LocalNewsModel class]])
    // {
        LocalNewsModel *model = (LocalNewsModel*)self.model;
        [model clearThisCache]; 
   // }
   // else if([self.model isKindOfClass:[UserPostViewModel class]])
   // {
   //     UserPostViewModel *model = (UserPostViewModel*)self.model;
   //     [model clearThisCache]; 
   // }
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
    [self clearChache];
    //if([self.model isKindOfClass:[LocalNewsModel class]])
    //{
        LocalNewsModel *model = (LocalNewsModel*)self.model;
        [model load:TTURLRequestCachePolicyDefault more:NO];
   // }
   // else if([self.model isKindOfClass:[UserPostViewModel class]])
   // {
   //     UserPostViewModel *model = (UserPostViewModel*)self.model;
   //     [model load:TTURLRequestCachePolicyDefault more:NO];
   // }
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
    //CLLocation *nowloaction = [UserHelper GetUserLocation];
    datasource0 = [[LocalNewsDataSource alloc]
                   initWithSearchQuery:_me locationType:0 range:KMessageRange  sendType:k_SendType sendModel:k_SendModel];
    
    datasource1   = [[LocalNewsDataSource alloc] 
                     initWithSearchQuery:_me locationType:1 range:KMessageRange  sendType:k_SendType sendModel:k_SendModel];
    
    if(_seIndex == 0)
        self.dataSource = datasource0;
    else
        self.dataSource = datasource1;
}


-(void)modelDidFinishLoad:(id<TTModel>)model
{
   // if([model isKindOfClass:[LocalNewsModel class]])
   // {
        LocalNewsModel *smodle = (LocalNewsModel*)self.model;
        _posts = smodle.posts;
   // }
    //else if([model isKindOfClass:[UserPostViewModel class]])
   // {
   //     UserPostViewModel *smodle = (UserPostViewModel*)self.model;
    //    _posts = smodle.posts;
    //}
    
    //////////////////  after reflash badgeValue = nil ///////////////
    SnUserAppInfo *info = [UserHelper GetUserAppInfo];
    if(smodle.locationType == 1)
    {
        info.MapCenterChange = NO;
    }
    else
    {
        info.HaveNewMessage = NO;
        info.LocationDidChange = NO;
    }
    [UserHelper SetUserAppInfo:info];
    self.tabBarItem.badgeValue = nil;
    
    [super modelDidFinishLoad:model];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    if([object isKindOfClass:[SnTableNoDataItem class]])
    {
        if(![UserHelper isLogon])
        {
            TTOpenURL(@"tt://logon");
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

#pragma mark - View lifecycle

- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex
{
    _seIndex = selectedIndex;
    LocalNewsModel *smodle = (LocalNewsModel*)self.model;
    
    if(smodle.locationType == 1 )
    {
        [self setDataSource:datasource0];
    }
    else
    {
        LocalNewsModel *smodle1 =  (LocalNewsModel*)datasource1.model ;
        [smodle1 reset];
        [self setDataSource:datasource1];
    }
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
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"userDidUpdateToLocationSucc"  object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationHaveNewMessage"  object:nil];
}

-(void)dealloc
{
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//
//  FollowNewsViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FollowNewsViewController.h"
#define tabHeight 40
@implementation FollowNewsViewController
//@synthesize queryUserid = _queryUserid;
@synthesize me = _me;

-(id)initWidthUserId:(NSString*)queryUserid
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        //self.queryUserid = queryUserid;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.variableHeightRows = YES;
        self.me = [UserHelper GetUserID];
        self.title = @"关注人的新闻";
        
        CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
        TTTabBar *_tabBar2 = [[TTTabBar alloc] initWithFrame:CGRectMake(0, KPageTitleHeight - 1 , applicationFrame.size.width, tabHeight)];
        _tabBar2.style = TTSTYLE(newsTabBar);
        _tabBar2.tabStyle = @"newsTab:";
        
        _tabBar2.tabItems = [NSArray arrayWithObjects:
                             [[[TTTabItem alloc] initWithTitle:@"最新发生的"] autorelease],
                             [[[TTTabItem alloc] initWithTitle:@"最近距离的"] autorelease],
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

}

-(void)viewWillAppear:(BOOL)animated
{
    self.me = [UserHelper GetUserID];
    [super viewWillAppear:animated];
    
    CGRect frame = self.view.bounds;
    [self.tableView setFrame:CGRectMake(0, tabHeight + KPageTitleHeight, frame.size.width, frame.size.height - tabHeight -KPageTitleHeight - 1)];
    
    TTButton *btn = [TTButton buttonWithStyle:@"blueImgToolbarButton:" title:nil]; 
    [btn setImage:@"bundle://btn_icon_refresh_wt.png" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doRefresh) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 36, 34)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn]; 
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}


-(void)doRefresh
{
    UserPostViewModel *mm = (UserPostViewModel*)self.model;
    [mm clearThisCache];
    [mm load:TTURLRequestCachePolicyNoCache more:NO];
}


-(void)createModel
{
    CLLocation *l = [UserHelper GetUserLocation];
    datasource0   =[[UserPostViewDataSource alloc] initWithSearchQuery:self.me accountid:@"" lat:l.coordinate.latitude lon:l.coordinate.longitude model:0];
    
    datasource1   =[[UserPostViewDataSource alloc] initWithSearchQuery:self.me accountid:@"" lat:l.coordinate.latitude lon:l.coordinate.longitude model:1];
    
    [self setDataSource:datasource0];
}

//- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
//    SnMessage *message = (SnMessage*)[_posts objectAtIndex:indexPath.row];
//    MessageDetailController *view = [[MessageDetailController alloc] initWidthMessage:message];
//    [self.navigationController pushViewController:view animated:YES];
//}

- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex
{
    if(selectedIndex == 0)
        self.dataSource = datasource0;
    else
        self.dataSource = datasource1;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

-(void)modelDidFinishLoad:(id<TTModel>)model
{
     UserPostViewModel *mm = (UserPostViewModel*)self.model;
     _posts = mm.posts;
    [super modelDidFinishLoad:model];
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
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewDidUnload
{
    
}

-(void)dealloc
{
    //TT_RELEASE_SAFELY(_queryUserid);
    TT_RELEASE_CF_SAFELY(_posts);
    TT_RELEASE_CF_SAFELY(_me);
    [super dealloc];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

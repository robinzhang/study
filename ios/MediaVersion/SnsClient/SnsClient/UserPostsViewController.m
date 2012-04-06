//
//  UserPostsViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserPostsViewController.h"
#import "SnNotificationDataKeyHelper.h"

@implementation UserPostsViewController
@synthesize queryUserid = _queryUserid;
@synthesize me = _me;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *uid = [UserHelper GetUserID];
        self.queryUserid = uid;
        self.me = uid;
        self.title = @"我发表的新闻";
        self.variableHeightRows = YES;
        
        self.hidesBottomBarWhenPushed = NO;
        
    }
    return self;
}


-(id)initWidthUserId:(NSString*)queryUserid
{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        NSString *uid = [UserHelper GetUserID];
        self.queryUserid = queryUserid;
        self.me = uid;
        
        self.title = @"Ta发表的新闻";
        self.variableHeightRows = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.me = [UserHelper GetUserID];
    [super viewWillAppear:animated];
     self.navigationController.toolbarHidden=YES;
    
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CLLocation *l = [UserHelper GetUserLocation];
    
    /*
    //////////// ClearCommentCount //////// 
    if([self.me isEqualToString:self.queryUserid])
    {
        SnUserAppInfo *info =  [UserHelper GetUserAppInfo];
        if(info.CommentCount > 0)
        {
            [UserPostViewModel clearCache:self.me  accountid:self.queryUserid lat:l.coordinate.latitude lon:l.coordinate.longitude model:0];
            
            SnNotificationDataKeyHelper *helper = [[SnNotificationDataKeyHelper  alloc] init];
            [helper ClearCommentCount];
        }
    }
     */
    
    UserPostViewDataSource *datasouce =[[UserPostViewDataSource alloc] initWithSearchQuery:self.me accountid:self.queryUserid lat:l.coordinate.latitude lon:l.coordinate.longitude model:0];
    datasouce.UpdateDelegate = self;
    self.dataSource = datasouce;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}


-(void)modelDidFinishLoad:(id<TTModel>)model
{
    UserPostViewModel *smodle = (UserPostViewModel*)self.model;
    _posts = smodle.posts;
    [super modelDidFinishLoad:model];
}

//- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
//    if([object isKindOfClass:[SnTableNoDataItem class]])
//    {
//        if(![UserHelper isLogon])
//        {
//            TTOpenURL(@"tt://logon");
//        }
//    }
//}


//- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
//    SnMessage *message = (SnMessage*)[_posts objectAtIndex:indexPath.row];
//    MessageDetailController *view = [[MessageDetailController alloc] initWidthMessage:message];
//    [self.navigationController pushViewController:view animated:YES];
//}

#pragma mark - UserPostUpdateDelegate
- (void)didDeleteFinished:(int)index
{
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
//    [self.tableView reloadData];
    
    UserPostViewModel *smodle = (UserPostViewModel*)self.model;
    [smodle clearThisCache];
    [smodle load:TTURLRequestCachePolicyDefault more:NO];
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

-(void)dealloc
{

//    TT_RELEASE_SAFELY(_me);
//    TT_RELEASE_SAFELY(_queryUserid);
//    TT_RELEASE_SAFELY(_posts);
    [super dealloc];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

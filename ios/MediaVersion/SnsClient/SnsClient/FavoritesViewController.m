//
//  FavoritesViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"

@implementation FavoritesViewController
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
        self.title = @"我收藏的新闻";
        self.variableHeightRows = YES;
        
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
        
        self.title = @"Ta收藏的收藏";
        self.variableHeightRows = YES;
    }
    return self;
}

-(void)createModel
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = [[FavoritesDataSource alloc] initWithSearchQuery:self.queryUserid];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

//- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
//    SnMessage *message = (SnMessage*)[_posts objectAtIndex:indexPath.row];
//    MessageDetailController *view = [[MessageDetailController alloc] initWidthMessage:message];
//    [self.navigationController pushViewController:view animated:YES];
//}

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
    FavoritesModel *mm = (FavoritesModel*)self.model;
    [mm clearCache:self.me];
    [mm load:TTURLRequestCachePolicyNoCache more:NO];
}

-(void)modelDidFinishLoad:(id<TTModel>)model
{
    FavoritesModel *smodle = (FavoritesModel*)self.model;
    _posts = smodle.posts;
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
//    TT_RELEASE_SAFELY(_queryUserid);
//    TT_RELEASE_CF_SAFELY(_posts);
//    TT_RELEASE_CF_SAFELY(_me);
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

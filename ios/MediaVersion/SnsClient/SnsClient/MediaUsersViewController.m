//
//  MediaUsersViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MediaUsersViewController.h"

@implementation MediaUsersViewController
@synthesize queryUserid = _queryUserid;
@synthesize sendtype =_sendtype;

-(id)initWidthFans:(NSString*)queryUserid
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.queryUserid = queryUserid;
        self.sendtype = 0;
        self.title = @"我的看过好友";
    }
    return self;
}

-(id)initWidthFollow:(NSString*)queryUserid
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.queryUserid = queryUserid;
        self.sendtype = 1;
        self.title = @"我的看过好友";
    }
    return self;
}

-(id)initWidthFriends:(NSString*)queryUserid
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.queryUserid = queryUserid;
        self.sendtype = 2;
        self.title = @"我的看过好友";
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = _queryUserid;
    _me = [UserHelper GetUserID];
    self.variableHeightRows = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    MediaUsersModel *mm = (MediaUsersModel*)self.model;
    [mm clearCache:self.queryUserid];
    [mm load:TTURLRequestCachePolicyNoCache more:NO];
}

-(void)createModel{
    self.dataSource = [[MediaUsersDataSource alloc] initWithSearchQuery:self.queryUserid];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
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
    //TT_RELEASE_CF_SAFELY(_me);
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
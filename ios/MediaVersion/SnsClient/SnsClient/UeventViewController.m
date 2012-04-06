//
//  UeventViewController.m
//  SnsClient
//
//  Created by  on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UeventViewController.h"
#import "UeventDataSource.h"
#import "SnNotificationDataKeyHelper.h"

@implementation UeventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我收到的通知";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_message.png"] tag:0];
        self.variableHeightRows = YES;
        //[self initTitleView];
    }
    return self;
}

-(void)initTitleView
{
    // segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Message", @"私信我"),
                                   NSLocalizedString(@"@ Me", @"@我的"),
                                   NSLocalizedString(@"Comment", @"@评论我"),
								   nil];
    
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;

	self.navigationItem.titleView = segmentedControl;
	[segmentedControl release];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    SnUserAppInfo *info =  [UserHelper GetUserAppInfo];
    if(info.CommentCount > 0)
    {
        SnNotificationDataKeyHelper *helper = [[SnNotificationDataKeyHelper  alloc] init];
        [helper ClearCommentCount];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

-(void)createModel
{
    self.dataSource = [[UeventDataSource alloc] init];
}

#pragma mark - View lifecycle

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

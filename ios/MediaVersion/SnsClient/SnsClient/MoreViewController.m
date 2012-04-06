//
//  MoreViewController.m
//  SnsClient
//
//  Created by  on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "UserHelper.h"
#import "LogonViewController.h"

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title =@"更多";
        UITabBarItem *item = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_more.png"] tag:0] autorelease];
        self.tabBarItem = item;
        self.tableViewStyle = UITableViewStyleGrouped;
        self.variableHeightRows = YES;
    }
    return self;
}

-(void)onShowAbout
{
    TTOpenURL(@"tt://about");
}

-(void)onShowHelper
{
    TTOpenURL(@"tt://userguide" );
}

-(void)createModel
{
    self.dataSource = [SnSectionedDataSource dataSourceWithObjects:
                       @"",
                       [TTTableTextItem itemWithText:@"帮助说明"  delegate:self selector:@selector(onShowHelper)],
                       [TTTableTextItem itemWithText:@"关于我们"  delegate:self selector:@selector(onShowAbout)],
                       //[TTTableTextItem itemWithText:@"评价看过"  URL:nil],
                       nil];
    
    UIView *fview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
    TTButton *button =  [TTButton buttonWithStyle:@"redButtonStyle:" title:@"退出登录"];
    [button setFrame:CGRectMake(8, 5,304, 42)];
    [button addTarget:self action:@selector(willLogout:) forControlEvents:UIControlEventTouchUpInside];
    [fview addSubview:button];
    [self.tableView setTableFooterView:fview];
    [fview release];
    
}



///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)doAlert:(id)sender  title:(NSString*)title message:(NSString*)message{
	UIAlertView *alertDialog;
    
    alertDialog = [[UIAlertView alloc] 
                   initWithTitle: title 
                   message:message
                   delegate:self
                   cancelButtonTitle: NSLocalizedString(@"Cancel", @"取消")
                   otherButtonTitles: NSLocalizedString(@"Done", @"确定"),nil];
    
    [alertDialog show];
	[alertDialog release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)willLogout:(id)sender
{
    [self doAlert:self title:@"退出" message:NSLocalizedString(@"You Will Logout and Can't Receive Any Message From Your Friends", @"确定要退出登陆?")];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    }
    else
    {
        [UserHelper SetUserLogout];
        LogonViewController *logonview = [[LogonViewController alloc] initWithNibName:nil bundle:nil];
        TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:logonview] autorelease];
        [logonview release];
        
        [self.navigationController presentModalViewController:nav animated:NO];
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

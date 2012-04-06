//
//  MyGroupViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyGroupViewController.h"

@implementation MyGroupViewController
@synthesize me  = _me;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关注";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"more_recommand.png"] tag:3] autorelease];
        self.tableViewStyle = UITableViewStyleGrouped;
        self.showTableShadows = YES;
        
        self.me = [UserHelper GetUserID];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.me = [UserHelper GetUserID];
    [super viewWillAppear:animated];
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}

-(void)createModel
{
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [sections addObject:@""];
    NSMutableArray *section = [[NSMutableArray alloc] init];   
    
    TTTableImageItem *cell1 = [TTTableImageItem itemWithText:@"我关注的人" delegate:self selector:@selector(myfollow)];
    cell1.imageURL = @"bundle://icon_follow.png";
    [section addObject:cell1];
    
    TTTableImageItem *cell2 = [TTTableImageItem itemWithText:@"关注人的新闻" delegate:self selector:@selector(follownews)];
    cell2.imageURL = @"bundle://icon_news.png";
    [section addObject:cell2];
    
    TTTableImageItem  *emailCell = [TTTableImageItem itemWithText:NSLocalizedString(@"Invite Friends By Email", @"Invite Friends By Email")  delegate:self selector:@selector(sendEmail)];
    emailCell.imageURL=@"bundle://icon_email.png";
    [section addObject:emailCell];
    
    TTTableImageItem *weiboCell = [TTTableImageItem itemWithText:NSLocalizedString(@"Invite Friends By Sina Weibo", @"Invite Friends By Sina Weibo") delegate:self selector:@selector(SendWeibo)];
    weiboCell.imageURL=@"bundle://icon_sina.png";
    [section addObject:weiboCell];
    
    /*
    TTTableImageItem *kaixinCell = [TTTableImageItem itemWithText:@"通过开心网邀请好友" delegate:self selector:@selector(SendKaixin)];
    kaixinCell.imageURL=@"bundle://icon_sina.png";
    [section addObject:kaixinCell];
    */
    
    if ([MFMessageComposeViewController canSendText]) {
       TTTableImageItem *smsCell = [TTTableImageItem itemWithText:NSLocalizedString(@"Invite Friends By SMS", @"Invite Friends By SMS")  delegate:self selector:@selector(sendSms)];
        smsCell.imageURL=@"bundle://icon_sms.png";
        [section addObject:smsCell];
    }
    
    TTTableImageItem *itmea = [TTTableImageItem itemWithText:@"关于新闻两公里"  delegate:self selector:@selector(onShowAbout)];
    [itmea setImageURL:@"bundle://icon_about.png"];
    [section addObject:itmea];
    [items addObject:section];
    
    self.dataSource = [TTSectionedDataSource dataSourceWithItems:items sections:sections];
}

-(void)onShowAbout
{
    TTOpenURL(@"tt://about");
}

-(void)myfollow
{
    if([UserHelper isLogon])
        TTOpenURL([NSString stringWithFormat:@"tt://myfollow/%@",self.me]);
    else
    {
        TTOpenURL(@"tt://logon");
    }
}

-(void)follownews
{
    if([UserHelper isLogon])
        TTOpenURL([NSString stringWithFormat:@"tt://follownews/%@",self.me]);
    else
    {
        TTOpenURL(@"tt://logon");
    }
}

-(void)newsforme
{   
    if([UserHelper isLogon])
        TTOpenURL([NSString stringWithFormat:@"tt://newsforme/%@",self.me]);
    else
    {
        TTOpenURL(@"tt://logon");
    }
}


#pragma mark - Send Kaixin
-(void)SendKaixin
{
    
}

#pragma mark - Send Weibo

- (void)SendWeibo{
    WeiBoHelper *application = [WeiBoHelper sharedInstance];
    if([application isWeiBoLogon] )
    {
        application.delegate = nil;
        [application sendWeibo:NSLocalizedString(@"Weibo Invite Body", @"Weibo Invite Body") image:nil andDelegate:self];
        
    }
    else
    {
        application.delegate = self;
        application.changeUser = NO;
        [application weiboLogin];
    }
}

-(void)didAfterWeiBologinError:(NSString *)error
{
    [self.navigationController bringControllerToFront:self animated:YES];
}

-(void)didAfterWeiBologin:(NSString *)uid
{
    [self.navigationController bringControllerToFront:self animated:YES];
     WeiBoHelper *application = [WeiBoHelper sharedInstance];
     application.delegate = nil;
    [application sendWeibo:NSLocalizedString(@"Weibo Invite Body", @"Weibo Invite Body") image:nil andDelegate:self];
}

- (void)request:(WBRequest *)request didLoad:(id)result{
    WeiBoHelper *application = [WeiBoHelper sharedInstance];
    [application dismissWeiboSendView];
}

#pragma mark - send sms

- (void)sendSms{
    if (![MFMessageComposeViewController canSendText]) {
        return;
    }
    MFMessageComposeViewController *sms=[[MFMessageComposeViewController alloc] init];
    sms.messageComposeDelegate=self;
    [sms setBody:NSLocalizedString(@"SMS Invite", @"SMS Invite")];
    
    [self presentModalViewController:sms animated:YES];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    //if (result==MessageComposeResultCancelled) {
    [controller dismissModalViewControllerAnimated:NO];
    //}
}


#pragma mark - send mail

- (void)sendEmail{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mail=[[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate=self;
        [mail setSubject:NSLocalizedString(@"Email Invite Subject", @"Email Invite Subject")];
        [mail setMessageBody:NSLocalizedString(@"Email Invite Body", @"Email Invite Body") isHTML:NO];
        
        [self presentModalViewController:mail animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    //if (result==MFMailComposeResultCancelled) {
    [controller dismissModalViewControllerAnimated:NO];
    //}
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

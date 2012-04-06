//
//  InvitationViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "InvitationViewController.h"

@implementation InvitationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableViewStyle = UITableViewStyleGrouped;
        self.variableHeightRows = YES;
    }
    return self;
}


-(void)createModel
{
    TTTableImageItem  *emailCell = [TTTableImageItem itemWithText:NSLocalizedString(@"Invite Friends By Email", @"Invite Friends By Email")  delegate:self selector:@selector(sendEmail)];
    emailCell.imageURL=@"bundle://more_friend.png";
    
    TTTableImageItem *weiboCell = [TTTableImageItem itemWithText:NSLocalizedString(@"Invite Friends By Sina Weibo", @"Invite Friends By Sina Weibo") delegate:self selector:@selector(SendWeibo)];
    weiboCell.imageURL=@"bundle://more_friend.png";
    
    TTTableImageItem  *smsCell = [TTTableImageItem itemWithText:NSLocalizedString(@"Invite Friends By SMS", @"Invite Friends By SMS")  delegate:self selector:@selector(sendSms)];
    smsCell.imageURL=@"bundle://more_friend.png";
    
    
    if (![MFMessageComposeViewController canSendText]) {
        self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                           NSLocalizedString(@"Invite Friends", @"Invite Friends"),
                           emailCell,
                           weiboCell,
                           nil];
    }else{
        self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                           NSLocalizedString(@"Invite Friends", @"Invite Friends"),
                           emailCell,
                           smsCell,
                           weiboCell,
                           nil];
    }
}

- (void)sendEmail{
   
    if ([MFMailComposeViewController canSendMail]) {
       
        MFMailComposeViewController *mail=[[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate=self;
        [mail setSubject:NSLocalizedString(@"Email Invite Subject", @"Email Invite Subject")];
        [mail setMessageBody:NSLocalizedString(@"Email Invite Body", @"Email Invite Body") isHTML:NO];
        [self presentModalViewController:mail animated:YES];
    }
}


- (void)sendSms{
    if (![MFMessageComposeViewController canSendText]) {
        return;
    }
    MFMessageComposeViewController *sms=[[MFMessageComposeViewController alloc] init];
    sms.messageComposeDelegate=self;
    [sms setBody:NSLocalizedString(@"SMS Invite", @"SMS Invite")];
    
    [self presentModalViewController:sms animated:YES];
}

- (void)SendWeibo{
    WeiBoHelper *application = [WeiBoHelper sharedInstance];
    if([application isWeiBoLogon])
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
    WeiBoHelper *application = [WeiBoHelper sharedInstance];
    application.delegate = nil;
    [application sendWeibo:NSLocalizedString(@"Weibo Invite Body", @"Weibo Invite Body") image:nil andDelegate:self];
}

- (void)request:(WBRequest *)request didLoad:(id)result{
  WeiBoHelper *application = [WeiBoHelper sharedInstance];
    [application dismissWeiboSendView];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    //if (result==MessageComposeResultCancelled) {
    [self dismissModalViewController];
    //}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    //if (result==MFMailComposeResultCancelled) {
    [self dismissModalViewController];
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

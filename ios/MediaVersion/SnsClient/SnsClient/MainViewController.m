//
//  MainViewController.m
//  SnsClient
//
//  Created by  on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "LogonViewController.h"
#import "WeiBoHelper.h"
@implementation MainViewController
//@synthesize btnArray=btnArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(UserDidLogonSuccess:) 
                                                     name:@"UserDidLogonSuccess" 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(UserDidLogoutSuccess:) 
                                                     name:@"UserDidLogoutSuccess" 
                                                   object:nil];

    }
    return self;
}

-(void)setLogonUrls
{
    [self setTabURLs:[NSArray arrayWithObjects:
                      @"tt://share",
                      @"tt://localnews",
                      @"tt://publish",
                      @"tt://mygroup",
                      @"tt://ucenter",
                      nil]];
}


-(void)setLogoutUrls
{
    [self setTabURLs:[NSArray arrayWithObjects:
                      @"tt://share",
                      @"tt://localnews",
                      @"tt://publish",
                      @"tt://mygroup",
                      @"tt://logon",
                      nil]];
}

- (void)UserDidLogonSuccess:(NSNotification*)notification{
    
    [self setLogonUrls];
    self.selectedIndex = 0;
    
//    NSString *uid = [NSString stringWithFormat:@"%@", notification.object];
//    SnUserAppInfo *uinfo = [UserHelper GetUserAppInfo];   
//    //////////  换人登录 登出微博 ////////////////
//    if(TTIsStringWithAnyText(uinfo.WeiBoUserID) && ![uid isEqualToString:uinfo.WeiBoUserID])
//    {
//        SnsClientAppDelegate *application = (SnsClientAppDelegate*)[[UIApplication sharedApplication] delegate];
//        [application weiboLogout];
//    }
}

- (void)UserDidLogoutSuccess:(NSNotification*)notification{
    [self setLogoutUrls];
    self.selectedIndex = 0;
    
   WeiBoHelper *application = [WeiBoHelper sharedInstance];
    [application weiboLogout];
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserDidLogonSuccess"  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserDidLogoutSuccess"  object:nil];
}

-(void)dealloc
{
    [super dealloc];
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
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    if([UserHelper isLogon])
    {
        [self setLogonUrls];
    }
    else
    {
        [self setLogoutUrls];
    }
    self.selectedIndex = 0;
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; 
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//- (void)centerButtonSelected: (UIButton *)button{
//    
//    self.selectedIndex=button.tag;
//    for (int index=0; index<btnArray.count; index++) {
//        UIButton *btn=[btnArray objectAtIndex:index];
//        btn.selected=NO;
//    }
//    button.selected=YES;
//}
//
//
//- (void)centerButtonSelectedWithIndex: (NSInteger)index{
//    
//    self.selectedIndex=index;
//    for (int i=0; i<btnArray.count; i++) {
//        UIButton *btn=[btnArray objectAtIndex:i];
//        btn.selected=NO;
//    }
//    UIButton *btn=[btnArray objectAtIndex:index];
//    btn.selected=YES;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)loadTabBarButton
//{
//    UIImage *buttonImage=[UIImage imageNamed:@"near_a.png"];
//    UIImage *highlightImage=[UIImage imageNamed:@"near_hover.png"];
//    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
//    [button setBackgroundImage:highlightImage forState:UIControlStateSelected];
//    button.tag=0;
//    button.selected=YES;
//    
//    [button addTarget:self action:@selector(centerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //////
//    UIImage *buttonImage1=[UIImage imageNamed:@"pape_a.png"];
//    UIImage *highlightImage1=[UIImage imageNamed:@"pape_hover.png"];
//    
//    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button1.frame = CGRectMake(0.0, 0.0, 112, 50);
//    [button1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
//    [button1 setBackgroundImage:buttonImage1 forState:UIControlStateHighlighted];
//    [button1 setBackgroundImage:highlightImage1 forState:UIControlStateSelected];
//    button1.tag=1;
//    
//    [button1 addTarget:self action:@selector(centerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    //////
//    UIImage *buttonImage2=[UIImage imageNamed:@"zoom_a.png"];
//    UIImage *highlightImage2=[UIImage imageNamed:@"zoom_hover.png"];
//    
//    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button2.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button2.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [button2 setBackgroundImage:buttonImage2 forState:UIControlStateNormal];
//    [button2 setBackgroundImage:buttonImage2 forState:UIControlStateHighlighted];
//    [button2 setBackgroundImage:highlightImage2 forState:UIControlStateSelected];
//    button2.tag=2;
//    
//    [button2 addTarget:self action:@selector(centerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    //////
//    btnArray=[[NSArray alloc] initWithObjects:button, button1, button2,nil];
//    
//    //others
//    CGFloat centerY=self.tabBar.center.y;
//    CGFloat cx1=52;
//    CGFloat cx2=104+56;
//    CGFloat cx3=104+112+52;
//    
//    button.center=CGPointMake(cx1,centerY);
//    button1.center=CGPointMake(cx2,centerY);
//    button2.center=CGPointMake(cx3,centerY);
//    [self.view addSubview:button];
//    [self.view addSubview:button1];
//    [self.view addSubview:button2];
//    //TT_RELEASE_SAFELY(btnArray);
//}

//-(void)openPublicView:(id)sender
//{
//    TTOpenURL(@"tt://publish");
//}

//-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    if(![UserHelper isLogon])
//    {
//        if(item.tag == 4)
//        {
//            LogonViewController *view = [[LogonViewController alloc] initWithNibName:nil bundle:nil];
//            TTNavigationController *nav =[[[TTNavigationController alloc] initWithRootViewController:view]autorelease];
//            [self presentModalViewController:nav animated:YES];
//            [view release];
//            return;
//        }
//    }
//}


@end

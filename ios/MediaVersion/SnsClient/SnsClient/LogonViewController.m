//
//  LogonViewController.m
//  SnsClient
//
//  Created by  on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LogonViewController.h"
#import "MainViewController.h"
#import "RegisterViewController.h"
#import "SnsClientAppDelegate.h"
#import "UserHelper.h"

@implementation LogonViewController
@synthesize  delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"登录";
       
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_home.png"] tag:4];
        
        self.tableViewStyle = UITableViewStyleGrouped;
        txtPassword = [[UITextField alloc] init];
        txtPassword.secureTextEntry = YES;
        txtUserName = [[UITextField alloc] init];
        
        txtUserName.autocorrectionType=UITextAutocorrectionTypeNo;
        txtUserName.keyboardType=UIKeyboardTypeEmailAddress;
        txtUserName.returnKeyType = UIReturnKeyDone;
        txtUserName.autocapitalizationType= UITextAutocapitalizationTypeNone;
        [txtUserName addTarget:self action:@selector(fnDoLogon:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        txtPassword.returnKeyType = UIReturnKeyDone;
        [txtPassword addTarget:self action:@selector(fnDoLogon:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"确定"]; 
        [rbtn2 addTarget:self action:@selector(fnDoLogon:) forControlEvents:UIControlEventTouchUpInside];
        [rbtn2 sizeToFit];
        btnSubmit =[[UIBarButtonItem alloc] initWithCustomView:rbtn2];
        
        
        TTActivityLabel *loadingview = [[[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 35, 30) style:TTActivityLabelStyleWhite text:@" " ] autorelease];
        ttloading = [[UIBarButtonItem alloc] initWithCustomView:loadingview];
        
           // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserLoginInSuccess" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self 
//                                                 selector:@selector(UserLoginInSuccess:) 
//                                                     name:@"UserLoginInSuccess" 
//                                                   object:nil];
        
        [txtUserName becomeFirstResponder];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title =  NSLocalizedString(@"Logon",@"登录");
    [txtUserName becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItem =btnSubmit;
    btnSubmit.enabled = YES;
    buttonWeibo.enabled = YES;
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"个人档";
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)UserLoginInSuccess:(NSNotification*)uid
//{
//    NSString *userid = (NSString*)uid.object;
//    [self afterLogin:userid];
//}

#pragma mark weiboLogin
- (void)weiboLogin:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.enabled = NO;
    self.navigationItem.rightBarButtonItem =ttloading;
    btnSubmit.enabled = NO;
    
    WeiBoHelper *application = [WeiBoHelper sharedInstance];
    application.delegate = self;
    application.changeUser = YES;
    [application weiboLogin];
}

- (void)didAfterWeiBologinError:(NSString*)error
{
    [self.navigationController bringControllerToFront:self animated:YES];
    self.navigationItem.rightBarButtonItem =btnSubmit;
    btnSubmit.enabled = YES;
    buttonWeibo.enabled = YES;
}

- (void)didAfterWeiBologin:(NSString*)uid
{
    if(TTIsStringWithAnyText(uid))
    {
        [self afterLogin:uid];
    }
    else
    {
        self.navigationItem.rightBarButtonItem =btnSubmit;
        btnSubmit.enabled = YES;
        buttonWeibo.enabled = YES;
    }
}

#pragma mark actions
-(void)afterLogin:(NSString*)uid;
{
    WeiBoHelper *application = [WeiBoHelper sharedInstance];
    application.delegate = nil;
    
    if(self.tabBarController)
        [self.tabBarController setSelectedIndex:0];
    else
        [self dismissModalViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogonSuccess" object:uid];
    
    if([self.delegate respondsToSelector:@selector(didAfterLogon:)])
        [self.delegate didAfterLogon:uid];
}

-(void)createModel
{
    [super createModel];

    self.dataSource = [SnSectionedDataSource dataSourceWithObjects:
                       //NSLocalizedString(@"Logon",@"登录"),
                       @"",
                       [TTTableControlItem itemWithCaption:NSLocalizedString(@"UserName",@"邮  箱") control:txtUserName],
                       [TTTableControlItem itemWithCaption:NSLocalizedString(@"Password",@"密  码") control:txtPassword],
                       nil];
    
    UIView *fview = [[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 38)];
    buttonWeibo = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonWeibo setBackgroundImage:TTIMAGE(@"bundle://xlwb.png") forState:UIControlStateNormal];
    [buttonWeibo setFrame:CGRectMake(310-126, 10,126, 24)];
    [buttonWeibo addTarget:self action:@selector(weiboLogin:) forControlEvents:UIControlEventTouchUpInside];
    [fview addSubview:buttonWeibo];
    [self.tableView setTableHeaderView:fview];
    [fview release];
    
    UIView *ffview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
     
    //
    UIButton *btnreg = [UIButton buttonWithType:UIButtonTypeCustom];
    //btnreg setTitle:@"注册" forState:UIControlStateNormal];   
    [btnreg setBackgroundImage:TTIMAGE(@"bundle://btnReg.png") forState:UIControlStateNormal];
    [btnreg setFrame:CGRectMake(10, 3, 145, 42)];
    [btnreg addTarget:self action:@selector(fnShowReg:) forControlEvents:UIControlEventTouchUpInside];
    [ffview addSubview:btnreg];
    
    UIButton *btnlogon = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnlogon setBackgroundImage:TTIMAGE(@"bundle://btnLogon.png") forState:UIControlStateNormal];
    [btnlogon setFrame:CGRectMake(165, 3, 145, 42)];
    [btnlogon addTarget:self action:@selector(fnDoLogon:) forControlEvents:UIControlEventTouchUpInside];
    [ffview addSubview:btnlogon];
    
    self.tableView.tableFooterView = ffview;
    [ffview release];

    self.navigationItem.rightBarButtonItem =btnSubmit;

    TTButton *btn = [TTButton buttonWithStyle:@"blueColorBackButton:" title:@"取消"];
    [btn addTarget:self action:@selector(cancelLogon:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
   
}

-(void)fnShowReg:(id)sender 
{
    RegisterViewController *view = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    view.delegate = self;
    TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:view] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
    [view release];
}

-(void)cancelLogon:(id)sender 
{
    if(self.tabBarController)
        [self.tabBarController setSelectedIndex:0];
    else
        [self dismissModalViewControllerAnimated:YES];
}

- (void)didAfterRegister:(NSString*)userid
{
    [self afterLogin:userid];
}

-(void)doAlert:(id)sender  title:(NSString*)title message:(NSString*)message
{
	UIAlertView *alertDialog;
    
    alertDialog = [[UIAlertView alloc] 
                   initWithTitle: title 
                   message:message
                   delegate: nil 
                   cancelButtonTitle: NSLocalizedString(@"Done", @"确定")
                   otherButtonTitles: nil];
    
    [alertDialog show];
	[alertDialog release];
}
#pragma  mark fnDoLogon
-(void)fnDoLogon:(id)sender
{
    
    NSString* username = txtUserName.text;
    NSString* pwd = txtPassword.text;
    
    if(!TTIsStringWithAnyText(username))
    {
        [self doAlert:self title:@"登陆失败" message:@"请输入email邮箱"];
        return;
    }
    
    if(!TTIsStringWithAnyText(pwd))
    {
        [self doAlert:self title:@"登陆失败" message:@"请输入登陆密码"];
        return;
    }
    username=[username lowercaseString];
    username =[username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    pwd =[pwd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* url = [NSString stringWithFormat:URLUserLogon,KApi_Domain,username,pwd];
    TTURLRequest* request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
    //NSLog(@"logon request:%@",url);
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [request send];

    [UserHelper DegBugWidthLog:url title:@"logon"];
}
#pragma mark - TTURLRequest
//////////////////////////////// TTURLRequestDelegate ///////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request
{
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    NSDictionary* result = [response.rootObject objectForKey:@"SecLogonResult"];
    NSString* resultval  = [result objectForKey:@"UserId"];
    NSString* returnSec  = [result objectForKey:@"UserSecToken"]; 
    //NSLog(@"sec:%@",returnSec);
    
    if(TTIsStringWithAnyText(resultval) && TTIsStringWithAnyText(returnSec))
    {
        [UserHelper SetUserLogon:resultval usertoken:returnSec];
        
        [self afterLogin:resultval];
        //return;
    }
    else
    {
        [self doAlert:self title:@"登录失败" message:@"请输入正确的登录名和密码"];
        self.navigationItem.rightBarButtonItem =btnSubmit;
    }
}

- (void)requestDidStartLoad:(TTURLRequest*)request
{
    self.navigationItem.rightBarButtonItem =ttloading;
    btnSubmit.enabled = NO;
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error
{
    self.navigationItem.rightBarButtonItem =btnSubmit;
    btnSubmit.enabled = YES;
}

- (void)requestDidCancelLoad:(TTURLRequest*)request
{
   self.navigationItem.rightBarButtonItem =btnSubmit;
    btnSubmit.enabled = YES;
    
   [UserHelper doAlert:self title:@"登录失败" message:@"请检查您的网络环境！"];
}
//////////////////////////////// End TTURLRequestDelegate ///////////////////////////////////////
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
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserLoginInSuccess" object:nil];
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void)dealloc
{
    [super dealloc];
    //    TT_RELEASE_CF_SAFELY(txtPassword);
    //    TT_RELEASE_CF_SAFELY(txtUserName);
    //    TT_RELEASE_CF_SAFELY(btnSubmit);
    //    TT_RELEASE_CF_SAFELY(ttloading);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end

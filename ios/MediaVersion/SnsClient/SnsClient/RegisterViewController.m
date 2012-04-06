//
//  RegisterViewController.m
//  SnsClient
//
//  Created by  on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainViewController.h"
#import "UserHelper.h"

@implementation RegisterViewController
@synthesize delegate = _delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title =  NSLocalizedString(@"Register",@"注册");
        self.tableViewStyle = UITableViewStyleGrouped;
        txtPassword = [[UITextField alloc] init];
        txtPassword.secureTextEntry = YES;
        txtUserName = [[UITextField alloc] init];
        txtNickName = [[UITextField alloc] init];
        
        txtUserName.autocorrectionType=UITextAutocorrectionTypeNo;
        txtUserName.keyboardType=UIKeyboardTypeEmailAddress;
        txtUserName.returnKeyType = UIReturnKeyDone;
        txtUserName.autocapitalizationType= UITextAutocapitalizationTypeNone;
        [txtUserName addTarget:self action:@selector(fnDoRegister:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        txtPassword.returnKeyType = UIReturnKeyDone;
        [txtPassword addTarget:self action:@selector(fnDoRegister:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        txtNickName.returnKeyType = UIReturnKeyDone;
        [txtNickName addTarget:self action:@selector(fnDoRegister:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        
        TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"确定"]; 
        [rbtn2 addTarget:self action:@selector(fnDoRegister:) forControlEvents:UIControlEventTouchUpInside];
        [rbtn2 sizeToFit];
        btnSubmit =[[UIBarButtonItem alloc] initWithCustomView:rbtn2];
        
        
        TTActivityLabel *loadingview = [[[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 35, 30) style:TTActivityLabelStyleWhite text:@" " ] autorelease];
        ttloading = [[UIBarButtonItem alloc] initWithCustomView:loadingview];
        
        _sex = 1;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}

-(void)createModel
{
    
    NSArray *sexes = [NSArray arrayWithObjects:
                                   @"男",
                                   @"女",
								   nil];
    
	sexControl = [[UISegmentedControl alloc] initWithItems:sexes];
	sexControl.selectedSegmentIndex = 0;
	sexControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	sexControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [sexControl addTarget:self action:@selector(sexChanged:) forControlEvents:UIControlEventValueChanged];
    [sexControl setSegmentedControlStyle:UISegmentedControlStylePlain];
    [sexControl setFrame:CGRectMake(10, 8, 200, 32)];
    
    self.dataSource = [SnSectionedDataSource dataSourceWithObjects:
                       //NSLocalizedString(@"Register",@"注册"),
                       @"",
                       [TTTableControlItem itemWithCaption:NSLocalizedString(@"NickName",@"昵  称") control:txtNickName],
                       [TTTableControlItem itemWithCaption:NSLocalizedString(@"UserName",@"邮  箱") control:txtUserName],
                       [TTTableControlItem itemWithCaption:NSLocalizedString(@"Password",@"密  码") control:txtPassword],
                       [TTTableControlItem itemWithCaption:NSLocalizedString(@"Sex",@"性  别") control:sexControl],
                       nil];
    
    self.navigationItem.rightBarButtonItem =btnSubmit;
    
    _agreeMent = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeMent setFrame:CGRectMake(10,4, 16, 16)];
    [_agreeMent  setBackgroundImage:[UIImage imageNamed: @"input_no.png"] forState:UIControlStateNormal];
    [_agreeMent  setBackgroundImage:[UIImage imageNamed: @"input_no.png"] forState:UIControlStateHighlighted];
    [_agreeMent  setBackgroundImage:[UIImage imageNamed: @"input_yes.png"] forState:UIControlStateSelected];
    [_agreeMent addTarget:self action:@selector(changeAgreement:) forControlEvents:UIControlEventTouchUpInside];
    [_agreeMent setSelected:YES];
    
    UIButton *buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttom setFrame: CGRectMake(26, 0, 100, 25)];
    [buttom setTitle:@"我同意看过网" forState:UIControlStateNormal];
    [buttom.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttom.titleLabel setTextAlignment:UITextAlignmentLeft];
    [buttom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttom addTarget:self action:@selector(changeAgreement:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *buttom1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttom1 setFrame: CGRectMake(115, 0, 100, 25)];
    [buttom1 setTitle:@"《服务条款》" forState:UIControlStateNormal];
    [buttom1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttom1.titleLabel setTextAlignment:UITextAlignmentLeft];
    [buttom1 setTitleColor:RGBCOLOR(0, 153, 204) forState:UIControlStateNormal];
    [buttom1 addTarget:self action:@selector(showAgreement) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *ffview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    [ffview addSubview:_agreeMent];
    [ffview addSubview:buttom];
    [ffview addSubview:buttom1];

    
    UIButton *btnreg = [UIButton buttonWithType:UIButtonTypeCustom];
    //btnreg setTitle:@"注册" forState:UIControlStateNormal];   
    [btnreg setBackgroundImage:TTIMAGE(@"bundle://btnLogon.png") forState:UIControlStateNormal];
    [btnreg setFrame:CGRectMake(10, 42, 145, 42)];
    [btnreg addTarget:self action:@selector(cancelReg:) forControlEvents:UIControlEventTouchUpInside];
    [ffview addSubview:btnreg];
    
    UIButton *btnlogon = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnlogon setBackgroundImage:TTIMAGE(@"bundle://btnReg.png") forState:UIControlStateNormal];
    [btnlogon setFrame:CGRectMake(165, 42, 145, 42)]; 
    [btnlogon addTarget:self action:@selector(fnDoRegister:) forControlEvents:UIControlEventTouchUpInside];
    [ffview addSubview:btnlogon];
    
    self.tableView.tableFooterView = ffview;
    [ffview release];
    
    TTButton *btn = [TTButton buttonWithStyle:@"blueColorBackButton:" title:@"取消"];
    [btn addTarget:self action:@selector(cancelReg:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Logon",@"登录") style:UIBarButtonItemStyleDone target:@"tt://logon" action:@selector(openURLFromButton:)];
//    self.navigationItem.leftBarButtonItem =leftBtn;
//    [leftBtn release];
    
    [super createModel];
}

-(void)showAgreement{    
    //NSURL *url = [[NSURL alloc] initWithString:@"http://www.kanguo.com/Public/Clause"];
    TTOpenURL(@"http://www.kanguo.com/Public/Clause");
//    TTWebController *view = [[TTWebController alloc] initWithNavigatorURL:url query:nil];
//    AgreementController *nav = [[[AgreementController alloc] initWithRootViewController:view] autorelease];
//    
//    //view.navigationItem.hidesBackButton = NO;
//    
//    TTButton *vew = [TTButton buttonWithStyle:@"grayColorBackButton:" title:NSLocalizedString(@"Back", @"返回")];
//    [vew addTarget:nav action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
//    [vew setFont:[UIFont systemFontOfSize:12]];
//    [vew setFrame:CGRectMake(0, 0, 60, 32)];
//    view.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:vew] autorelease]; 
//    [self presentModalViewController:nav animated:YES];
//    [view release];
}

-(void)changeAgreement:(id)sender
{
    _agreeMent.selected = !_agreeMent.selected;
}

-(void)cancelReg:(id)sender 
{
    //[self.tabBarController setSelectedIndex:0]; 
    [self dismissModalViewControllerAnimated:YES];
}

-(void)sexChanged:(id)sender
{
    if(sexControl.selectedSegmentIndex == 0)
        _sex = 1;
    else
        _sex = 0;
}

-(void)didEndDragging
{
    [super didEndDragging];
    [txtUserName resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtNickName resignFirstResponder];
}

-(void)dealloc
{
//    TT_RELEASE_SAFELY(sexControl);
//    TT_RELEASE_CF_SAFELY(txtPassword);
//    TT_RELEASE_CF_SAFELY(txtNickName);
//    TT_RELEASE_CF_SAFELY(txtUserName);
//    TT_RELEASE_SAFELY(btnSubmit);
//    TT_RELEASE_SAFELY(ttloading);
    [super dealloc];
}

//show alert
-(void)doAlert:(id)sender  title:(NSString*)title message:(NSString*)message{
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

-(void)fnDoRegister:(id)sender
{
    NSString* username = txtUserName.text;
    NSString* nickname = txtNickName.text;
    NSString* pwd = txtPassword.text;
    
    
    if(!_agreeMent.selected)
    {
        [self doAlert:self title:@"注册失败" message:@"必须同意《看过网服务条款》才你能注册"];
        return;
    }
    
    //NSString* nickname = txtNickName.text;
    if(!TTIsStringWithAnyText(nickname))
    {
        [self doAlert:self title:@"注册失败" message:@"请输入昵称"];
        return;
    }
    if(!TTIsStringWithAnyText(nickname))
    {
        [self doAlert:self title:@"注册失败" message:@"请输入email邮箱"];
        return;
    }
    if(!TTIsStringWithAnyText(pwd))
    {
        [self doAlert:self title:@"注册失败" message:@"请输入登录密码"];
        return;
    }
//    if(!TTIsStringWithAnyText(nickname))
//    {
//        [self doAlert:self title:NSLocalizedString(@"Login failed", @"登陆失败") message:NSLocalizedString(@"Please fill confirm nickname", @"请确认昵称！")];
//        return;
//    }
//    if(![pwd2 isEqualToString:pwd])
//    {
//        [self doAlert:self title:NSLocalizedString(@"Login failed", @"登陆失败") message:NSLocalizedString(@"Password dosn't match confirm password", @"两次输入的密码不相同！")];
//        return;
//    }
    
    username=[username lowercaseString];
    username =[username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    nickname=[nickname lowercaseString];
    nickname =[nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    pwd=[pwd lowercaseString];
    //nickname=[nickname lowercaseString];
    
    CLLocation *nowlocal = [UserHelper GetUserLocation];
    NSString* url = [NSString stringWithFormat:URLUserRegister,KApi_Domain,username,pwd,nickname,[NSString stringWithFormat:@"%f",nowlocal.coordinate.latitude],[NSString stringWithFormat:@"%f",nowlocal.coordinate.longitude],_sex];
    
    TTURLRequest* request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    //_request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [request send];
    
    [UserHelper DegBugWidthLog:url title:@"register"];
    
}

-(void)afterLogin:(NSString*)uid;
{
    [self dismissModalViewControllerAnimated:NO];
    [self.delegate didAfterRegister:uid];
    
//    SnUserAppInfo *uifo = [UserHelper GetUserAppInfo];
//    if(uifo.LastVesion <NowVesion)
//    {
//        UserGuideController *guide = [[UserGuideController alloc] init];
//        [self.navigationController pushViewController:guide animated:YES];
//        [guide release];
//    }
//    else
//    {
//        MainViewController *main = [[MainViewController alloc] initWithNibName:nil bundle:nil]; 
//        [self.navigationController presentModalViewController:main animated:NO];
//        [main release];
//    }
}

/////////////////////////// TTURLRequestDelegate //////////////////////
- (void)requestDidStartLoad:(TTURLRequest*)request
{
    self.navigationItem.rightBarButtonItem =ttloading;
}


- (void)requestDidFinishLoad:(TTURLRequest*)request
{
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* result = [response.rootObject objectForKey:@"RegisteResult"];
    bool Success =  [[result objectForKey:@"Success"]  boolValue];
    if(Success)
    {
        NSString* resultval  = [NSString stringWithFormat:@"%@", [result objectForKey:@"UserId"]];
        NSString* returnSec  = [NSString stringWithFormat:@"%@", [result objectForKey:@"UserSecToken"]];
        [UserHelper SetUserLogon:resultval usertoken:returnSec];
        [self afterLogin:resultval];
    }
    else
    {
        NSString* errorMessage  = [result objectForKey:@"ErrorMessage"];  
        if(!TTIsStringWithAnyText(errorMessage))
            errorMessage = @"注册失败";
        
        [self doAlert:self title:@"注册失败" message:errorMessage];
    }
    self.navigationItem.rightBarButtonItem =btnSubmit;
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error
{
    self.navigationItem.rightBarButtonItem =btnSubmit;
}

- (void)requestDidCancelLoad:(TTURLRequest*)request
{
    self.navigationItem.rightBarButtonItem =btnSubmit;
}
/////////////////////////// End TTURLRequestDelegate //////////////////////



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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[txtNickName becomeFirstResponder];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

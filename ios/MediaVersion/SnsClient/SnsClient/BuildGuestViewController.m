//
//  BuildGuestViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BuildGuestViewController.h"
#import "MainViewController.h"

@implementation BuildGuestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    CGRect frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
    self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
    
    [self.view setBackgroundColor:RGBCOLOR(200, 200, 200)];
    
    TTActivityLabel *loading = [[TTActivityLabel alloc] initWithFrame:CGRectMake(80, 200, 160, 35) style:TTActivityLabelStyleGray text:@"正在加载..."];
    [self.view addSubview:loading];
    [loading release];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}
                                    
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    NSString  *drviceID = [UserHelper registeHWMac];
    NSString* url = [NSString stringWithFormat:URLGuestLogin,KApi_Domain,drviceID];
    TTURLRequest* request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [request send];
    [UserHelper DegBugWidthLog:url title:@"logon"];
}

#pragma mark - TTURLRequest
-(void)requestDidFinishLoad:(TTURLRequest *)request
{
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    NSDictionary* result = [response.rootObject objectForKey:@"GetGuestUsersResult"];
    bool Success = [[result objectForKey:@"Success"] boolValue];
    
    if(Success)
    {
        NSString* resultval  = [result objectForKey:@"userId"];
        NSString* returnSec  = [result objectForKey:@"Token"]; 
        
        [UserHelper SetGuestLogon:resultval usertoken:returnSec];
        
        MainViewController *main = [[[MainViewController alloc] initWithNavigatorURL:nil query:nil] autorelease];
        [self.navigationController pushViewController:main animated:NO];
        
        //TTOpenURL(@"tt://main");
    }
    else
    {
        [UserHelper doAlert:self title:@"初始化失败" message:@"请检查您的网络环境"];
    }
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    [UserHelper doAlert:self title:@"初始化失败" message:@"请检查您的网络环境"];
}
#pragma mark - View lifecycle
-(void)setView:(UIView *)view
{
    if(!view)
        return;
    
    [super setView:view];
}

- (void)didReceiveMemoryWarning
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

- (void)viewDidUnload
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

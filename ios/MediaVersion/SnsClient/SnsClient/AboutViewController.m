//
//  AboutViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"关于";

        imgView = [[TTImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        imgView.urlPath = @"bundle://m_about.png";
        //[imgView setImage:TTIMAGE(@"bundle://m_about.png")];
        
        [self.view addSubview:imgView];
        
        // add gesture recognizers to the image view  
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];  
        //UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];  
        //UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];  
        
        //[doubleTap setNumberOfTapsRequired:2];  
        //[twoFingerTap setNumberOfTouchesRequired:2]; 
        
        [imgView addGestureRecognizer:singleTap];  
        //[imgView addGestureRecognizer:doubleTap];  
        //[imgView addGestureRecognizer:twoFingerTap];  
        
        
        [singleTap release];  
        //[doubleTap release];  
        //[twoFingerTap release];

    
        self.statusBarStyle = UIStatusBarStyleBlackTranslucent;
        self.navigationBarStyle = UIBarStyleBlackTranslucent;
        self.navigationBarTintColor = nil;
        self.wantsFullScreenLayout = YES;
        self.hidesBottomBarWhenPushed = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(30, 325, 270, 100)];
        //[btn setBackgroundColor:[UIColor redColor]];
        [btn addTarget:self action:@selector(gotoKanguo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

    }
    return self;
}

-(void)gotoKanguo
{
    NSString *url = @"http://itunes.apple.com/cn/app/id465016768?ls=1&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    // TTOpenURL(url);
}

//-(void)lodHtml:(NSString*)url
//{
//    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
//    NSString *filePath =[resourcePath stringByAppendingPathComponent:url];
//    //encoding:NSUTF8StringEncoding error:nil 这一段一定要加，不然中文字会乱码
//    NSString*htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];  
//    [myWebView loadHTMLString:htmlstring baseURL:[NSURL fileURLWithPath:[ [NSBundle mainBundle] bundlePath]]];
//}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    CGRect frame = self.view.bounds;
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, frame.size.height)];
//    [leftView setBackgroundColor:RGBCOLOR(197, 204, 212)];
//    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setFrame:CGRectMake(0, 15, 75, 70)];
//    [btn1 setBackgroundImage:TTIMAGE(@"bundle://logo_left01.png") forState:UIControlStateNormal];
//    [leftView addSubview:btn1];
//    
//    UIButton *btn2 =[UIButton buttonWithType:UIButtonTypeCustom];;
//    [btn2 setFrame:CGRectMake(0, 95, 75, 70)];
//    [btn2 setBackgroundImage:TTIMAGE(@"bundle://logo_left02.png") forState:UIControlStateNormal];
//    [leftView addSubview:btn2];
//    
//    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];;
//    [btn3 setFrame:CGRectMake(0, 175, 75, 70)];
//    [btn3 setBackgroundImage:TTIMAGE(@"bundle://logo_left03.png") forState:UIControlStateNormal];
//    [leftView addSubview:btn3];
//    
//    [self.view addSubview:leftView];
//    [leftView release];
//    
//    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(75, 0, frame.size.width - 75, frame.size.height)];
//    [self.view addSubview:myWebView];
//    [self lodHtml:@"about1.htm"];
}

//-(void)dealloc {
//    [myWebView release];
//    [super dealloc];
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isShowingChrome {
    UINavigationBar* bar = self.navigationController.navigationBar;
    return bar ? bar.alpha != 0 : 1;
}


- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
    // single tap does nothing for now  
    if ([self isShowingChrome]) {
        [self showBars:NO animated:YES];
        
    } else {
        [self showBars:YES animated:NO];
    }
}  


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
   
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UINavigationBar* bar = self.navigationController.navigationBar;
    if(bar)
    {
        bar.alpha = 0;
        [self showBars:NO animated:YES];
    }
}

-(void)goBack
{
    [self dismissModalViewControllerAnimated:YES]; 
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

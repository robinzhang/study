//
//  UserGuideController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserGuideController.h"
#import "BuildGuestViewController.h"

@implementation UserGuideController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self.view setBackgroundColor:[UIColor blackColor]];
        //[self.view setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg01.png")]];
        self.title = NSLocalizedString(@"User Guide", @"使用帮助");
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}

-(int)GetFrameId
{
    return 3;
}

//-(void)doBackHome:(id)sender
//{
////    MyUserCenterController *ucenter = [[MyUserCenterController alloc] initWithNibName:nil bundle:nil];
////    [self.navigationController pushViewController:ucenter animated:YES];
////    [ucenter release];
//    TTOpenURL(@"tt://profile");
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    CGRect frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
    self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg01.png")]];
    
    _pageControl = [[TTPageControl alloc] initWithFrame:CGRectMake(0,appFrame.size.height - 20, 320, 20)];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _pageControl.backgroundColor = RGBACOLOR(100, 100, 100, 50);
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 3;
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    _scrollView = [[TTScrollView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 320, 
                                                                 480)];
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.dataSource = self;
    _scrollView.delegate = self;
    _scrollView.pageSpacing = 0;
    _scrollView.zoomEnabled = NO;
    _scrollView.backgroundColor = RGBCOLOR(200, 200, 200);
    [self.view addSubview:_scrollView];
}

-(void)goBackToHome
{
    SnUserAppInfo *uifo = [UserHelper GetUserAppInfo];
    if(uifo.LastVesion < NowVesion)
    {
        uifo.LastVesion =NowVesion;
        [UserHelper SetUserAppInfo:uifo];
        
        if([UserHelper isLogon] || [UserHelper isGuestLogon])
        {
            MainViewController *main = [[[MainViewController alloc] initWithNavigatorURL:nil query:nil] autorelease];
            [self.navigationController pushViewController:main animated:NO];
            //TTOpenURL(@"tt://main");
        }
        else
        {
            BuildGuestViewController *main = [[[BuildGuestViewController alloc] initWithNavigatorURL:nil query:nil] autorelease];
            [self.navigationController pushViewController:main animated:NO];
            //TTOpenURL(@"tt://buildguest");
        }
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self dismissModalViewControllerAnimated:NO];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTScrollViewDataSource

- (NSInteger)numberOfPagesInScrollView:(TTScrollView*)scrollView {
    return 5;
}


- (UIView*)scrollView:(TTScrollView*)scrollView pageAtIndex:(NSInteger)pageIndex {
    UIView* pageView = nil;
    if (!pageView) {
        pageView = [[[UIView alloc] init] autorelease];
        pageView.backgroundColor = _scrollView.backgroundColor;
        pageView.userInteractionEnabled = NO;
        [pageView setFrame:CGRectMake(0, 0, 320, 480)];
        
        if(pageIndex == 4)
        {
            TTActivityLabel *loading = [[TTActivityLabel alloc] initWithFrame:CGRectMake(80, 200, 160, 35) style:TTActivityLabelStyleGray text:@"正在加载..."];
            [pageView addSubview:loading];
            [loading release];
        }
        else
        {
            int ii = pageIndex + 1;
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            NSString *path = [NSString stringWithFormat:@"m_help_%i.png",ii];
            [imgv setImage:[UIImage imageNamed: path]];
            [pageView addSubview:imgv];
            [imgv release];
            pageView.contentMode = UIViewContentModeScaleToFill;
        }
       
    }
    return pageView;
}

- (CGSize)scrollView:(TTScrollView*)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex {
    return CGSizeMake(320, 480);
}

#pragma mark -
#pragma mark TTScrollViewDelegate

- (void)scrollView:(TTScrollView*)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex {
    _pageControl.currentPage = pageIndex;
    if(pageIndex == 4)
        [self goBackToHome];
}

#pragma mark -
#pragma mark UIViewController overrides
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
#pragma mark -
#pragma mark TTPageControl

- (IBAction)changePage:(id)sender {
    int page = _pageControl.currentPage;
    [_scrollView setCenterPageIndex:page];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
   //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)setView:(UIView *)view
{
    if(view == nil)
        return;
    
    [super setView:view];
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
   // [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
@end


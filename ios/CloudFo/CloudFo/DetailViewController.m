//
//  DetailViewController.m
//  Three20UICommon
//
//  Created by robin on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import <Three20/Three20.h>
#define tabHeight 36
@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"正文";
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStyleBordered
                                         target:nil action:nil] autorelease];
    }
    return self;
}
//开始加载内容
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating] ;
}
//结束加载
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
    [alterview release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)viewDidLoad
{
    self.view = [[[UIView alloc] init] autorelease];
    self.view.backgroundColor = [UIColor redColor];
    webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)] autorelease];
    [webView setDelegate: self ]; //委托
    [webView setOpaque: NO ]; //透明
    [self.view addSubview:webView];

    
    opaqueview = [[[UIView alloc]  initWithFrame: CGRectMake(150,200,32,32)] autorelease];   
    [ opaqueview  setAlpha: 0.6 ];

    activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithFrame : CGRectMake(0, 0, 32, 32)] autorelease] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ; 
    
    [ self . view  addSubview :  opaqueview];
    [ opaqueview  addSubview : activityIndicatorView];
    
    [self loadWebPageWithString:@"http://www.qq.com"]; 
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)loadView {

}

- (void)dealloc {
	[super dealloc];
}

@end

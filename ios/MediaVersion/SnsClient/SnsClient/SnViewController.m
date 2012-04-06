//
//  SnViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnViewController.h"

@implementation SnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect frame = self.view.bounds;
        
        // SnSubTitleView
        
        SntitleView = [TTButton buttonWithStyle:@"SnSubTitleView:"];
        [ SntitleView setFrame:CGRectMake(0 , 0, frame.size.width , KPageTitleHeight)];
        [self.view addSubview:SntitleView];
        
        
        UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 30)];
        [titleView setImage:TTIMAGE(@"bundle://icon_toplogo.png")];
        self.navigationItem.titleView  = titleView;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SntitleView setTitle:self.title forState:UIControlStateNormal ];
}



#pragma mark - View lifecycle
- (void)didReceiveMemoryWarning
{
    
}
- (void)setView:(UIView *)view
{
    if(!view)
        return;
    
    [super setView:view];
}

- (void)viewDidUnload
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

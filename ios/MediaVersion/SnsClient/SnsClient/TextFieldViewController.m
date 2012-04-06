//
//  TextFiledViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TextFieldViewController.h"

@implementation TextFieldViewController
@synthesize delegate = _delegate;
@synthesize callBackTag = _callBackTag;

- (id)initWithText:(NSString*)text  tag:(int)tag
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _callBackTag = tag;
        _text = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
        [_text setText:text];
        [_text setBorderStyle:UITextBorderStyleNone];
        //_text.delegate = self;
        _text.tag = tag;
        _text.font = [UIFont systemFontOfSize:16];

        self.tableViewStyle = UITableViewStyleGrouped;
        self.variableHeightRows = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"确定"]; 
    [rbtn2 addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [rbtn2 sizeToFit];
    self.navigationItem.rightBarButtonItem=  [[[UIBarButtonItem alloc] initWithCustomView:rbtn2] autorelease];
    
    [_text becomeFirstResponder];
    

    
    TTButton *rbtn1 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:NSLocalizedString(@"Cancel",@"取消")   ]; 
    [rbtn1 addTarget:self action:@selector(OnClick_btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [rbtn1 sizeToFit];
    self.navigationItem.leftBarButtonItem =[[[UIBarButtonItem alloc] initWithCustomView:rbtn1] autorelease];

}

-(IBAction)OnClick_btnBack:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:self.navigationController.parentViewController animated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)done
{
    //[self dismissModalViewController];
    [_text resignFirstResponder];
    //[self.navigationController bringControllerToFront:self.presentedViewController animated:YES];
    [self.delegate didTextFieEndEditing:_text.text tag:_text.tag];
}

-(void)cancel
{
    //[self dismissModalViewController];
}


-(void)createModel
{
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    [control addSubview:_text];
    
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"",
                       control,
                       nil];
    
    //[self.tableView addSubview:_wordCountLabel];
}

#pragma mark - UIEventSubtypeMotionShake
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        UIAlertView * alertDialog = [[UIAlertView alloc] 
                                     initWithTitle:nil
                                     message:@"您确定要撤销清空输入吗？"
                                     delegate:self 
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"撤销输入",nil];
        [alertDialog show];
        [alertDialog release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [_text setText:@""];
    }
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


-(void)dealloc
{
//    TT_RELEASE_SAFELY(_text);
    [super dealloc];
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

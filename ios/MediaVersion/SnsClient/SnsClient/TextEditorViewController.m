//
//  TextEditorViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TextEditorViewController.h"

@implementation TextEditorViewController
@synthesize delegate = _delegate;
@synthesize callBackTag = _callBackTag;

- (id)initWithText:(NSString*)text  title:(NSString*)title tag:(int)tag  maxlength:(int)maxlength
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = title;
        _callBackTag = tag;
//        _text = [[TTTextEditor alloc] initWithFrame:CGRectMake(0, 0, 320, 178)];
//        [_text setText:text];
//        _text.placeholder = title;
//        _text.delegate = self;
//        _text.tag = tag;
//        _text.font = [UIFont systemFontOfSize:14];
//        _text.maxNumberOfLines  = 8;
//        _text.minNumberOfLines  = 8;
        
        int txth = 150;
        
        _text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, txth)];
        //_text.placeholder = title;
        [_text setFont:[UIFont systemFontOfSize:16]];
        _text.delegate = self;
        _text.tag = tag;
        //_text.maxNumberOfLines = 9;
        //_text.autoresizesToText = NO;
        //_text.showsExtraLine = NO;
         [_text setText:text];
        [_text setFrame:CGRectMake(0, 0, 320, txth)];
        [_text setBackgroundColor:[UIColor whiteColor]];
        
        
        _maxTextLenght = maxlength;
        
        _wordCountLabel =[[UILabel alloc] initWithFrame:CGRectMake(20, txth-35, 290, 30)];
        [_wordCountLabel setBackgroundColor:[UIColor clearColor]];
        [_wordCountLabel setTextAlignment:UITextAlignmentRight];
        [_wordCountLabel setFont:[UIFont systemFontOfSize:12]];
        [_wordCountLabel setText:[NSString stringWithFormat:@"%d",_maxTextLenght]];
        [_wordCountLabel setTextColor:[UIColor grayColor]];

        [self textLengthCount];
             
//        self.tableViewStyle = UITableViewStylePlain;
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view setBackgroundColor:[UIColor whiteColor]];
//        self.variableHeightRows = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
#pragma mark UIEventSubtypeMotionShake
///////////////////////////////////////////////////////////////////////////////////////////////////
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
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    int txth = self.view.bounds.size.height - keyboardRect.size.height+45;
    _text.frame =  CGRectMake(0, 0, 320, txth);
    _wordCountLabel.frame = CGRectMake(20, txth -35, 290, 30);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    //NSDictionary* userInfo = [notification userInfo];
    //NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    int txth = self.view.bounds.size.height;
    _text.frame =  CGRectMake(0, 0, 320, txth);
    _wordCountLabel.frame = CGRectMake(20, txth -35, 290, 30);
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:_text];
    [self.view addSubview:_wordCountLabel];
    self.navigationItem.hidesBackButton = YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    
    TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"确定"]; 
    [rbtn2 addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [rbtn2 sizeToFit];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rbtn2];
    
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
//    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back",@"返回") style: UIBarButtonItemStyleBordered target: nil action: nil];
//    [[self navigationItem] setBackBarButtonItem: newBackButton];
//    [newBackButton release];
}


-(void)done
{
    int ll = [self calculateTextNumber:_text.text];
    if(ll > _maxTextLenght)
    {
        [UserHelper doAlert:self title:@"操作提示" message:@"超过了长度限制，无法提交！"];
    }
    else
    {
        //[self dismissModalViewController];
        [_text resignFirstResponder];
        //[self.navigationController bringControllerToFront:self.presentedViewController animated:YES];
        [self.delegate didTextEditorEndEditing:_text.text tag:_text.tag];
    }
}

-(void)cancel
{
    [self dismissModalViewController];
}

- (void)viewDidUnload
{
    //[super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
//-(void)createModel
//{
//    self.variableHeightRows = YES;
//    self.dataSource = [TTListDataSource dataSourceWithObjects:
//                      
//                       _text,
//                       nil];
//    
//    [self.tableView addSubview:_wordCountLabel];
//}



#pragma mark - UITextViewDelegate
- (int)calculateTextNumber:(NSString *) textA
{
	float number = 0.0;
	for (int index = 0; index < [textA length]; index++) {
		
		NSString *character = [textA substringWithRange:NSMakeRange(index, 1)];
		
		if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
			number++;
		} else {
			number = number+0.5;
		}
	}
	return ceil(number);
}

- (void)textLengthCount
{
	int wordcount = [self calculateTextNumber:_text.text];
	NSInteger count  = _maxTextLenght - wordcount;
	if (count < 0) {
		_wordCountLabel.textColor = [UIColor redColor];
	}
	else {
		_wordCountLabel.textColor = [UIColor grayColor];
	}
	
	_wordCountLabel.text = [NSString stringWithFormat:@"%i",count];
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    //[self onbegincomment:self];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(doComplet)];
//}

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//   [self donotcomment:self];
//}
- (void)textViewDidChange:(UITextView *)textView
{
    [self textLengthCount];
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


-(void)dealloc
{
//    TT_RELEASE_SAFELY(_text);
//    TT_RELEASE_CF_SAFELY(_wordCountLabel);
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

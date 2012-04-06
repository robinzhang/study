//
//  DetailCommentViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DetailCommentViewController.h"
@implementation DetailCommentViewController
@synthesize  messageid = _messageid;
@synthesize userid = _userid;
@synthesize me = _me;
@synthesize delegate = _delegate;

- (id)initWithMessage:(NSString*)messageid userid:(NSString*)userid
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.title = @"消息评论";
        self.variableHeightRows = YES;
        self.tableViewStyle = UITableViewStyleGrouped;
        
        _text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 135)];
        //_text.placeholder = @"请输入评论内容";
        [_text setFont:[UIFont systemFontOfSize:14]];
        _text.delegate = self;
        //_text.maxNumberOfLines = 6;
        //_text.autoresizesToText = NO;
        //_text.showsExtraLine = YES;
        [_text  setFrame:CGRectMake(0, 0, 320, 135)];
        
        _me = [UserHelper GetUserID];
        _messageid = messageid;
        _userid = userid;
        
//        btnSubmit = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStyleBordered target:self action:@selector(doSubmit)];
        
        TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"评论"]; 
        [rbtn2 addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
        [rbtn2 sizeToFit];
        btnSubmit = [[UIBarButtonItem alloc] initWithCustomView:rbtn2];
        
//        TTActivityLabel *loadingview = [[[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 35, 30) style:TTActivityLabelStyleWhite text:@" " ] autorelease];
        //ttloading = [[UIBarButtonItem alloc] initWithCustomView:loadingview];
        
        postloading  = [[TTActivityLabel  alloc] initWithFrame:CGRectMake(100, 100, 120, 35) style:TTActivityLabelStyleBlackBezel text:@"正在提交..."];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.me = [UserHelper GetUserID];
    [super viewWillAppear:animated];
    
    TTButton *btn = [TTButton buttonWithStyle:@"blueColorBackButton:" title:NSLocalizedString(@"Back",@"Back")];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = btnSubmit;
}

-(void)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)createModel
{
    switchy = [[UISwitch alloc] init];
    TTTableControlItem* switchItem = [TTTableControlItem itemWithCaption:@"分享到微博" control:switchy];

    _wordCountLabel =[[UILabel alloc] initWithFrame:CGRectMake(20,110, 280, 35)];
    [_wordCountLabel setBackgroundColor:[UIColor clearColor]];
    [_wordCountLabel setTextAlignment:UITextAlignmentRight];
    [_wordCountLabel setFont:[UIFont systemFontOfSize:12]];
    [_wordCountLabel setText:[NSString stringWithFormat:@"%d",kCommentMaxTextCount]];
    [_wordCountLabel setTextColor:[UIColor grayColor]];
    

    
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"",
                       //[TTTableControlItem itemWithCaption:@"请输入评论内容" control:_wordCountLabel],
                       _text,
//                       @"",
//                       [TTTableTextItem itemWithText:@"添加图片"],
                       @"",
                       switchItem,
                       nil
                       ];
    
    UIView *fview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
    button =  [UIButton buttonWithType:UIButtonTypeCustom ];
    [button setBackgroundImage:TTIMAGE(@"bundle://btn_bg_pl.png") forState:UIControlStateNormal];
    [button setFrame:CGRectMake(98, 5,125, 45)];
    
    [button addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
    [fview addSubview:button];
    [self.tableView setTableFooterView:fview];
    [fview release];
    
    [self.tableView addSubview:_wordCountLabel];
}

//
//-(void)doComplet
//{
//    [_text resignFirstResponder];
//    self.navigationItem.rightBarButtonItem = nil;
//}

- (void)didEndDragging {
   [_text resignFirstResponder];
}
#pragma mark - submitComment
-(void)doSubmit
{
    NSString *str=[_text.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!TTIsStringWithAnyText(str))
    {
        [UserHelper doAlert:self title:@"提示信息" message:@"请输入评论内容！"];
        return;
    }
    
    int tc = [self calculateTextNumber:_text.text];
    if(tc > kCommentMaxTextCount)
    {
        [UserHelper doAlert:self title:@"提示信息" message:@"字数超过了长度限制！"];
        return;
    }
    
    NSString* escapedUrlString =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* url = [NSString stringWithFormat:URLCommentNews,KApi_Domain,self.me,self.messageid,self.userid,escapedUrlString];
    
    TTURLRequest *request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    
    request.httpMethod=@"POST";
    //sec

    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    //end sec
    [request setUserInfo:@"comment"];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    
    [UserHelper DegBugWidthLog:url title:@"News Comment"];
    [request send];
}

-(void)sendToWeibo
{
    WeiBoHelper *application = [WeiBoHelper sharedInstance];
    if([application isWeiBoLogon])
    {
         application.delegate = nil;
        
        //评论的内容 + 新闻正文的url
        NSString *url = [NSString stringWithFormat:@"http://www.kanguo.com/TW/TView/%@?tid=%@&refid=  ",self.userid,self.messageid];
        [application sendWeibo:[NSString stringWithFormat:@"%@ %@",_text.text,url] image:nil andDelegate:self];
        [_text setText:@""];
       
    }
}

-(void)didAfterWeiBologinError:(NSString *)error
{
    [self.navigationController bringControllerToFront:self animated:YES];
}

-(void)didAfterWeiBologin:(NSString *)uid
{
    [self.navigationController bringControllerToFront:self animated:YES];
    [self sendToWeibo];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request
{
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = [response.rootObject objectForKey:@"CommentsResult"];
    BOOL Success = [[feed objectForKey:@"Success"] boolValue];  
     
    //TTDASSERT([[feed objectForKey:@"Messages"] isKindOfClass:[NSArray class]]);

    [UserHelper DegBugWidthLog:[feed objectForKey:@"Messages"] title:@"CommentsResult"];
    
    btnSubmit.enabled = YES;
    [postloading removeFromSuperview];
    button.enabled = YES;
    self.navigationItem.rightBarButtonItem = btnSubmit;
    [_text resignFirstResponder];

    if(Success)
    {
        if(  switchy.on)
        {
            WeiBoHelper *application = [WeiBoHelper sharedInstance];
            if([application isWeiBoLogon])
                [self sendToWeibo];
            else
            {
                application.delegate = self;
                application.changeUser = NO;
                [application weiboLogin];
            }
        }
        else
        {
            [_text setText:@""];
            [self dismissModalViewControllerAnimated:YES];
            [self.delegate didAfterComment];
        }
    }
    else
    {
        NSString *msg = @"发布失败、请稍后再试！";
        if([feed objectForKey:@"Messages"])
            msg = [NSString stringWithFormat:@"%@",[feed objectForKey:@"Messages"]];
        [UserHelper doAlert:self title:@"发布提示" message:msg];
    }
}

-(void)requestDidStartLoad:(TTURLRequest *)request
{
    button.enabled = NO;
    btnSubmit.enabled = NO;
    //self.navigationItem.rightBarButtonItem = tt;
    [self.view addSubview:postloading];
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    [postloading removeFromSuperview];
    button.enabled = YES;
    btnSubmit.enabled = YES;
    self.navigationItem.rightBarButtonItem = btnSubmit;
    [UserHelper doAlert:self title:@"发布提示" message:@"发布失败、请检查网络链接状态！"];
}

- (void)request:(WBRequest *)request didLoad:(id)result{
     WeiBoHelper *application = [WeiBoHelper sharedInstance];
    [application dismissWeiboSendView];
    
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate didAfterComment];
}

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
	NSInteger count  = kCommentMaxTextCount - wordcount;
	if (count < 0) {
		_wordCountLabel.textColor = [UIColor redColor];
	}
	else {
		_wordCountLabel.textColor = [UIColor grayColor];
	}
	
	_wordCountLabel.text = [NSString stringWithFormat:@"%i",count];
}

//- (void)textEditorDidBeginEditing:(TTTextEditor*)textEditor
//{
//    //[self onbegincomment:self];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(doComplet)];
//}

//- (void)textEditorDidEndEditing:(TTTextEditor*)textEditor
//{
//    
//}

- (void)textViewDidChange:(UITextView *)textView
{
       [self textLengthCount];
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//   
//}
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//   [self donotcomment:self];
//}
//
//- (void)textViewDidChange:(UITextView *)textView
//{
// 
//}

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

-(void)dealloc
{
    
//     TT_RELEASE_SAFELY(_text);
//     TT_RELEASE_SAFELY(_wordCountLabel);
//     TT_RELEASE_SAFELY(_me);
//     TT_RELEASE_SAFELY(_messageid);
//     TT_RELEASE_SAFELY(_userid);
//     TT_RELEASE_SAFELY(switchy);
//    //TT_RELEASE_SAFELY(button);
//    TT_RELEASE_SAFELY(btnSubmit);
//    TT_RELEASE_SAFELY(postloading);
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

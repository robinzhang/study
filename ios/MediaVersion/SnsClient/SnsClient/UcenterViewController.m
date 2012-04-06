//
//  UcenterViewController.m
//  SnsClient
//
//  Created by  on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UcenterViewController.h"
#import "UserHelper.h"
#import "UcenterViewDataSource.h"

@implementation UcenterViewController
@synthesize profie = _profile;
@synthesize me = _me;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"个人档";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_home.png"] tag:4];
        
        self.tableViewStyle = UITableViewStyleGrouped;
        self.tableView.sectionFooterHeight = 5;
        self.tableView.sectionHeaderHeight = 5;
        self.variableHeightRows = YES;
       
        //self.showTableShadows = YES;
        
        self.me = [UserHelper GetUserID];
        
        TTActivityLabel *loadingview = [[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 35, 30) style:TTActivityLabelStyleWhite text:@" " ];
        ttloading = [[UIBarButtonItem alloc] initWithCustomView:loadingview];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(SnNotificationDataKeySucc) 
                                                     name:@"SnNotificationDataKeySucc" 
                                                   object:nil];
        
        _profile = [UserHelper GetUserProfile:[UserHelper GetUserID]];
        if(!_profile)
            _profile = [[UserProfile alloc] init];
        _profile.UserID = [UserHelper GetUserID];
        userinfoView = [self initUinfo:_profile];
        self.tableView.tableHeaderView = userinfoView;
        [userinfoView release];

    }
    return self;
}

////////////   UpdateBadgeInfo //////////// 
-(void)UpdateBadgeInfo
{
    SnUserAppInfo *info = [UserHelper GetUserAppInfo];
    if(_commentCountBadge)
    {
        if(info.CommentCount > 0 )
        {
            [_commentCountBadge setFrame:CGRectMake(225, 165, 30, 30)];
            _commentCountBadge.text= @"新回复";
            //_commentCountBadge.text= [NSString stringWithFormat:@"%d",info.CommentCount];
            [_commentCountBadge sizeToFit];
        }
        else
        {
            _commentCountBadge.text = @"";
            [_commentCountBadge setFrame:CGRectZero];
        }
    }
    
    
    if(_messageCountBadge)
    {
        if(info.PrivteMessageCount > 0 )
        {
            [_messageCountBadge setFrame:CGRectMake(225, 300, 30, 30)];
            _messageCountBadge.text= [NSString stringWithFormat:@"%d",info.PrivteMessageCount];
            [_messageCountBadge sizeToFit];
        }
        else
        {
            _messageCountBadge.text = @"";
            [_messageCountBadge setFrame:CGRectZero];
        }
    }
    
    int cCount = info.CommentCount + info.PrivteMessageCount;
    if(cCount > 0)
    {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",cCount];
    }
    else
    {
        self.tabBarItem.badgeValue = nil;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = cCount;
}

//////////////  SnNotificationDataKeySucc /////////// 
-(void)SnNotificationDataKeySucc
{
    [self UpdateBadgeInfo];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}



-(void)viewWillAppear:(BOOL)animated
{
    self.me = [UserHelper GetUserID];
    [super viewWillAppear:animated];
    
    TTButton *btn = [TTButton buttonWithStyle:@"blueImgToolbarButton:" title:nil]; 
    [btn setImage:@"bundle://btn_icon_refresh_wt.png" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doRefresh) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 36, 34)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn]; 
    [self UpdateBadgeInfo];
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}

-(UIView*)initUinfo:(UserProfile*)profile
{
    CGRect frame = self.view.bounds;
//    UIColor* black = RGBCOLOR(150, 150, 150);
    
//    TTShapeStyle *style = [TTShapeStyle styleWithShape:[TTRectangleShape shape] next:
//       [TTSolidFillStyle styleWithColor:[UIColor clearColor] next:
//       [TTFourBorderStyle styleWithTop:nil right:nil bottom:black left:nil width:1 next:nil]]];
    
    /////////userinfo//////
    TTView *userinfo = [[TTView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    //userinfo.style = style;
    
    TTImageView * userface = [[TTImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    userface.urlPath = [NSString stringWithFormat:@"%@_80_80.jpg", profile.UserFace];
    userface.defaultImage = TTIMAGE(@"bundle://icon_default_80_80.png");
    [userinfo addSubview:userface];
    [userface release];
    
    if(profile.UserType == 16)
    {
        UIImageView *_usertype = [[UIImageView alloc] initWithFrame:CGRectMake(10+80-14, 10+80-14, 14, 14)];
        [_usertype setImage:TTIMAGE(@"bundle://icon-m.png")];
        [userinfo addSubview:_usertype];
        [_usertype release];
    }
    
    UIButton *btnUserFace=[UIButton buttonWithType:UIButtonTypeCustom];
    btnUserFace.frame=userface.frame;
    [btnUserFace addTarget:self action:@selector(gotoEditProfile:) forControlEvents:UIControlEventTouchUpInside];
    [userinfo addSubview:btnUserFace];
    
    UILabel * username = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, frame.size.width - 110, 22)];
    [username setFont:[UIFont boldSystemFontOfSize:16]];
    [username setBackgroundColor:[UIColor clearColor]];
    username.shadowColor = [UIColor whiteColor];
    username.shadowOffset = CGSizeMake(0,1);
    [username setText:profile.UserName]; 
    [userinfo addSubview:username];
    [username release];
    
    UILabel* userintro = [[UILabel alloc] initWithFrame:CGRectMake(100, 38, frame.size.width - 110, 50)];
    [userintro setFont:[UIFont boldSystemFontOfSize:14]];
    [userintro setBackgroundColor:[UIColor clearColor]];
    userintro.shadowColor = [UIColor whiteColor];
    userintro.shadowOffset = CGSizeMake(0,1);
    userintro.numberOfLines = 3;
    userintro.lineBreakMode = UILineBreakModeClip;
    [userintro setText:profile.Intro];
    [userinfo addSubview:userintro];
    [userintro release];
    
//    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnEdit setFrame:CGRectMake(frame.size.width - 40, 10, 30, 30)];
//    [btnEdit setBackgroundImage:TTIMAGE(@"bundle://tab_setting.png") forState:UIControlStateNormal];
//    TTButton *btnEdit = [TTButton buttonWithStyle:@"embossedButton:" title:NSLocalizedString(@"Edit", @"Edit")];
//    [btnEdit addTarget:self action:@selector(gotoEditProfile:) forControlEvents:UIControlEventTouchUpInside];
//    [userinfo addSubview:btnEdit];
    
    [userinfo setBackgroundColor:[UIColor clearColor]];
    return  userinfo;
}

-(void)gotoEditProfile:(id)sender
{
    if(editProfileViewController)
    {
        [editProfileViewController release];
        editProfileViewController = nil;
    }
    //if(!editProfileViewController)
    //{
        editProfileViewController  = [[EditProfileViewController alloc] initWidthProfile:_profile];
        editProfileViewController.delegate = self;
    //}
    editProfileViewController.profile = _profile;
    [self.navigationController pushViewController:editProfileViewController animated:YES];
    
//    TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:editProfileViewController] autorelease];
//    [self.navigationController presentModalViewController:nav animated:YES];
}

//-(void)didSelectUserFace
//{
//     NSString *imgPath = [NSString stringWithFormat:@"%@_320_320.jpg",_profile.UserFace];
//    DetailImageViewController *view = [[DetailImageViewController alloc]  initWithTitle:@"" imgpath:imgPath];
//    TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:view] autorelease];
//    [self.navigationController presentModalViewController:nav animated:YES];
//    [view release];
//}

-(void)doRefresh
{
    if(self.model)
    {
        UcenterViewModel *mm = (UcenterViewModel*)self.model;
        [mm clearCache:[UserHelper GetUserID]];
        [self.model load:TTURLRequestCachePolicyDefault more:NO];
    }
    else
       [self createModel];
}

-(void)createModel
{
    NSString *userid = [UserHelper GetUserID];
    self.dataSource = [[UcenterViewDataSource alloc] initWithUserId:userid];
    
    UIView *fview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom ];
    [button setBackgroundImage:TTIMAGE(@"bundle://btn_bg_tc.png") forState:UIControlStateNormal];
    [button setFrame:CGRectMake(98, 5,125, 45)];
    
    [button addTarget:self action:@selector(willLogout:) forControlEvents:UIControlEventTouchUpInside];
    [fview addSubview:button];
    [self.tableView setTableFooterView:fview];
    [fview release];
    
    _commentCountBadge = [[TTLabel alloc] init];
    _commentCountBadge.style = TTSTYLE(badge);
    _commentCountBadge.backgroundColor = [UIColor clearColor];
    _commentCountBadge.userInteractionEnabled = NO;
    [_commentCountBadge setFrame:CGRectZero];
    [self.tableView addSubview:_commentCountBadge];
    
    _messageCountBadge = [[TTLabel alloc] init];
    _messageCountBadge.style = TTSTYLE(badge);
    _messageCountBadge.backgroundColor = [UIColor clearColor];
    _messageCountBadge.userInteractionEnabled = NO;
    [_messageCountBadge setFrame:CGRectZero];
    [self.tableView addSubview:_messageCountBadge];
}

-(void)modelDidStartLoad:(id<TTModel>)model
{
     self.navigationItem.rightBarButtonItem = ttloading;
}

-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
{
    self.navigationItem.rightBarButtonItem = nil;
    [self showLoading:NO];
    if( [UserHelper GetUserProfile:self.me])
    {
        _profile = [UserHelper GetUserProfile:self.me];
        if(!_profile)
            _profile = [[UserProfile alloc] init];
        
        UcenterViewDataSource *datasource = (UcenterViewDataSource*)self.dataSource;
        [datasource SetItemsByProfile:_profile];
        
        [userinfoView removeFromSuperview];
        userinfoView = [self initUinfo:_profile];
        self.tableView.tableHeaderView = userinfoView;
    }
}

-(void)modelDidFinishLoad:(id<TTModel>)model
{
    [super modelDidFinishLoad:model];
    
    UcenterViewModel *mm = (UcenterViewModel*)model;
    [userinfoView removeFromSuperview];
    _profile = mm.profie;
    userinfoView = [self initUinfo:mm.profie];
    self.tableView.tableHeaderView = userinfoView;
    
    TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"编辑" ]; 
    [rbtn2 sizeToFit];
    [rbtn2 addTarget:self action:@selector(gotoEditProfile:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:rbtn2];
    
    [self UpdateBadgeInfo];
}


-(void)setErrorView:(UIView *)errorView
{
    if(errorView)
    {
        if(!errorinfoview)
        {
            errorinfoview = [[SnInfoView alloc] initWithFrame:CGRectMake(80, 135, 160,80) msg:@"出错了，请检查您的网络环境！"];
        }
        if(![errorinfoview superview])
            [self.view addSubview:errorinfoview];
        
        [self performSelector:@selector(removeErrorView) withObject:nil afterDelay:3.0];
    }
    else
    {
        if(errorinfoview && [errorinfoview superview])
            [errorinfoview removeFromSuperview];
    }
}

-(void)removeErrorView
{
    if(errorinfoview && [errorinfoview superview])
        [errorinfoview removeFromSuperview];
}


#pragma mark - logout

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)doAlert:(id)sender  title:(NSString*)title message:(NSString*)message{
	UIAlertView *alertDialog;
    
    alertDialog = [[UIAlertView alloc] 
                   initWithTitle: title 
                   message:message
                   delegate:self
                   cancelButtonTitle: NSLocalizedString(@"Cancel", @"取消")
                   otherButtonTitles: NSLocalizedString(@"Done", @"确定"),nil];
    
    [alertDialog show];
	[alertDialog release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)willLogout:(id)sender
{
    [self doAlert:self title:@"退出" message:NSLocalizedString(@"You Will Logout and Can't Receive Any Message From Your Friends", @"确定要退出登陆?")];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    }
    else
    {
        NSString *uid = [UserHelper GetUserID];

        [UserHelper SetUserLogout];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogoutSuccess" object:uid];
    }
}

#pragma mark - SnEditProfileDelegate
- (void)didAfterEditProfile
{
    [self.navigationController bringControllerToFront:self animated:YES];
    [self doRefresh];
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

-(void)dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SnNotificationDataKeySucc"  object:nil];
    [super dealloc];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

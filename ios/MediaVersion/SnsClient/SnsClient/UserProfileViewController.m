//
//  UserProfileViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserProfileViewController.h"

@implementation UserProfileViewController
@synthesize queryUserid = _queryUserid;
@synthesize me = _me;

-(id)initWidthUserId:(NSString*)queryUserid
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.queryUserid = queryUserid;
        self.me = [UserHelper GetUserID];
        self.tableViewStyle = UITableViewStyleGrouped;
        self.variableHeightRows = YES;
        self.title = @"Ta的资料";
        self.hidesBottomBarWhenPushed = NO;
        _profile= [[UserProfile alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.me = [UserHelper GetUserID];
    [super viewWillAppear:animated];
    
    TTButton *rbtn = [TTButton buttonWithStyle:@"blueImgToolbarButton:" title:nil]; 
    [rbtn setImage:@"bundle://icon_home.png" forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    [rbtn setFrame:CGRectMake(0, 0, 36, 34)];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rbtn]; 
    //icon_home
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}

-(void)goHome
{
    MainViewController *main = [[MainViewController alloc] initWithNibName:nil bundle:nil]; 
    [self.navigationController presentModalViewController:main animated:NO];
    [main release];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // CGRect frame = self.view.bounds;
    //self.tableView.frame = CGRectMake(0, 60, frame.size.width, frame.size.height - 60);
    

    UserProfile *profile = [[UserProfile alloc] init];
    userinfoView = [self initUinfoView:profile];
    [profile release];
    self.tableView.tableHeaderView = userinfoView;
}

-(void)createModel
{
    self.dataSource = [[UserProfileDataSource alloc] initWithUserId:_queryUserid];
}

-(void)modelDidFinishLoad:(id<TTModel>)model
{
    [super modelDidFinishLoad:model];
    
    UcenterViewModel *mm = (UcenterViewModel*)model;
    [userinfoView removeFromSuperview];
    userinfoView = [self initUinfoView:mm.profie];
    //[self.view addSubview:userinfoView];
    _profile = mm.profie;
    self.tableView.tableHeaderView = userinfoView;
}

-(UIView*)initUinfoView:(UserProfile*)profile
{
    CGRect frame = self.view.bounds;
   // UIColor* black = RGBCOLOR(150, 150, 150);
    
   // TTShapeStyle *style = [TTShapeStyle styleWithShape:[TTRectangleShape shape] next:
   //                        [TTSolidFillStyle styleWithColor:[UIColor clearColor] next:
   //                         [TTFourBorderStyle styleWithTop:nil right:nil bottom:black left:nil width:1 next:nil]]];
    
    /////////userinfo//////
    TTView *userinfo = [[TTView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
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
    [btnUserFace addTarget:self action:@selector(didSelectUserFace) forControlEvents:UIControlEventTouchUpInside];
    [userinfo addSubview:btnUserFace];
    
    UILabel * username = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, frame.size.width - 110, 22)];
    [username setFont:[UIFont boldSystemFontOfSize:16]];
    username.shadowColor = [UIColor whiteColor];
    username.shadowOffset = CGSizeMake(0,1);
    [username setBackgroundColor:[UIColor clearColor]];
    [username setText:profile.UserName]; 
    [userinfo addSubview:username];
    [username release];
    
//    UILabel* userintro = [[UILabel alloc] initWithFrame:CGRectMake(100, 38, frame.size.width - 110, 50)];
//    [userintro setFont:[UIFont boldSystemFontOfSize:14]];
//    [userintro setBackgroundColor:[UIColor clearColor]];
//    userintro.shadowColor = [UIColor whiteColor];
//    userintro.shadowOffset = CGSizeMake(0,1);
//    userintro.numberOfLines = 3;
//    userintro.lineBreakMode = UILineBreakModeClip;
//    [userintro setText:profile.Intro];
//    [userinfo addSubview:userintro];
//    [userintro release];
    
    //[UserHelper isLogon] && 
    if(![self.me isEqualToString:self.queryUserid] )
    {
        userRelationButton = [[UserRelationButton alloc]  initWithUserid:self.me aotherUserId:self.queryUserid];

        [userRelationButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [userRelationButton setFrame:CGRectMake(320 - 78, 10, 68, 25)];
        [userinfo addSubview:userRelationButton];
        [userRelationButton checkStatus];
    }
    [userinfo setBackgroundColor:[UIColor clearColor]];
    return  userinfo;
}

-(void)didSelectUserFace
{
    NSString *imgPath = [NSString stringWithFormat:@"%@_320_320.jpg",_profile.UserFace];
    DetailImageViewController *view = [[DetailImageViewController alloc]  initWithTitle:@"" imgpath:imgPath];
    TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:view] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
    [view release];
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
//    TT_RELEASE_SAFELY(_queryUserid);
//    TT_RELEASE_CF_SAFELY(_profile);
//    TT_RELEASE_CF_SAFELY(_me);
//    TT_RELEASE_CF_SAFELY(userinfoView);
//    TT_RELEASE_SAFELY(userRelationButton);
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

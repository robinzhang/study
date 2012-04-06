//
//  MessageDetailController.m
//  SnsClient
//
//  Created by  on 11-10-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MessageDetailController.h"
#import "MessageVisterController.h"

#define kToolBarHeight 44
@implementation MessageDetailController
@synthesize  messageid = _messageid;
@synthesize userid = _userid;
@synthesize message = _message;
@synthesize from= _from;

//-(id)initWidthMessageid:(NSString*)userid messageid:(NSString*)messageid
//{
//    self = [super initWithNibName:nil bundle:nil];
//    if (self) {
//        self.hidesBottomBarWhenPushed = YES;
//        self.title = NSLocalizedString(@"DetailView",@"纸条详情");
//        [self.view setBackgroundColor:RGBCOLOR(235, 235, 235)];
//        self.message = [[NewsDetailObject alloc] init];
//        self.messageid = messageid;
//        self.userid = userid;
//        self.variableHeightRows = YES;
//    }
//    return self;
//}

-(void)initViewMessage
{
    self.message.MessageID = self.messageid;
    self.message.UserID = self.userid;
    CLLocation *nowlo = [UserHelper GetUserLocation];
    self.message.Latitude = nowlo.coordinate.latitude;
    self.message.Longitude = nowlo.coordinate.longitude;
    [self initMainInfo:self.message];
    [self RequestMainInfo];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _toolBar = [self initToobar];
    [self.view addSubview:_toolBar];
}


-(id)initWidthMessageid:(NSString*)messageid query:(NSDictionary*)query
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.title = @"新闻资讯内容";
        self.messageid = messageid;
        self.userid = [query objectForKey:@"userid"];
        self.from = [query objectForKey:@"from"];
        self.message = [[NewsDetailObject alloc] init];
        self.variableHeightRows = YES;
        self.hidesBottomBarWhenPushed = YES;
        if([query objectForKey:@"username"])
            self.message.UserName =[query objectForKey:@"username"];
        if([query objectForKey:@"userface"])
            self.message.UserFace =[query objectForKey:@"userface"];
        [self initViewMessage];
    }
    return  self;
}

-(id)initWidthMessage:(SnMessage*)message
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.messageid = message.MessageID;
        self.userid = message.UserID;
        self.message = [[NewsDetailObject alloc] init];
        self.message.UserName = message.UserName;
        self.message.MessageBody = message.MessageBody;
        self.message.UserFace = message.UserFace;
        self.title = @"新闻资讯内容";
        self.hidesBottomBarWhenPushed = YES;
        self.variableHeightRows = YES;
        [self initViewMessage];
    }
    return  self;
}




-(void)viewWillAppear:(BOOL)animated
{    
    
    //self.navigationController.toolbarHidden=NO;
    [super viewWillAppear:animated];
    
    if(TTIsStringWithAnyText(self.from) && [self.from isEqualToString:@"app"])
    { 
        self.navigationItem.hidesBackButton = YES;
            TTButton *leftBarButton = [TTButton buttonWithStyle:@"blueColorBackButton:" title:@"返回"];
            [leftBarButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
            [leftBarButton setFrame:CGRectMake(0, 0, 60, 30)];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    }

    
    
    TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"举报"]; 
    [rbtn2 addTarget:self action:@selector(showReport) forControlEvents:UIControlEventTouchUpInside];
    [rbtn2 sizeToFit];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:rbtn2];
    

    
    CGRect frame = self.view.bounds;    
    [_toolBar setFrame:CGRectMake(0, frame.size.height - kToolBarHeight, 320 , kToolBarHeight)];
    [self.tableView setFrame:CGRectMake(0, KPageTitleHeight, frame.size.width,  frame.size.height - kToolBarHeight - KPageTitleHeight)];
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}


-(void)createModel
{
    self.dataSource = [[DeatilCommentDataSource alloc] initWithSearchQuery:self.messageid userid:self.userid];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (id<UITableViewDelegate>)createDelegate {
//    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(UIButton*)buildIconButton:(NSString*)title icon:(NSString*)icon
{
    NSString *imagePath = [NSString stringWithFormat:@"bundle://%@",icon];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom]; 
    [btn setBackgroundColor:[UIColor clearColor]];
    
    //[btn setBackgroundImage:TTIMAGE(imagePath) forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    //[btn setTitle:title forState:UIControlStateNormal];
    
    //UIView *innerView = [[UIView alloc] init];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 26, 26)];
    [imgv setImage:TTIMAGE(imagePath)];
    [btn addSubview:imgv];
    [imgv release];
    
    UILabel *lble = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, 60, 14)];
    [lble setText:title];
    [lble setFont:[UIFont systemFontOfSize:12]];
    [lble setBackgroundColor:[UIColor clearColor]];
    [lble setTextAlignment:UITextAlignmentCenter];
    [lble setTextColor:[UIColor whiteColor]];
    [btn addSubview:lble];
    [lble release];
    
    //[btn setTitle:title forState:UIControlStateNormal];
    //[btn sizeToFit];
    //int w = btn.frame.size.width;
    //[btn setFrame:CGRectMake(0, 0, w, 0)];
    return btn;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//-(NewsFavoriteButton*)buildFavIconButton:(NSString*)title icon:(NSString*)icon
//{
//    favoriteButton = [[NewsFavoriteButton alloc] initWithStyle:@"blueIconToolbarButton:" userid:[UserHelper GetUserID] muserid:self.userid messageid:self.messageid]; 
//    
//    //UIView *innerView = [[UIView alloc] init];
//    
//    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 26, 26)];
//    NSString *imagePath = [NSString stringWithFormat:@"bundle://%@",icon];
//    [imgv setImage:TTIMAGE(imagePath)];
//    [favoriteButton addSubview:imgv];
//    [imgv release];
//    
//    [favoriteButton setTitle:title forState:UIControlStateNormal];
//    [favoriteButton sizeToFit];
//    //int w = btn.frame.size.width;
//    [favoriteButton setFrame:CGRectMake(0, 0, 80, 30)];
//    [favoriteButton checkStatus];
//    return favoriteButton;
//}

-(UIToolbar*)initToobar
{
    //self.navigationController.toolbarHidden=NO;
    CGRect frame = self.view.bounds;    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.tintColor = TTSTYLEVAR(navigationBarTintColor);
    
    [toolbar setFrame:CGRectMake(0, frame.size.height - kToolBarHeight, 320 , kToolBarHeight)];
    [self.tableView setFrame:CGRectMake(0, KPageTitleHeight, frame.size.width,  frame.size.height - KPageTitleHeight- kToolBarHeight)];
    
    [self.navigationController.toolbar setTintColor:TTSTYLEVAR(toolbarTintColor)];
    
    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc]                                              
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace                              
                                                target:nil action:nil];

    UIButton *btn1 = [self buildIconButton:@"评论" icon:@"tab_review.png"];
    [btn1 addTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    UIButton *btn2 = [self buildIconButton:@"我去" icon:@"tab_near.png"];
    [btn2 addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    
    NewsFavoriteButton *btn3 =[[NewsFavoriteButton alloc] initWithUserid:[UserHelper GetUserID] muserid:self.message.UserID messageid:self.message.MessageID];
    [btn3 checkStatus];
    
    UIBarButtonItem * barToAddFavorite = [[UIBarButtonItem alloc] initWithCustomView:btn3];
    
    UIButton *btn4 = [self buildIconButton:@"分享" icon:@"more_shares.png"];
    [btn4 addTarget:self action:@selector(showShare) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem4 = [[UIBarButtonItem alloc] initWithCustomView:btn4];
     
    // Set our toolbar items
    toolbar.items = [NSArray arrayWithObjects:
                         flexibleSpaceButtonItem,
                          barToAddFavorite,
                          barButtonItem1,
                          barButtonItem2,
                          barButtonItem4,
                         flexibleSpaceButtonItem,
                         nil];
    
    [flexibleSpaceButtonItem release];
    [barButtonItem1 release];
    [barButtonItem2 release];
    [barButtonItem4 release];
    [barToAddFavorite release];
    return  toolbar;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1)
    {
        if(buttonIndex == 0)
        {
            MessageCorrectionLoading *loading  = [[MessageCorrectionLoading  alloc] initWithFrame:CGRectMake(100, 100, 120, 35) style:TTActivityLabelStyleBlackBezel text:@"正在提交..."];
            [self.view addSubview:loading];
            [loading Post:self.userid muserid:self.message.UserID messageid:self.message.MessageID content:@"不良信息、图片"];
            [loading release];
        }
        else if(buttonIndex == 1)
        {         
            MessageCorrectionLoading *loading  = [[MessageCorrectionLoading  alloc] initWithFrame:CGRectMake(100, 100, 120, 35) style:TTActivityLabelStyleBlackBezel text:@"正在提交..."];
            [self.view addSubview:loading];
            [loading Post:self.userid muserid:self.message.UserID messageid:self.message.MessageID content:@"垃圾信息、广告"];
            [loading release];
        }
        else if(buttonIndex == 2)
        {
            MessageCorrectionLoading *loading  = [[MessageCorrectionLoading  alloc] initWithFrame:CGRectMake(100, 100, 120, 35) style:TTActivityLabelStyleBlackBezel text:@"正在提交..."];
            [self.view addSubview:loading];
            [loading Post:self.userid muserid:self.message.UserID messageid:self.message.MessageID content:@"恶意诋毁、谩骂"];
            [loading release];
        }
    }
    else if (actionSheet.tag == 2)
    {
        if(buttonIndex == 0)
        {
           WeiBoHelper *application = [WeiBoHelper sharedInstance];
            if([application isWeiBoLogon])
                [self sendToWeibo];
            else
            {
                application.changeUser = NO;
                application.delegate = self;
                [application weiboLogin];
            }
        }
        else if(buttonIndex == 1)
        {
            if ([MFMailComposeViewController canSendMail]) 
            {
                MFMailComposeViewController *mail=[[MFMailComposeViewController alloc] init];
                mail.mailComposeDelegate=self;
                

                NSString *body = [NSString stringWithFormat:@"我用#新闻两公里#发现了一条新闻资讯与你分享，内容如下：\n 正文：%@",self.message.NewsText];
                if(TTIsStringWithAnyText(self.message.Address))
                {
                    body = [NSString stringWithFormat:@"我用#新闻两公里#发现了一条新闻资讯与你分享，它发生的地点在:%@， 内容如下：\n 正文：%@",self.message.Address,self.message.NewsText];
                }
                
                NSString *mtitle = [NSString stringWithFormat:@"分享新闻：%@",self.message.MessageBody];
                [mail setSubject:mtitle];
                [mail setMessageBody:body isHTML:NO];
            
                [self presentModalViewController:mail animated:YES];
            }
        }
    }
}

-(void)sendToWeibo
{
    NSString *msg = [NSString stringWithFormat:@"我用#新闻两公里#发现了一条新闻资讯与你分享，标题是:%@，请及时围观。",self.message.MessageBody];
    
    if(TTIsStringWithAnyText(self.message.Address))
    {
        msg = [NSString stringWithFormat:@"我用#新闻两公里#发现了一条新闻资讯与你分享，标题是:%@，它发生的地点在:%@，如果你刚好在那里，请及时围观。",self.message.MessageBody,self.message.Address];
    }
    
   WeiBoHelper *application = [WeiBoHelper sharedInstance];
    if([application isWeiBoLogon])
    {
        application.delegate = nil;
        [application sendWeibo:msg image:nil andDelegate:self];
        
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

- (void)request:(WBRequest *)request didLoad:(id)result{
    WeiBoHelper *application = [WeiBoHelper sharedInstance];
    [application dismissWeiboSendView];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogonSuccess" object:[UserHelper GetUserID]];
}
#pragma mark - MFMailComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    //if (result==MessageComposeResultCancelled) {
    [self dismissModalViewController];
    //}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    //if (result==MFMailComposeResultCancelled) {
    [self dismissModalViewController];
    //}
}

#pragma mark - showComment
-(void)showComment
{
    DetailCommentViewController *commentView = [[DetailCommentViewController alloc] initWithMessage:self.messageid userid:self.userid];
    commentView.delegate = self;
    TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:commentView] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
    [commentView release];
}

- (void)didAfterComment
{
    NewsCommentModel *mm = (NewsCommentModel*)self.model;
    [mm clearCache:self.messageid userid:self.userid];
    [mm load:TTURLRequestCachePolicyDefault more:NO];
}
#pragma mark - showMap
-(void)showMap
{
    
	UIAlertView *alertDialog;
    
    alertDialog = [[UIAlertView alloc] 
                   initWithTitle:@"查看地图信息" 
                   message:@"点击确定通过GoogleMap浏览地图及路线信息，同时看过将切换到后台"
                   delegate: self 
                   cancelButtonTitle: NSLocalizedString(@"Cancel", @"取消")
                   otherButtonTitles: NSLocalizedString(@"Done", @"确定"),nil];
    
    [alertDialog show];
	[alertDialog release];


//    DetailMapViewController *view = [[DetailMapViewController alloc] init];
//    view.location =[[CLLocation alloc] initWithLatitude:_message.Latitude longitude:_message.Longitude];
//    TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:view] autorelease];
//    [self.navigationController presentModalViewController:nav animated:YES];
//    [view release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        CLLocation *mel  = [UserHelper GetUserLocation];
        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f",_message.Latitude,_message.Longitude,mel.coordinate.latitude,mel.coordinate.longitude] ;
        TTOpenURL(url);
    }
}
#pragma mark - showReport

-(void)showReport
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"举报"
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")  
                                             destructiveButtonTitle:nil 
                                                  otherButtonTitles:@"不良信息、图片", @"垃圾信息、广告",@"恶意诋毁、谩骂",nil];
    actionSheet.tag = 1;
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actionSheet showFromToolbar:self.navigationController.toolbar];
    [actionSheet release];
}

#pragma mark - showShare

-(void)showShare
{
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"分享"
                                                  delegate:self 
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")  
                                    destructiveButtonTitle:nil 
                                         otherButtonTitles:@"新浪微博", @"电子邮件",nil];
    
    actionSheet.tag = 2;
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actionSheet showFromToolbar:self.navigationController.toolbar];
    [actionSheet release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

#pragma mark - MainInfo

-(void)goUserProfile
{
    
    //UserProfileViewController *view = [[UserProfileViewController  alloc] initWidthUserId:self.message.UserID];
    //[self.navigationController pushViewController:view animated:YES];
    //[view release];
    
    //self.hidesBottomBarWhenPushed = NO;
    NSString *url =  [NSString stringWithFormat:@"tt://uprofile/%@",self.message.UserID];
    TTOpenURL(url);
}

-(UIView*)initUserInfo:(NewsDetailObject*)message frame:(CGRect)frame
{
    /////////userinfo//////
    UIView *userinfo = [[UIView alloc] initWithFrame:frame];
    
    TTImageView *userface = [[TTImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    userface.urlPath = [NSString stringWithFormat:@"%@_80_80.jpg", message.UserFace]; 
    userface.defaultImage = TTIMAGE(@"bundle://icon_default.png");
    [userinfo addSubview:userface];
    
    UIButton *btnUserFace=[UIButton buttonWithType:UIButtonTypeCustom];
    btnUserFace.frame=userface.frame;
   
    [btnUserFace addTarget:self action:@selector(goUserProfile) forControlEvents:UIControlEventTouchUpInside];
    [userinfo addSubview:btnUserFace];
    [userface release];
    
    if(message.UserType == 16)
    {
        UIImageView *usertype = [[UIImageView alloc] initWithFrame:CGRectMake(70-14, 70-14, 14, 14)];
        [usertype setImage:TTIMAGE(@"bundle://icon-m.png")];
        [userinfo addSubview:usertype];
        [usertype release];
    }
    
    UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, frame.size.width - 70, 25)];
    [username setFont:[UIFont systemFontOfSize:16]];
    [username setBackgroundColor:[UIColor clearColor]];
    username.shadowColor = [UIColor whiteColor];
    username.shadowOffset = CGSizeMake(0, 1.0);
    [username setTextColor:TTSTYLEVAR(textColor)];
    [username setText:message.UserName]; 
    [userinfo addSubview:username];
    [username release];
    
    UILabel *sendtime = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, frame.size.width - 70, 20)];
    CLLocation* another = [[CLLocation alloc] initWithLatitude:message.Latitude longitude:message.Longitude];
    NSString *distanceStr = [UserHelper getDistance:[UserHelper GetUserLocation] another:another];
    NSString *timeStr = @"";
    if(message.PublicDate)
       timeStr = [message.PublicDate formatRelativeTime];
    NSString *text = [NSString stringWithFormat:@"%@  距离:%@",timeStr,distanceStr];
    [sendtime setText:text];
    [sendtime setBackgroundColor:[UIColor clearColor]];
    [sendtime setTextColor:[UIColor grayColor]];
    [sendtime setFont:[UIFont systemFontOfSize:14]];
    sendtime.shadowColor = [UIColor whiteColor];
    sendtime.shadowOffset = CGSizeMake(0, 1.0);
    [sendtime setTextColor:TTSTYLEVAR(textColor)];
    [userinfo addSubview:sendtime];
    [sendtime release];
    //sendtime 
    
    
    UILabel *lCloneCount = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, 80, 25)];
    [lCloneCount setFont:[UIFont systemFontOfSize:13]];
    [lCloneCount setBackgroundColor:[UIColor clearColor]];
    [lCloneCount setText:[NSString stringWithFormat:@"%d",self.message.CloneCount]];
    lCloneCount.shadowColor = [UIColor whiteColor];
    lCloneCount.shadowOffset = CGSizeMake(0, 1.0);
    [lCloneCount setTextColor:TTSTYLEVAR(textColor)];
    [userinfo addSubview:lCloneCount];
    [lCloneCount release];
    
    lCommentCount = [[UILabel alloc] initWithFrame:CGRectMake(185, 50, 80, 25)];
    [lCommentCount setFont:[UIFont systemFontOfSize:13]];
    [lCommentCount setBackgroundColor:[UIColor clearColor]];
    [lCommentCount setText:[NSString stringWithFormat:@"%d",self.message.CommentCount]];
    lCommentCount.shadowColor = [UIColor whiteColor];
    lCommentCount.shadowOffset = CGSizeMake(0, 1.0);
    [lCommentCount setTextColor:TTSTYLEVAR(textColor)];
    [userinfo addSubview:lCommentCount];
    [lCommentCount release];
    
    UIImageView *ico2202 = [[UIImageView alloc] initWithFrame:CGRectMake(80, 55, 18, 18)];
    [ico2202 setImage:TTIMAGE(@"bundle://ico2202.png")];
    [userinfo addSubview:ico2202];
    [ico2202 release];
    
    
    UIImageView *ico2201 = [[UIImageView alloc] initWithFrame:CGRectMake(160, 55 , 18, 18)];
    [ico2201 setImage:TTIMAGE(@"bundle://ico2201.png")];
    [userinfo addSubview:ico2201];
    [ico2201 release];
    
    UIButton *bico2202 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bico2202  setFrame:CGRectMake(80, 55, 70, 30)];
    [bico2202 addTarget:self action:@selector(showViewList) forControlEvents:UIControlEventTouchUpInside];
    [userinfo addSubview:bico2202];

    
    UIButton *bico2201 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bico2201  setFrame:CGRectMake(160, 55, 70, 30)];
    [bico2201 addTarget:self action:@selector(showCommentList) forControlEvents:UIControlEventTouchUpInside];
    [userinfo addSubview:bico2201];
    
    
//    UIButton *btnview = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnview setFrame:CGRectMake(10, userinfo.height + 8, 80, 28)];
//    [btnview setTitle:[NSString stringWithFormat:@"看过 %d 次",self.message.CloneCount] forState:UIControlStateNormal];
//    [btnview setBackgroundColor:[UIColor clearColor]];
//    [btnview sizeToFit];
//    [btnview setFrame:CGRectMake(10, detailView.height + 8, btnview.size.width + 10, 28)];
//    [userinfo addSubview:btnview];
    
    
    [userinfo setBackgroundColor:[UIColor clearColor]];
    return userinfo;
}

-(void)showViewList
{
    MessageVisterController *view = [[MessageVisterController alloc] initWidthMessage:self.message];
    [self.navigationController pushViewController:view animated:YES];
    [view release];
}

-(void)showCommentList
{
    NewsCommentModel *mm = (NewsCommentModel*)self.model;
    [mm clearCache:self.messageid userid:self.userid];
    [mm load:TTURLRequestCachePolicyDefault more:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.58f];
    [UIView setAnimationRepeatAutoreverses:NO];
    
    [self.tableView scrollToFirstRow:YES];
    [UIView commitAnimations];
}

//-(void)showLoading:(BOOL)show
//{
//    //
//}

-(void)initMainInfo:(NewsDetailObject*)message
{
    CGRect frame = self.view.bounds;    
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    
    
//    //////// meassagebody ////////
//    UILabel *meassagebody = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, 35)];
//    [meassagebody setText:message.MessageBody];
//    meassagebody.numberOfLines = 10;
//    meassagebody.lineBreakMode = UILineBreakModeClip;
//    meassagebody.userInteractionEnabled=YES;
//    [meassagebody setFont:[UIFont systemFontOfSize:16]];
//    meassagebody.shadowColor = [UIColor whiteColor];
//    meassagebody.shadowOffset = CGSizeMake(0, 1.0);
//    [meassagebody setTextColor:TTSTYLEVAR(textColor)];
//    [meassagebody setBackgroundColor:[UIColor clearColor]];
//  
//    CGSize size = CGSizeMake(frame.size.width-20, 60);
//    CGSize labelSize = [meassagebody.text sizeWithFont:meassagebody.font 
//                                     constrainedToSize:size
//                                         lineBreakMode:UILineBreakModeClip];
//    meassagebody.frame = CGRectMake(10, 10,frame.size.width-20,labelSize.height);
    
    
    UITextView *meassagebody=[[UITextView alloc] init];
    meassagebody.font=[UIFont systemFontOfSize:16];
    meassagebody.alwaysBounceVertical=YES;
    [meassagebody setFrame:CGRectMake(0, detailView.height, frame.size.width, 30)];
    meassagebody.text=message.MessageBody;
    meassagebody.backgroundColor=[UIColor clearColor];
    meassagebody.dataDetectorTypes=UIDataDetectorTypeAll;
    meassagebody.showsVerticalScrollIndicator=NO;
    meassagebody.scrollEnabled=NO;
    meassagebody.editable=NO;
    [detailView addSubview:meassagebody];
    [meassagebody setFrame:CGRectMake(0, detailView.height,  frame.size.width, meassagebody.contentSize.height)];
    detailView.height += meassagebody.height;
    [meassagebody release];
    
    
    UIView *uinfoView = [self initUserInfo:message frame:CGRectMake(0, detailView.height, frame.size.width,80)];
    [detailView addSubview:uinfoView];
    detailView.height += uinfoView.height;
    [uinfoView release];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(10, detailView.height, frame.size.width-20, 1)];
    [v1 setBackgroundColor:RGBCOLOR(148, 148, 148)];
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(10, detailView.height+1, frame.size.width-20, 1)];
    [v2 setBackgroundColor:RGBCOLOR(255, 255, 255)];
    

    [detailView addSubview:v1];
    [detailView addSubview:v2];
    detailView.height += 2;
    [v1 release];
    [v2 release];
    
    //////// imgview ////////
    //NSArray *imgurls = [userinfoent objectForKey:@"ImgUrl"];
    if(TTIsStringWithAnyText(message.PicPath))
    {
        UIView *bakv = [[UIView alloc] initWithFrame:CGRectMake(10, detailView.height +10, 300, 300)];
        [[bakv layer] setBorderColor: [RGBCOLOR(165, 165, 165) CGColor]];
        [[bakv layer ] setBorderWidth:1];
        [bakv setBackgroundColor:[UIColor whiteColor]];
        [detailView addSubview:bakv];
        [bakv release];
        
        NSString *_imginfo = [NSString stringWithFormat:@"%@_280_280.jpg",message.PicPath];
        TTImageView *imgview = [[TTImageView alloc] initWithFrame:CGRectMake(20, detailView.height +20, 280, 280)];
        imgview.urlPath =_imginfo; 
        [detailView addSubview:imgview];
        [imgview release];
        
        UIButton *btnmg = [[UIButton alloc] initWithFrame:imgview.frame];
        [btnmg addTarget:self action:@selector(onSelectImg) forControlEvents:UIControlEventTouchUpInside];
        [btnmg setBackgroundColor:[UIColor clearColor]];
        [detailView addSubview:btnmg];
        [btnmg release];
        
        
        detailView.height += imgview.height + 30;
        
    }
    

    
    UITextView *newsText=[[UITextView alloc] init];
    newsText.font=[UIFont systemFontOfSize:16];
    newsText.alwaysBounceVertical=YES;
    [newsText setFrame:CGRectMake(0, detailView.height, frame.size.width, 30)];
    newsText.text=message.NewsText;
    newsText.backgroundColor=[UIColor clearColor];
    newsText.dataDetectorTypes=UIDataDetectorTypeAll;
    newsText.showsVerticalScrollIndicator=NO;
    newsText.scrollEnabled=NO;
    newsText.editable=NO;
    [detailView addSubview:newsText];
    [newsText setFrame:CGRectMake(0, detailView.height,  frame.size.width, newsText.contentSize.height)];
    detailView.height += newsText.height;
    [newsText release];
    
    
//    UIView *v11 = [[UIView alloc] initWithFrame:CGRectMake(10, detailView.height, frame.size.width-20, 1)];
//    [v11 setBackgroundColor:RGBCOLOR(148, 148, 148)];
//    UIView *v21 = [[UIView alloc] initWithFrame:CGRectMake(10, detailView.height+1, frame.size.width-20, 1)];
//    [v21 setBackgroundColor:RGBCOLOR(255, 255, 255)];
//    [detailView addSubview:v11];
//    [detailView addSubview:v21];
//    detailView.height += 2;
//    [v11 release];
//    [v21 release];
    
    self.tableView.tableHeaderView = detailView;
    [detailView release];
}

-(void)onSelectImg
{
    NSString *imgPath = [NSString stringWithFormat:@"%@_280_280.jpg",self.message.PicPath];
    DetailImageViewController *view = [[DetailImageViewController alloc]  initWithTitle:@"" imgpath:imgPath];
    TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:view] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
    [view release];
}

-(void)RequestMainInfo
{
    NSString *tmpurl =  [NSString stringWithFormat:URLNewsDetails,KApi_Domain,self.messageid,self.userid];
    
    [UserHelper DegBugWidthLog:tmpurl title:@"URLNewsDetails"];
    
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* escapedUrlString =[tmpurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [ NSURL URLWithString : escapedUrlString ];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setStringEncoding:NSUTF8StringEncoding];
    //[request setRequestMethod:@"POST"];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    [request setDelegate:self];
    [request setUserAgent:KUserAgent];
    NSMutableDictionary *headers=[[NSMutableDictionary alloc] initWithCapacity:2];
    [headers setObject: [UserHelper GetSecToken] forKey:KUserSecToken];
    [headers setObject: [UserHelper GetUserID]  forKey:KUserID];
    [headers setObject:KAppKValue forKey:KAppKey];
    [request setRequestHeaders:headers];
    [headers release];
    [request startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate 
- (void)requestStarted:(ASIHTTPRequest *)request
{
    [self showLoading:YES];
    //[UserHelper DegBugWidthLog:@"requestStarted" title:@"requestStarted"];
    //[self.view addSubview:ttloading];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self showLoading:NO];
    //NSString * responseString = [request responseString];
    NSString* responseString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
	//NSLog(@"responseString -- %@",responseString);
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
	
	NSError* parserError = nil;
	id result = [jsonParser objectWithString:responseString error:&parserError];
    [responseString release];
    if(! parserError && [result isKindOfClass:[NSDictionary class]])
    {
        NSObject *Root = [result valueForKey:@"GetNewsDetailsResult"];
        bool success = [[Root valueForKey:@"Success"]  boolValue];
        if(success)
        {
            self.message.UserName = [NSString stringWithFormat:@"%@",   [Root valueForKey:@"AccountName"]];
            self.message.MessageBody = [NSString stringWithFormat:@"%@",  [Root valueForKey:@"MainTitle"]];
            self.message.UserFace = [NSString stringWithFormat:@"%@",  [Root valueForKey:@"AccountFace"]];
            self.message.PicPath = [NSString stringWithFormat:@"%@",  [Root valueForKey:@"ImagePath"]];
            self.message.NewsText = [NSString stringWithFormat:@"%@",  [Root valueForKey:@"NewsContent"]];
            self.message.PublicDate = [UserHelper formatDateByString:[Root valueForKey:@"CreateDate"]];
            self.message.Latitude =  [[Root valueForKey:@"Latitude"] floatValue];
            self.message.Longitude =  [[Root valueForKey:@"Longitude"] floatValue];
            self.message.UserType =  [[Root valueForKey:@"AccountType"] intValue];
            self.message.CommentCount = [[Root valueForKey:@"CommentCount"] intValue];
            self.message.CloneCount = [[Root valueForKey:@"CloneCount"] intValue];
            
            //
            if([Root valueForKey:@"Address"])
                self.message.Address = [NSString stringWithFormat:@"%@", [Root valueForKey:@"Address"]  ];
            else
                self.message.Address = @"";
            
            [self initMainInfo:self.message];
        }
        else
        {
            [UserHelper doAlert:self title:@"操作提示" message:@"该消息不存在、或已经被管理员删除！"];
        }
    }
    
    [jsonParser release];
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self showLoading:NO];
    //[UserHelper DegBugWidthLog:@"requestFailed" title:@"requestFailed"];
}

//- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
//    SnMessage *message = (SnMessage*)[_posts objectAtIndex:indexPath.row];
//    UserProfileViewController *view = [[UserProfileViewController alloc] initWidthUserId:message.UserID];
//    [self.navigationController pushViewController:view animated:YES];
//}

-(void)modelDidFinishLoad:(id<TTModel>)model
{
    NewsCommentModel *smodle = (NewsCommentModel*)self.model;
    _posts = smodle.posts;
    if(lCommentCount)
        [lCommentCount setText:[NSString stringWithFormat:@"%d",smodle.totalCount]];
    [super modelDidFinishLoad:model];
}

//-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
//{
//    //NSDictionary * dict = responseHeaders;
//    //NSLog(@"%@",request.responseData);
//}


-(void)goBack:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionPush;// @"cube";
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    MainViewController *main = [[MainViewController alloc] initWithNibName:nil bundle:nil]; 
    [self.navigationController presentModalViewController:main animated:NO];
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

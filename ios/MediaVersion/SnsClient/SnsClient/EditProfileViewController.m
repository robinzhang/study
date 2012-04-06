//
//  EditProfileViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "EditProfileViewController.h"
#import "UserProfile.h"
#import "UIDeviceHardware.h"

@implementation EditProfileViewController
@synthesize delegate = _delegate;
@synthesize imageData = imageData;
@synthesize profile = _profile;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        _me = [UserHelper GetUserID];
//        self.tableViewStyle = UITableViewStyleGrouped;
//        self.variableHeightRows = YES;
//    }
//    return self;
//}

-(id)initWidthProfile:(UserProfile*)profile
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _profile = profile;
        _me = [UserHelper GetUserID];
        self.tableViewStyle = UITableViewStyleGrouped;
        self.variableHeightRows = YES;
        self.title = @"个人信息修改";
        
        ///// pic
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = NO;
        
        _crop_Image = [[CropImageViewController alloc] initWithNibName:nil bundle:nil];
        _crop_Image.delegate = self;

        _currentSelectedImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        

        namelable = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 160, 25)];
        [namelable setFont:[UIFont systemFontOfSize:14]];
        [namelable setText:_profile.UserName];
        [namelable setTextAlignment:UITextAlignmentRight];
        [namelable setBackgroundColor:[UIColor clearColor]];
        
//        btnSubmit = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(doComplet)];
        
        TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"保存"]; 
        [rbtn2 addTarget:self action:@selector(doComplet) forControlEvents:UIControlEventTouchUpInside];
        [rbtn2 sizeToFit];
        btnSubmit = [[UIBarButtonItem alloc] initWithCustomView:rbtn2];
        
        TTActivityLabel *loadingview = [[[TTActivityLabel alloc] initWithFrame:CGRectMake(0, 0, 35, 30) style:TTActivityLabelStyleWhite text:@" " ] autorelease];
        ttloading = [[UIBarButtonItem alloc] initWithCustomView:loadingview];
    }
    return self;
}

//-(UIControl*)getUserFaceInfo
//{
//    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//    
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = btnSubmit;
    
//    TTButton *btn = [TTButton buttonWithStyle:@"blueColorBackButton:" title:NSLocalizedString(@"Cancel",@"取消")];
//    [btn addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
//    [btn sizeToFit];
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}

-(void)onCancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(TTSectionedDataSource*)getDataSource
{
    self.variableHeightRows = YES;
    
//    UITextView *meassagebody=[[UITextView alloc] init];
//    meassagebody.font=[UIFont systemFontOfSize:16];
//    meassagebody.alwaysBounceVertical=YES;
//    [meassagebody setFrame:CGRectMake(0, 0, 200, 30)];
//    meassagebody.text=_profile.Intro;
//    meassagebody.backgroundColor=[UIColor clearColor];
//    meassagebody.dataDetectorTypes=UIDataDetectorTypeAll;
//    meassagebody.showsVerticalScrollIndicator=NO;
//    meassagebody.scrollEnabled=NO;
//    meassagebody.editable=NO;
//    [meassagebody setFrame:CGRectMake(0, 0,  200, meassagebody.contentSize.height)];
    
//        UILabel *meassagebody = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 200, 35)];
//        [meassagebody setText:_profile.Intro];
//        meassagebody.numberOfLines = 10;
//        meassagebody.lineBreakMode = UILineBreakModeClip;
//        meassagebody.userInteractionEnabled=YES;
//        [meassagebody setFont:[UIFont systemFontOfSize:16]];
//        meassagebody.shadowColor = [UIColor whiteColor];
//        meassagebody.shadowOffset = CGSizeMake(0, 1.0);
//      [meassagebody setTextColor:TTSTYLEVAR(textColor)];
//        [meassagebody setBackgroundColor:[UIColor clearColor]];
//      
//       CGSize size = CGSizeMake(200, 100);
//        CGSize labelSize = [meassagebody.text sizeWithFont:meassagebody.font 
//                                         constrainedToSize:size
//                                             lineBreakMode:UILineBreakModeClip];
//       meassagebody.frame = CGRectMake(100, 5,200,labelSize.height);
////   
//    
//    TTTableControlItem *introItem = [TTTableControlItem itemWithCaption:@"简介:" control:meassagebody];
    
    TTTableSubtextItem *introItem = [TTTableSubtextItem itemWithText:@"简介:" delegate:self selector:@selector(showEditorForIntro:)];
    [introItem setCaption:_profile.Intro];
    
    
    NSString *ufaceUrl = [NSString stringWithFormat:@"%@_80_80.jpg",_profile.UserFace];
//    TTTableImageItem *item1 = [TTTableImageItem itemWithText:@"修改头像" delegate:self selector:@selector(showImagePicker:)];
//    [item1 setImageURL:ufaceUrl];
//    [item1 setDefaultImage:TTIMAGE(@"bundle://icon_default_40_40.png")];
    //rightarrow.png
    
    UIControl *control = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    TTImageView *img = [[TTImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [img setUrlPath:ufaceUrl];
    [img setDefaultImage:TTIMAGE(@"bundle://icon_default_40_40.png")];
    [control addSubview:img];
    [img release];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 320-60, 30)];
    [lable setText:@"修改头像"];
    [lable setBackgroundColor:[UIColor clearColor]];
    [control addSubview:lable];
    [lable release];
    
    UIImageView *imgev = [[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://rightarrow.png")];
    [imgev setFrame:CGRectMake(290-20,(60-17) / 2, 13, 17)];
    [control addSubview:imgev];
    [imgev release];
    
    [control addTarget:self action:@selector(showImagePicker:) forControlEvents:UIControlEventTouchUpInside];
    
    
    TTTableTextItem *item2 = [TTTableTextItem itemWithText:@"昵称:" delegate:self selector:@selector(showEditorForName:)];
    
    return  [SnSectionedDataSource dataSourceWithObjects:
                       @"",
                       control,
                       @"",
                       item2,
                       @"",
                       introItem,
                       nil];
}

-(void)createModel
{
    self.dataSource = [self getDataSource];
    [self.tableView addSubview:_currentSelectedImage];
    [self.tableView addSubview:namelable];
}

- (void)didTextEditorEndEditing:(NSString*)text tag:(int)tag
{
    [self.navigationController bringControllerToFront:self animated:YES];
    _profile.Intro = text; 
    self.dataSource = [self getDataSource];
}

- (void)didTextFieEndEditing:(NSString*)text tag:(int)tag
{
    [self.navigationController bringControllerToFront:self animated:YES];
    _profile.UserName = text;
    [namelable setText:text];
    self.dataSource = [self getDataSource];
}


-(void)updateUserInfo
{
    NSString* UserName =[_profile.UserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* Intro =[_profile.Intro stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* url = [NSString stringWithFormat:URLUpdateUserInfo,KApi_Domain, _me,UserName,Intro,_profile.Sex];
    TTURLRequest *request = [TTURLRequest
                              requestWithURL:url
                              delegate: self];
    //sec
    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    //end sec
    
    request.cachePolicy =   TTURLRequestCachePolicyNoCache;
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    
    TT_RELEASE_SAFELY(response);
    [request send];
    
    [UserHelper DegBugWidthLog:url title:@"URLUpdateUserInfo"];
}


- (void)upUserFace{
    if (!self.imageData ||  self.imageData.length <= 0) {
        [self updateUserInfo];
    }
    else
    {
    
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *turl=[NSString stringWithFormat:URLUpdateUserFace,KApi_Domain,[userDefaults objectForKey:KUserID]];
        NSURL *url = [ NSURL URLWithString:turl ];
    
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setStringEncoding:NSUTF8StringEncoding];
        [request setRequestMethod:@"POST"];
        //[request setDelegate:self];
        [request setUserAgent:KUserAgent];
        [request appendPostData:self.imageData];
    
        NSMutableDictionary *headers=[[NSMutableDictionary alloc] initWithCapacity:2];
        [headers setObject:[UserHelper GetSecToken]  forKey:KUserSecToken];
        [headers setObject: [UserHelper GetUserID] forKey:KUserID];
        [headers setObject:KAppKValue forKey:KAppKey];
        [request setRequestHeaders:headers];
        [headers release];
    
        self.navigationItem.rightBarButtonItem = ttloading;
    
        [request startSynchronous];
        
        [UserHelper DegBugWidthLog:turl title:@"UpdateUserFace"];
    
        [self updateUserInfo];
    }
}

-(void)doComplet
{
    [self upUserFace];
}

#pragma mark - View TTURLRequest
-(void)requestDidStartLoad:(TTURLRequest *)request
{
    self.navigationItem.rightBarButtonItem = ttloading;

}

-(void)requestDidFinishLoad:(TTURLRequest *)request
{
    TTURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    //UpdateUserInfoResult
    bool feed = [[response.rootObject objectForKey:@"UpdateUserInfoResult"] boolValue];
    //NSLog(@"%@",feed);
    //TTDASSERT([feed isKindOfClass:[NSDictionary class]]);
    //BOOL Success = [[feed objectForKey:@"Success"] boolValue];
    //NSString* ErrorMessage = [feed objectForKey:@"ErrorMessage"];
    if(feed)
    {
        self.navigationItem.rightBarButtonItem = btnSubmit;
        _currentSelectedImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageData = [NSData data]; 
        
        [self.delegate didAfterEditProfile];
        //[self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [UserHelper doAlert:self title:@"保存失败！" message:[NSString stringWithFormat:@"保存失败,换个昵称试试吧！"]];
        self.navigationItem.rightBarButtonItem = btnSubmit;
    }
}

-(void) request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    [UserHelper doAlert:self title:@"保存失败！" message:@"保存失败，请检查您的网络状态"];
    self.navigationItem.rightBarButtonItem = btnSubmit;
}

#pragma mark - View showEditorForName
-(void)showEditorForName:(id)sender
{
    TextFieldViewController *textEditor = [[TextFieldViewController alloc] initWithText:_profile.UserName tag:0];
    textEditor.delegate = self;
//    TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:textEditor] autorelease];
//    [self.navigationController  presentModalViewController:nav animated:YES];
    [self.navigationController pushViewController:textEditor animated:YES];
    [textEditor release];
}

#pragma mark - View showEditorForIntro
-(void)showEditorForIntro:(id)sender
{
    TextEditorViewController *textEditor = [[TextEditorViewController alloc] initWithText:_profile.Intro title:@"自我介绍" tag:1 maxlength:100];
    textEditor.delegate = self;
    //TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:textEditor] autorelease];
    [self.navigationController pushViewController:textEditor animated:YES];
    [textEditor release];
}

#pragma mark - View showImagePicker

-(void)showImagePicker:(id)sender
{
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        UIActionSheet *as=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"select photo", @"选择照片") 
                                                      delegate:self 
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") 
                                        destructiveButtonTitle:nil 
                                             otherButtonTitles:NSLocalizedString(@"album", @"浏览相册"), NSLocalizedString(@"camera", @"使用相机"),nil];
        as.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        //[as showInView:self.view];
        [as showFromTabBar:self.tabBarController.tabBar];
        [as release];
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:imagePicker animated:YES];
        
//        UIActionSheet *as=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"select photo", @"选择照片") 
//                                                      delegate:self 
//                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") 
//                                        destructiveButtonTitle:nil 
//                                             otherButtonTitles:NSLocalizedString(@"album", @"浏览相册"),nil];
//        as.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
//        [as showInView:self.view];
//        //[as showFromTabBar:self.tabBarController.tabBar];
//        [as release];
    }
}

////////////////////////////////// UIActionSheetDelegate ///////////////////////////////////////
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:imagePicker animated:YES];
            break;
        case 1:
            if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:imagePicker animated:YES];
            }
            break;
        default:
            break;
    }
}
#pragma mark CropImageDeDelegate
- (void)didAfterCropImage:(UIImage*)image width:(CGFloat)width 
                   height:(CGFloat)height  croper:(CropImageViewController*)croper
{
    self.imageData=UIImageJPEGRepresentation(image, 0.95f);
    //[self uploadPic];
    [_currentSelectedImage setImage:image];
    [_currentSelectedImage setFrame:CGRectMake(28, 20, 40, 40)];
    [croper dismissModalViewControllerAnimated:YES];
}

- (void)didCancelCropImage:(CropImageViewController*)croper
{
    [croper dismissModalViewControllerAnimated:YES];
}
#pragma mark - ImagePicker Delegate
/////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
    //int  p = [UIDeviceHardware platformInt];
    //if(p>3)
    //    self.imageData=UIImageJPEGRepresentation(image, 0.5f);
    //else
    //    self.imageData=UIImageJPEGRepresentation(image, 0.8f);
    //[_currentSelectedImage setImage:image];
    //[_currentSelectedImage setFrame:CGRectMake(28, 20, 40, 40)];
    //[picker dismissModalViewControllerAnimated:YES];
    
    [picker dismissModalViewControllerAnimated:NO];
    
    [self.navigationController  presentModalViewController:_crop_Image animated:NO];
    [_crop_Image StartCropImage:[image retain]];
    
    //[self upUserFace];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)imagePickerController:(UIImagePickerController *)picker 
//    didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [self dismissModalViewControllerAnimated:YES];
//    //[super imagePickerController:picker didFinishPickingMediaWithInfo:info];
//}

/////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
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
//    TT_RELEASE_SAFELY(_profile);
//    TT_RELEASE_CF_SAFELY(imagePicker);
//    TT_RELEASE_CF_SAFELY(_me);
//    TT_RELEASE_CF_SAFELY(imageData);
//    TT_RELEASE_SAFELY(_currentSelectedImage);
//    TT_RELEASE_SAFELY(namelable);
//    TT_RELEASE_SAFELY(btnSubmit);
//    TT_RELEASE_SAFELY(ttloading);
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

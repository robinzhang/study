//
//  SecondViewController.m
//  SnsClient
//
//  Created by  on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PublishViewController.h"
#import "UIDeviceHardware.h"

@implementation PublishViewController
@synthesize  text = _text;
@synthesize  newstitle = _newstitle;
@synthesize friendIds = _friendIds;
@synthesize imageData = _imageData;
@synthesize imageUrl = _imageUrl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self.view setBackgroundColor:[UIColor blueColor]];
        
        self.title = @"发布";
        UITabBarItem *item = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_public.png"] tag:2] autorelease];
        self.tabBarItem = item;

       
        
        _text = [[UITextField alloc] init];
        [_text setFont:[UIFont systemFontOfSize:14]];
        _text.placeholder = @"新闻内容";
        [_text setTextAlignment:UITextAlignmentLeft];
        [_text setTextColor:[UIColor grayColor]];
        //[_text sizeToFit];
        [_text setFrame:CGRectMake(10, 8, 280, 30)];
        [_text setEnabled:NO];
        
        //initWithFrame:CGRectMake(5, 5, 280, 25)];
        //_text.delegate = self;
        //_text.placeholder = @"新闻内容";
        
        _newstitle = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, 280, 30)];
        [_newstitle setFont:[UIFont systemFontOfSize:14]];
        _newstitle.placeholder = @"新闻标题";
        //[_newstitle setBorderStyle:UITextBorderStyleNone];
        
        self.tableView.sectionFooterHeight = 10;
        self.tableView.sectionHeaderHeight = 10;
        
        _currentSelectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(235, 80, 35, 35)];
        [_currentSelectedImage setImage:TTIMAGE(@"bundle://icon_default.png")];   
        
        ////// friends
        friendsPicker = [[SnSelectFriendsController alloc] initWithNibName:nil bundle:nil];
        friendsPicker.delegate = self;
        
        _friendNames = [[UIButton alloc] init];
        [_friendNames addTarget:self action:@selector(showFrends:) forControlEvents:UIControlEventTouchUpInside];
        [_friendNames setFrame:CGRectMake(120, 275, 160, 35)];
        [_friendNames.titleLabel setTextAlignment:UITextAlignmentRight];
        [_friendNames setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_friendNames.titleLabel setFont:[UIFont systemFontOfSize:12]];
        //[_friendNames setTitle:@"_friendNames" forState:UIControlStateNormal];
        [_friendNames setBackgroundColor:[UIColor clearColor]];
        
        ////// weibo
        _switchy = [[UISwitch alloc] init];
        
        ///// map
        mapPicker = [[SnMapLocationController alloc] initWithNibName:nil bundle:nil];
        mapPicker.delegate = self;
        
        _address =[[UIButton alloc] init];
        [_address addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
        [_address setFrame:CGRectMake(120, 210, 168, 35)];
        [_address.titleLabel setTextAlignment:UITextAlignmentRight];
        //[_address setTitle:@"_address" forState:UIControlStateNormal];

        [_address setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_address.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_address setBackgroundColor:[UIColor clearColor]];
        
        coordinate = [UserHelper GetUserLocation];
        
        
        
        TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"发布" ]; 
        [rbtn2 addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
        [rbtn2 sizeToFit];
        

        
        btnSubmit =  [[UIBarButtonItem alloc] initWithCustomView:rbtn2];
        CGRect frame = self.view.bounds;
        
        ///////////   postloading  ///////////////
        postloading  = [[TTActivityLabel  alloc] initWithFrame:CGRectMake(80, 100, 160, 60) style:TTActivityLabelStyleWhite text:@" "];
        overlayView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [overlayView setBackgroundColor:[UIColor blackColor]];
        overlayView.alpha = 0.45f;
        
        
        
        _friendIds = @"";        
        
        picker_lib = [[UIImagePickerController alloc] init];
        picker_lib.delegate = self;
        picker_lib.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker_lib.allowsEditing = NO;
        
        /*
        picker_camera = [[UIImagePickerController alloc] init];
        picker_camera.delegate = self;
        picker_camera.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker_camera.allowsEditing = NO;
        */
        
        _crop_Image = [[CropImageViewController alloc] initWithNibName:nil bundle:nil];
        _crop_Image.delegate = self;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = btnSubmit;
    
    CGRect frame = self.view.bounds;
    [self.tableView setFrame:CGRectMake(0, KPageTitleHeight, frame.size.width, frame.size.height - KPageTitleHeight)];
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)createModel
{
    self.tableViewStyle = UITableViewStyleGrouped;
    self.variableHeightRows = NO;
    
    UIControl *control = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 35)] autorelease];
    [control addSubview:_text];
    
    UIImageView *imgev = [[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://rightarrow.png")];
    [imgev setFrame:CGRectMake(290-20,(38-17) / 2, 13, 17)];
    [control addSubview:imgev];
    [imgev release];
    
    [control addTarget:self action:@selector(showTxtEditor) forControlEvents:UIControlEventTouchUpInside];
    
    UIControl *control2 = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 35)] autorelease];
    [control2 addSubview:_newstitle];
    
    
    TTTableControlItem* switchItem = [TTTableControlItem itemWithCaption:@"同步微博" control:_switchy];
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects: 
                       @"",
                       control2,
                       @"",
                       [TTTableTextItem itemWithText:@"添加图片" delegate:self selector:@selector(showPhotos:)],
                       @"",
                       control,
                       @"",
                       [TTTableTextItem itemWithText:@"新闻发生地" delegate:self selector:@selector(showMap:)],
                       @"",
                       [TTTableTextItem itemWithText:@"同时报料给" delegate:self selector:@selector(showFrends:)],
                       switchItem,
                       nil];
    
   // 250  90
   // 125 45
   //b
    
    UIView *fview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 72)];
    submitButton =  [UIButton buttonWithType:UIButtonTypeCustom ];
    [submitButton setBackgroundImage:TTIMAGE(@"bundle://btn_bg_fb.png") forState:UIControlStateNormal];
    [submitButton setFrame:CGRectMake(98, 15,125, 45)];
    [submitButton addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
    [fview addSubview:submitButton];
    [self.tableView setTableFooterView:fview];
    [fview release];
    
    [self.tableView addSubview:_friendNames];
    [self.tableView addSubview:_currentSelectedImage];
    [self.tableView addSubview:_address];
}


-(void)onCancel:(id)cender
{
    [_text resignFirstResponder];
    [_newstitle resignFirstResponder];
    [self.tabBarController setSelectedIndex:0];
}


//- (void)Step2DoPublish
//{
//    //[_text resignFirstResponder];
//    //[_newstitle resignFirstResponder];
//    [self.tabBarController setSelectedIndex:0];
//}
//
//- (void)Step2CancelPublish
//{
//    [_newstitle becomeFirstResponder];
//    //[_newstitle resignFirstResponder];
//    //[self.tabBarController setSelectedIndex:0];
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didEndDragging {
    [_newstitle resignFirstResponder];
}

-(void)doSubmit
{
    NSString *content = [_text.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *maintitle = [_newstitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    maintitle = [maintitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(!TTIsStringWithAnyText(maintitle))
    {
        [UserHelper doAlert:self title:@"发布提示" message:@"请输入新闻标题！"];
        return;
    }
    else if(!TTIsStringWithAnyText(content))
    {
        [UserHelper doAlert:self title:@"发布提示" message:@"请输入新闻内容！"];
        return;
    }

    NSString *userid = [UserHelper GetUserID];
    //NSString *subtitle = @"";
    //NSString *occurtime = @"";
    NSString *longitude = @"";
    NSString *latitude = @"";
    if(coordinate)
    {
        latitude = [NSString stringWithFormat:@"%f",coordinate.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%f",coordinate.coordinate.longitude];
    }
    NSString *address = @"";
    if(_address.titleLabel.text)
       address =[_address.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    
    //NSString *cancomment = @"0";
    //NSString *newsType = @"2";
    //NSString *source = @"";
    //NSString *notifySoundName = @"";
    
    [UserHelper DegBugWidthLog:self.imageUrl title:@"imageUrl"];
    
    NSString *imageUrl =@"";
    if(self.imageUrl)
        imageUrl = [self.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *idlists = self.friendIds;
    
    if(!self.friendIds)
             idlists = @"";
    
    NSString *tmpurl =  [NSString stringWithFormat:URLPostNewsContent,KApi_Domain,userid,maintitle,longitude,latitude,address,idlists,imageUrl];
    //userid=%@&maintitle=%@&subtitle=&occurtime=&longitude=%f&latitude=%f&address=%@&cancomment=1&newsType=128&source=iphone&notifySoundName=&idlists=%@&imageUrl=%@
    
    [UserHelper DegBugWidthLog:tmpurl title:@"URLPostNews"];
    
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* escapedUrlString =[tmpurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [ NSURL URLWithString : escapedUrlString ];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setUploadProgressDelegate:self];
    [request setUserAgent:KUserAgent];
    NSMutableDictionary *headers=[[NSMutableDictionary alloc] initWithCapacity:2];
    [headers setObject:[UserHelper GetSecToken]  forKey:KUserSecToken];
    [headers setObject: [UserHelper GetUserID] forKey:KUserID];
    [headers setObject:KAppKValue forKey:KAppKey];
    
    [request setRequestHeaders:headers];
    
    ////  content ///////
    NSData* data=[content dataUsingEncoding:NSUTF8StringEncoding];
    if ([data length] == 0) {
        data= [NSData data];
    }
    [request appendPostData:data];
    
    request.tag = 8;
    [headers release];
    [request startAsynchronous];

}

#pragma mark - showTxtEditor 
- (void)didTextEditorEndEditing:(NSString*)text tag:(int)tag
{
    //[self.navigationController pushViewController:self animated:YES];
    [self.navigationController bringControllerToFront:self animated:YES];
    [_text setText:text];
}

-(void)showTxtEditor
{
    TextEditorViewController *textEditor = [[TextEditorViewController alloc] initWithText:_text.text title:@"新闻内容" tag:1 maxlength:2000];
    textEditor.delegate = self;
    //TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:textEditor] autorelease];
    //[self.navigationController  presentModalViewController:nav animated:YES];
    [self.navigationController  pushViewController:textEditor animated:YES];
    [textEditor release];
}

-(void)reset
{
    [_text resignFirstResponder];
    [_newstitle resignFirstResponder];
    [_text setText:@""];
    [_newstitle setText:@""];
    self.imageData= [NSData data];
    [_currentSelectedImage setImage:TTIMAGE(@"bundle://icon_default.png")];  
    self.friendIds = @"";
    [_friendNames setTitle:@"" forState:UIControlStateNormal];
    [_address setTitle:@"" forState:UIControlStateNormal];
    [_address.titleLabel setText:@""];
    self.imageUrl = @"";
    coordinate  = [UserHelper GetUserLocation];
    if(mapPicker)
        [mapPicker reset];
}

-(void)resetLoading
{
    submitButton.enabled = YES;
    btnSubmit.enabled = YES;
    self.navigationItem.rightBarButtonItem = btnSubmit;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        [_newstitle setText:@""];
    }
}

#pragma mark - WBSendViewDelegate 
- (void)request:(WBRequest *)request didLoad:(id)result
{
   WeiBoHelper *application = [WeiBoHelper sharedInstance];
    [application dismissWeiboSendView];
}

-(void)sendToWeibo
{
   WeiBoHelper *application = [WeiBoHelper sharedInstance];
    if([application isWeiBoLogon])
    {
        application.delegate = nil;
        
        NSString *msg = [NSString stringWithFormat:@"我用#新闻两公里#发表了一条新闻资讯与你分享，标题是:%@ ，请及时围观。",_newstitle.text];
        
        if(TTIsStringWithAnyText(_address.titleLabel.text))
        {
            msg = [NSString stringWithFormat:@"我用#新闻两公里#发表了一条新闻资讯与你分享，标题是:%@，它发生的地点在:%@，如果你刚好在那里，请及时围观。",_newstitle.text,_address.titleLabel.text];
        }
        
        [application sendWeibo:msg image:_currentSelectedImage.image andDelegate:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userPublishNewsSucc" object:coordinate];
        [self reset];
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

#pragma  mark ASIProgressDelegate
- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
   postloading.progress = (request.totalBytesSent*1.0)/(request.contentLength*1.0);
}
//- (void)setProgress:(float)newProgress
//{
//    postloading.progress = newProgress;
//}
#pragma mark - ASIHTTPRequestDelegate 
- (void)requestStarted:(ASIHTTPRequest *)request
{
    submitButton.enabled = NO;
    btnSubmit.enabled = NO;
    [self.view addSubview:overlayView];
    [self.view addSubview:postloading];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [postloading removeFromSuperview];
    [overlayView removeFromSuperview];
    NSString* responseString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
	
    if(request.tag == 1)
    {
        //{"PostImageResult":{"ErrorMessage":null,"Success":true,"Text":"\/UserTmpFiles\/20111122\/5084971528241681204.jpg"}}
            
        [UserHelper DegBugWidthLog:responseString title:@"upfile result"];
        NSError* parserError = nil;
        id result = [jsonParser objectWithString:responseString error:&parserError];
        [responseString release];
        if(! parserError && [result isKindOfClass:[NSDictionary class]])
        {
            ///////// msg /////
            NSObject *root = [result valueForKey:@"PostImageResult"];
            bool Success = [[root valueForKey:@"Success"] boolValue] ;
            if(Success)
            {
                self.imageUrl = [NSString stringWithFormat:@"%@",[root valueForKey:@"Text"]];
                [UserHelper DegBugWidthLog:self.imageUrl title:@"imageUrl"];
            }
            else
            {
                NSString *ErrorMessage = [NSString stringWithFormat:@"%@", [root valueForKey:@"ErrorMessage"]]; 
                self.imageData= [NSData data];
                [_currentSelectedImage setImage:TTIMAGE(@"bundle://icon_default.png")]; 
                
                [UserHelper doAlert:self title:@"操作提示" message:[NSString stringWithFormat:@"图片上传失败，请重试！ %@",ErrorMessage]];
            }
        }
        else
        {
            self.imageData= [NSData data];
            [_currentSelectedImage setImage:TTIMAGE(@"bundle://icon_default.png")]; 
            
            [UserHelper doAlert:self title:@"操作提示" message:@"图片上传失败，请检查网络链接状态！"];
        }
        
        [self resetLoading];
    }
    else
    {   
         [UserHelper DegBugWidthLog:responseString title:@"Publish Result"];

         NSError* parserError = nil;
         id result = [jsonParser objectWithString:responseString error:&parserError];
         [responseString release];
         if(! parserError && [result isKindOfClass:[NSDictionary class]])
         {
             ///////// msg /////
             NSObject *root = [result valueForKey:@"PostNewsResult"];
             bool Success = [[root valueForKey:@"Success"] boolValue] ;
             if(Success)
             {
                 if(_switchy.on)
                 {
                    WeiBoHelper *application = [WeiBoHelper sharedInstance];
                     if([application isWeiBoLogon])
                     {
                         [self sendToWeibo];
                     }
                     else
                     {
                         application.delegate = self;
                         application.changeUser = NO;
                         [application weiboLogin];
                     }
                 }
                 else
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"userPublishNewsSucc" object:coordinate];
                     [self reset];
                     [self.tabBarController setSelectedIndex:0]; 
                 }
             }
             else
             {
                 NSString *ErrorMessage = [NSString stringWithFormat:@"%@", [root valueForKey:@"ErrorMessage"]]; 
                 [UserHelper doAlert:self title:@"发布提示" message:[NSString stringWithFormat:@"发布失败、%@",ErrorMessage]];
             }
         }
         else
         {
             
             [UserHelper doAlert:self title:@"发布提示" message:@"发布失败、请检查网络链接状态！"];
         }
        [self resetLoading];
   
     }
    [jsonParser release];
}





- (void)requestFailed:(ASIHTTPRequest *)request
{
    [postloading removeFromSuperview];
    [overlayView removeFromSuperview];
    [self resetLoading];
    
    if(request.tag == 1)
    {
        self.imageData= [NSData data];
        [_currentSelectedImage setImage:TTIMAGE(@"bundle://icon_default.png")]; 
        

      [UserHelper doAlert:self title:@"失败提示" message:@"上传图片失败、请检查网络链接状态！"];
    }
    else
      [UserHelper doAlert:self title:@"发布提示" message:@"发布失败、请检查网络链接状态！"];
}

#pragma mark - showFrends 
-(void)showFrends:(id)sender
{
    [_newstitle resignFirstResponder];
    //TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:friendsPicker] autorelease];
    [self.navigationController pushViewController:friendsPicker animated:YES];
}

///////////////////////////////// SnSelectFriendsDelegate /////////////////////////////// 
- (void)didSelectFriends:(NSString*)ids names:(NSString*)names
{
    [self.navigationController bringControllerToFront:self animated:YES];
    self.friendIds = ids;
    [_friendNames setTitle:names forState:UIControlStateNormal];
    //[submitButton becomeFirstResponder];
}


#pragma mark - showMap 
-(void)showMap:(id)sender
{
    [_newstitle resignFirstResponder];
    //TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:mapPicker] autorelease];
    [self.navigationController pushViewController:mapPicker animated:YES];
}

///////////////////////////// SnMapLocationDelegate //////////////////////////////////////////////////////////////
- (void)didSelectLocation:(CLLocation*)location adress:(NSString*)adress
{
    [self.navigationController bringControllerToFront:self animated:YES];
    if(location)
    {
        coordinate = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        if(TTIsStringWithAnyText(adress))
        {
            [_address setTitle:[NSString stringWithFormat:@"%@",adress]  forState:UIControlStateNormal];
        }
//        else
//        {
//            [_address setTitle:[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude]  forState:UIControlStateNormal];
//        }
    }
    //[submitButton becomeFirstResponder];
}


#pragma mark - showPhotos 
/////////////////////////////////////////////////////////////////////////////////////////////
-(void)showPhotos:(id)sender
{
    [_newstitle resignFirstResponder];
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
//        UIActionSheet *as=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"select photo", @"选择照片") 
//                                                      delegate:self 
//                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") 
//                                        destructiveButtonTitle:nil 
//                                             otherButtonTitles:NSLocalizedString(@"album", @"浏览相册"),nil];
//        as.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
//        [as showInView:self.view];
//        [as release];
        
        ///// pic

        picker_lib.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker_lib animated:YES];
    }
}

////////////////////////////////// UIActionSheetDelegate ///////////////////////////////////////
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            picker_lib.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //picker_lib.allowsEditing = NO;
            [self presentModalViewController:picker_lib animated:YES];
            break;
        case 1:
            if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
            {
                picker_lib.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker_lib.cameraFlashMode=UIImagePickerControllerCameraFlashModeOff;
                //picker_camera.allowsEditing = NO;
                [self presentModalViewController:picker_lib animated:YES];
            }
            break;
        default:
            break;
    }
    //[_newstitle becomeFirstResponder];
}
#pragma mark - uploadPic
- (void)uploadPic
{
    NSString* tmpurl = [NSString stringWithFormat:URLPublishImage,KApi_Domain,[UserHelper GetUserID]];
    NSString* escapedUrlString =[tmpurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString : escapedUrlString ];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setUploadProgressDelegate:self];
    [request setUserAgent:KUserAgent];
    NSMutableDictionary *headers=[[NSMutableDictionary alloc] initWithCapacity:2];
    [headers setObject:[UserHelper GetSecToken]  forKey:KUserSecToken];
    [headers setObject:[UserHelper GetUserID] forKey:KUserID];
    [headers setObject:KAppKValue forKey:KAppKey];
    
    [request setRequestHeaders:headers];
    
    if ([self.imageData length] == 0) {
        self.imageData= [NSData data];
    }
    [request appendPostData:self.imageData];
    
    request.tag = 1;
    [headers release];
    [request startAsynchronous];
}
#pragma mark CropImageDeDelegate
- (void)didAfterCropImage:(UIImage*)image width:(CGFloat)width 
                   height:(CGFloat)height  croper:(CropImageViewController*)croper
{
    self.imageData=UIImageJPEGRepresentation(image, 0.95f);
    [self uploadPic];
    [_currentSelectedImage setImage:image];
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
    
     switch ([picker sourceType]) {
         case UIImagePickerControllerSourceTypeCamera: {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil );
         }
         default:
             break;
    }

    [picker dismissModalViewControllerAnimated:NO];
    
    [self.navigationController  presentModalViewController:_crop_Image animated:NO];
    [_crop_Image StartCropImage:[image retain]];

    //[self.navigationController bringControllerToFront:self animated:NO];
    
    /*
    int  p = [UIDeviceHardware platformInt];
    if(p>3)
        self.imageData=UIImageJPEGRepresentation(image, 0.7f);
    else
        self.imageData=UIImageJPEGRepresentation(image, 0.95f);
    */
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

-(void)dealloc
{
//    TT_RELEASE_SAFELY(imagePicker);
//    TT_RELEASE_SAFELY(mapPicker);
//    TT_RELEASE_SAFELY(friendsPicker);
//    TT_RELEASE_SAFELY(_newstitle);
//    TT_RELEASE_SAFELY(_text);
//    TT_RELEASE_SAFELY(_imageData);
//    TT_RELEASE_SAFELY(_currentSelectedImage);
//    TT_RELEASE_SAFELY(coordinate);
//    TT_RELEASE_SAFELY(_address);
//    TT_RELEASE_SAFELY(_friendIds);
//    TT_RELEASE_SAFELY(_friendNames);
//    TT_RELEASE_SAFELY(_switchy);
//    TT_RELEASE_SAFELY(submitButton);
//    TT_RELEASE_SAFELY(btnSubmit);
//    TT_RELEASE_SAFELY(postloading);
    [super dealloc];
}
@end

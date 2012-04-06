//
//  PublicStep2ViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PublishStep2ViewController.h"

@implementation PublishStep2ViewController
@synthesize delegate= _delegate;
@synthesize text = _text;
@synthesize newstittle = _newstittle;
@synthesize friendIds = _friendIds;
@synthesize imageData = _imageData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatione
        self.hidesBottomBarWhenPushed = YES;
        self.tableViewStyle = UITableViewStyleGrouped;
        self.variableHeightRows = YES;
        
        ///// pic
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        
        _currentSelectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(235, 14, 35, 35)];
        [_currentSelectedImage setImage:[UIImage imageNamed:@"icon_default.png"]];   
        
        ////// friends
        friendsPicker = [[SnSelectFriendsController alloc] initWithNibName:nil bundle:nil];
        friendsPicker.delegate = self;
        
        _friendNames = [[UIButton alloc] init];
        [_friendNames addTarget:self action:@selector(showFrends:) forControlEvents:UIControlEventTouchUpInside];
        [_friendNames setFrame:CGRectMake(120, 75, 160, 35)];
        [_friendNames.titleLabel setTextAlignment:UITextAlignmentRight];
        [_friendNames setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_friendNames.titleLabel setFont:[UIFont systemFontOfSize:12]];
        //[_friendNames setTitle:@"....." forState:UIControlStateNormal];
        [_friendNames setBackgroundColor:[UIColor clearColor]];
        
        ////// weibo
        _switchy = [[UISwitch alloc] init];
        
        ///// map
        mapPicker = [[SnMapLocationController alloc] initWithNibName:nil bundle:nil];
        mapPicker.delegate = self;
        
        _address =[[UIButton alloc] init];
        [_address addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
        [_address setFrame:CGRectMake(120, 138, 160, 35)];
        [_address.titleLabel setTextAlignment:UITextAlignmentRight];
        [_address setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_address.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_address setBackgroundColor:[UIColor clearColor]];
        
        coordinate = [UserHelper GetUserLocation];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    TTButton *btn = [TTButton buttonWithStyle:@"blueColorBackButton:" title:NSLocalizedString(@"Back",@"Back")];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)createModel
{
    
    TTTableControlItem* switchItem = [TTTableControlItem itemWithCaption:@"同步微博" control:_switchy];

    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"",
                       [TTTableTextItem itemWithText:@"添加图片" delegate:self selector:@selector(showPhotos:)],
                       @"",
                       [TTTableTextItem itemWithText:@"同时报料给" delegate:self selector:@selector(showFrends:)],
                       @"",
                       [TTTableTextItem itemWithText:@"新闻地点" delegate:self selector:@selector(showMap:)],
                       @"",
                       switchItem,
                       nil];
    
    UIView *fview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
    TTButton *button =  [TTButton buttonWithStyle:@"blueButtonStyle:" title:NSLocalizedString(@"Submit",@"Submit")];
    [button setFrame:CGRectMake(8, 5,304, 42)];
    [button addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
    [fview addSubview:button];
    [self.tableView setTableFooterView:fview];
    [fview release];
    
    [self.tableView addSubview:_friendNames];
    [self.tableView addSubview:_currentSelectedImage];
    [self.tableView addSubview:_address];
}

-(void)goBack
{
    [self dismissModalViewControllerAnimated:NO];
    [self.delegate Step2CancelPublish];
}

-(void)doSubmit
{
  
    
    NSString *userid = [UserHelper GetUserID];
    NSString *maintitle = [self.newstittle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *subtitle = @"";
    NSString *occurtime = @"";
    NSString *longitude = @"";
    NSString *latitude = @"";
    if(coordinate)
    {
        latitude = [NSString stringWithFormat:@"%f",coordinate.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%f",coordinate.coordinate.longitude];
    }
    NSString *address = [_address.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *content = [_text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *cancomment = @"0";
    NSString *newsType = @"2";
    NSString *source = @"";
    NSString *notifySoundName = @"";
    NSString *idlists = self.friendIds;
    
    NSString *tmpurl =  [NSString stringWithFormat:URLPostNews,KApi_Domain,userid,maintitle,subtitle,occurtime,longitude,latitude,address,content,cancomment,newsType,source,notifySoundName,idlists];
    
    [UserHelper DegBugWidthLog:tmpurl title:@"URLPostNews"];
    
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* escapedUrlString =[tmpurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [ NSURL URLWithString : escapedUrlString ];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setUserAgent:KUserAgent];
    NSMutableDictionary *headers=[[NSMutableDictionary alloc] initWithCapacity:2];
    [headers setObject:[UserHelper GetSecToken]  forKey:KUserSecToken];
    [headers setObject: [UserHelper GetUserID] forKey:KUserID];
    [headers setObject:KAppKValue forKey:KAppKey];
    [request setRequestHeaders:headers];
    [headers release];
    if ([self.imageData length] == 0) {
        self.imageData=[NSData data];
    }
    [request appendPostData:self.imageData];
    
    [request startAsynchronous];
}


#pragma mark - ASIHTTPRequestDelegate 
- (void)requestStarted:(ASIHTTPRequest *)request
{
    //[UserHelper DegBugWidthLog:@"requestStarted" title:@"requestStarted"];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSString * responseString = [request responseString];
    NSString* responseString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"responseString -- %@",responseString);
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
	
	NSError* parserError = nil;
	id result = [jsonParser objectWithString:responseString error:&parserError];
    [responseString release];
    if(! parserError && [result isKindOfClass:[NSDictionary class]])
    {
        NSObject *ErrorMessage = [[result valueForKey:@"PublishNewsByPrivate"] valueForKey:@"ErrorMessage"];
        NSObject *Success = [[result valueForKey:@"PublishNewsByPrivate"] valueForKey:@"Success"];
            
        NSLog(@"%@",ErrorMessage);
        NSLog(@"%@",Success);
    }
    
    [jsonParser release];
    [self dismissModalViewControllerAnimated:NO];
    [self.delegate Step2DoPublish];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //[UserHelper DegBugWidthLog:@"requestFailed" title:@"requestFailed"];
    [self dismissModalViewControllerAnimated:NO];
    [self.delegate Step2DoPublish];
}

//-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
//{
//    //NSDictionary * dict = responseHeaders;
//    //NSLog(@"%@",request.responseData);
//}

#pragma mark - showFrends 
-(void)showFrends:(id)sender
{
    TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:friendsPicker] autorelease];
    [self presentModalViewController:nav animated:YES];
}

///////////////////////////////// SnSelectFriendsDelegate /////////////////////////////// 
- (void)didSelectFriends:(NSString*)ids names:(NSString*)names
{
    self.friendIds = ids;
    [_friendNames setTitle:names forState:UIControlStateNormal];
}


#pragma mark - showMap 
-(void)showMap:(id)sender
{
     TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:mapPicker] autorelease];
     [self presentModalViewController:nav animated:YES];
}

///////////////////////////// SnMapLocationDelegate //////////////////////////////////////////////////////////////
- (void)didSelectLocation:(CLLocation*)location adress:(NSString*)adress
{
    if(location)
    {
        coordinate = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        if(TTIsStringWithAnyText(adress))
        {
            [_address setTitle:[NSString stringWithFormat:@"%@",adress]  forState:UIControlStateNormal];
        }
        else
        {
            [_address setTitle:[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude]  forState:UIControlStateNormal];
        }
    }
}


#pragma mark - showPhotos 
/////////////////////////////////////////////////////////////////////////////////////////////
-(void)showPhotos:(id)sender
{
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        UIActionSheet *as=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"select photo", @"选择照片") 
                                                      delegate:self 
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") 
                                        destructiveButtonTitle:nil 
                                             otherButtonTitles:NSLocalizedString(@"album", @"浏览相册"), NSLocalizedString(@"camera", @"使用相机"),nil];
        as.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [as showInView:self.view];
        [as release];
    }
    else
    {
        UIActionSheet *as=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"select photo", @"选择照片") 
                                                      delegate:self 
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消") 
                                        destructiveButtonTitle:nil 
                                             otherButtonTitles:NSLocalizedString(@"album", @"浏览相册"),nil];
        as.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [as showInView:self.view];
        [as release];
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


#pragma mark - ImagePicker Delegate
/////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
    self.imageData=UIImageJPEGRepresentation(image, 0.8f);
    [_currentSelectedImage setImage:image];
    [self dismissModalViewControllerAnimated:YES];
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
    [self dismissModalViewControllerAnimated:YES];
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

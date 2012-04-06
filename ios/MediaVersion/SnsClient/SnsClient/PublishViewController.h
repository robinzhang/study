//
//  SecondViewController.h
//  SnsClient
//
//  Created by  on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnMapLocationController.h"
#import "SnSelectFriendsController.h"
#import "MainViewController.h"
#import "SnSectionedDataSource.h"
#import "SnMapLocationController.h"
#import "SnSelectFriendsController.h"
#import <extThree20JSON/extThree20JSON.h>
#import "extThree20JSON/JSON.h"
#import "ASIFormDataRequest.h"
#import "TextEditorViewController.h"
#import "SnsClientAppDelegate.h"
#import "CropImageViewController.h"

#define kPublishMaxTextCount 999
@interface PublishViewController : SnSecTableViewController<SnMapLocationDelegate,SnSelectFriendsDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate,SnTextEditorDelegate,WBSendViewDelegate,ASIProgressDelegate,SnAppWeiboDelegate,CropImageDeDelegate>
{
    UITextField *_newstitle;
    UITextField *_text;
    
    UIImagePickerController *picker_lib;
    //UIImagePickerController *picker_camera;
    CropImageViewController *_crop_Image;
    
    
    NSData* _imageData;
    UIImageView *_currentSelectedImage;
    
    SnMapLocationController *mapPicker;
    CLLocation *coordinate;
    UIButton *_address;
    
    SnSelectFriendsController *friendsPicker;
    NSString *_friendIds;
    UIButton *_friendNames;
    
    UISwitch* _switchy;
    
    UIButton *submitButton;
    UIBarButtonItem *btnSubmit;
    
    NSString *_imageUrl;
    
    TTActivityLabel *postloading;
    UIView *overlayView;
}
@property (nonatomic, retain) UITextField *text;
@property (nonatomic, retain) UITextField *newstitle;

@property(nonatomic,retain)NSData* imageData;
@property (nonatomic, copy) NSString*  friendIds;
@property (nonatomic, copy) NSString*  imageUrl;
-(void)sendToWeibo;
@end

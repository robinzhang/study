//
//  EditProfileViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol SnEditProfileDelegate
- (void)didAfterEditProfile;
@end

#import <UIKit/UIKit.h>
#import "UserHelper.h"
#import "UserProfile.h"
#import "TextEditorViewController.h"
#import "TextFieldViewController.h"
#import <extThree20JSON/extThree20JSON.h>
#import "ASIFormDataRequest.h"
#import "CropImageViewController.h"

@interface EditProfileViewController : SnSecTableViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,SnTextEditorDelegate,SnTextFieldDelegate,TTURLRequestDelegate,CropImageDeDelegate>
{
    NSString *_me;
    UserProfile *_profile;
    
    UIImagePickerController *imagePicker;
    CropImageViewController *_crop_Image;
    
    NSData* imageData;
    UIImageView *_currentSelectedImage;
    
    UILabel *namelable;
    
    UIBarButtonItem *btnSubmit;
    UIBarButtonItem *ttloading;
    id<SnEditProfileDelegate> _delegate;
}
@property(nonatomic,retain)NSData* imageData;
@property(nonatomic,assign)UserProfile* profile;
-(id)initWidthProfile:(UserProfile*)profile;
@property (nonatomic, assign) id<SnEditProfileDelegate> delegate;
@end

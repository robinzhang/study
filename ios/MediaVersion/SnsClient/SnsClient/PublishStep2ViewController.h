//
//  PublicStep2ViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol SnPublishStep2Delegate
- (void)Step2DoPublish;
- (void)Step2CancelPublish;
@end

#import <UIKit/UIKit.h>
#import "SnMapLocationController.h"
#import "SnSelectFriendsController.h"
#import <extThree20JSON/extThree20JSON.h>
#import "extThree20JSON/JSON.h"
#import "ASIFormDataRequest.h"


@interface PublishStep2ViewController : SnSecTableViewController<SnMapLocationDelegate,SnSelectFriendsDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate>
{
    id<SnPublishStep2Delegate> _delegate;
    NSString* _text;
    NSString* _newstittle;
    
    UIImagePickerController *imagePicker;
    NSData* _imageData;
    UIImageView *_currentSelectedImage;
    
    SnMapLocationController *mapPicker;
    CLLocation *coordinate;
    UIButton *_address;
    
    SnSelectFriendsController *friendsPicker;
    NSString *_friendIds;
    UIButton *_friendNames;
    
    UISwitch* _switchy;
}
@property(nonatomic,retain)NSData* imageData;
@property (nonatomic, copy) NSString*  friendIds;
@property (nonatomic, copy) NSString*  text;
@property (nonatomic, copy) NSString*  newstittle;
@property (nonatomic, assign) id<SnPublishStep2Delegate> delegate;

@end

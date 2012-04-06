//
//  ViewController.h
//  imagepicker
//
//  Created by zhan xiaoping on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  CropImageViewController;
@protocol CropImageDeDelegate<NSObject>

- (void)didAfterCropImage:(UIImage*)image width:(CGFloat)width height:(CGFloat)height croper:(CropImageViewController*)croper;
- (void)didCancelCropImage:(CropImageViewController*)croper;
@end


#import <UIKit/UIKit.h>
@interface CropImageViewController : TTViewController<UIImagePickerControllerDelegate,UIScrollViewDelegate,UINavigationControllerDelegate>
{
    UIButton *_imgview;
    UIImage *_orangeImg;
    UIScrollView *_scrollView;
    UIButton *_btn_done;
    UIButton *_btn_cancel;
    int  PHOTO_RATE;
    id<CropImageDeDelegate> _delegate;
}
-(void)StartCropImage:(UIImage*)image;
UIImage *straightenAndScaleImage(UIImage *image, int maxDimension,CGSize *newSize);
CGAffineTransform orientationTransformForImage(UIImage *image, CGSize *newSize);
@property (nonatomic, assign) id<CropImageDeDelegate> delegate;
@end


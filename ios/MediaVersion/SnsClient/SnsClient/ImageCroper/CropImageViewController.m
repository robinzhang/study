//
//  ViewController.m
//  imagepicker
//
//  Created by zhan xiaoping on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#define ZOOM_STEP 1.5
#define PHOTO_SIZE 320
#define VIEW_HEIGHT 480
#define PHOTO_TOP 65
#import "CropImageViewController.h"
@implementation CropImageViewController
@synthesize delegate = delegate;


#pragma mark - View lifecycle
-(void)initActionTools
{
    CGFloat top = VIEW_HEIGHT - 52 + 10;
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT - 52 , 320, 52)];
    [bgview setImage:[UIImage imageNamed:@"ImageCroper_tool_bg.png"]];
    [self.view addSubview:bgview];
    [bgview release];
    
    _btn_done = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_done setFrame:CGRectMake( 320 - 10 - 60  , top, 60, 30)];
    [_btn_done setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview: _btn_done];
    [_btn_done addTarget:self action:@selector(isdone) forControlEvents:UIControlEventTouchUpInside];
    
    _btn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_cancel setFrame:CGRectMake( 10 ,top, 60, 30)];
    [_btn_cancel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview: _btn_cancel];
    [_btn_cancel addTarget:self action:@selector(iscancel) forControlEvents:UIControlEventTouchUpInside];
    
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.statusBarStyle = UIStatusBarStyleBlackTranslucent;
        self.wantsFullScreenLayout = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"移动和缩放";
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];

    PHOTO_RATE = 1;

    _imgview = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imgview setFrame:CGRectMake(0, PHOTO_TOP , 320, 320)];
    [_imgview setBackgroundColor:[UIColor whiteColor]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, VIEW_HEIGHT -52 )];
    //[_scrollView setContentSize:CGSizeMake(320, 320)];
    [_scrollView setContentMode:UIViewContentModeScaleToFill];
    [_scrollView setContentInset:UIEdgeInsetsMake(PHOTO_TOP, 0,VIEW_HEIGHT - 52 - PHOTO_TOP - PHOTO_SIZE ,0)];
    _scrollView.delegate = self;
    [_scrollView addSubview:_imgview];
    
    _scrollView.bouncesZoom = YES;
    _scrollView.clipsToBounds = YES; 
    
    _scrollView.maximumZoomScale = 3.0f;
    _scrollView.minimumZoomScale = 1.0f;
    _scrollView.zoomScale = 1;
    _scrollView.bounces = NO;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];  
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];  
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];  
    
    [doubleTap setNumberOfTapsRequired:2];  
    [twoFingerTap setNumberOfTouchesRequired:2];  
    
    [_imgview addGestureRecognizer:singleTap];  
    [_imgview addGestureRecognizer:doubleTap];  
    [_imgview addGestureRecognizer:twoFingerTap];  
    
    
    [singleTap release];  
    [doubleTap release];  
    [twoFingerTap release];  
    
    
    CGFloat sw = _scrollView.frame.size.width;
    CGFloat sh = _scrollView.frame.size.height;
    _imgview.center = CGPointMake(sw /2 , sh / 2);
    
    
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView]; 
    
    //CGRect frame =  CGRectMake(0, 0, 320, 460);
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
    [bgview setImage:[UIImage imageNamed:@"ImageCroper_overlay.png"]];
    [self.view addSubview:bgview];
    [bgview release];
    
    [self initActionTools];
}
#pragma mark Utility methods  
CGAffineTransform orientationTransformForImage(UIImage *image, CGSize *newSize) {
    CGImageRef img = [image CGImage];
    CGFloat width = CGImageGetWidth(img);
    CGFloat height = CGImageGetHeight(img);
    CGSize size = CGSizeMake(width, height);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGFloat origHeight = size.height;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) { 
        case UIImageOrientationUp:
            break;
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(width, 0.0f);
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0f, height);
            transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
            break;
        case UIImageOrientationLeftMirrored:
            size.height = size.width;
            size.width = origHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            transform = CGAffineTransformRotate(transform, 3.0f * M_PI / 2.0f);
            break;
        case UIImageOrientationLeft:
            size.height = size.width;
            size.width = origHeight;
            transform = CGAffineTransformMakeTranslation(0.0f, width);
            transform = CGAffineTransformRotate(transform, 3.0f * M_PI / 2.0f);
            break;
        case UIImageOrientationRightMirrored:
            size.height = size.width;
            size.width = origHeight;
            transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0f);
            break;
        case UIImageOrientationRight:
            size.height = size.width;
            size.width = origHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0f);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0f);
            break;
        default:
            ;
    }
    *newSize = size;
    return transform;
}


- (UIImage *)cropImage:(UIImage *)image to:(CGRect)cropRect andScaleTo:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef subImage = CGImageCreateWithImageInRect([image CGImage], cropRect);
    CGRect myRect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIImageOrientation orientation = [image imageOrientation];
    if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -1.0f, 1.0f);
        CGContextTranslateCTM(context, -size.height, 0.0f);
    }
    else {
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -size.height);
    }
    
    CGContextDrawImage(context, myRect, subImage);
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(subImage);
    return croppedImage;
}


UIImage *straightenAndScaleImage(UIImage *image, int maxDimension,CGSize *newSize) {
    CGImageRef img = [image CGImage];
    CGFloat width = CGImageGetWidth(img);
    CGFloat height = CGImageGetHeight(img);
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGSize size = bounds.size;
    
    UIImageOrientation orientation = [image imageOrientation];
    if (width > maxDimension || height > maxDimension) {
        CGFloat ratio = width/height;
        if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft) {
            size.height = maxDimension;
            size.width = size.height * ratio;
        }
        else {
            size.width = maxDimension;
            size.height = size.width / ratio;
            
        }
    }
    CGFloat scale = size.width/width;
    *newSize = size;
    if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft)
        *newSize = CGSizeMake(size.height, size.width);
    
    CGAffineTransform transform = orientationTransformForImage(image, &size);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scale, scale);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scale, -scale);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, bounds, img);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //CGImageRelease(img);
    return newImage;
}




- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {  
    
    CGRect zoomRect;  
    
    // the zoom rect is in the content view's coordinates.   
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.  
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.  
    zoomRect.size.height = [_scrollView frame].size.height / scale;  
    zoomRect.size.width  = [_scrollView frame].size.width  / scale;  
    
    // choose an origin so as to get the right center.  
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);  
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);  
    
    return zoomRect;  
}  



#pragma mark - actions
-(void)setImagePosition
{
    CGFloat iw = _imgview.frame.size.width;
    CGFloat ih = _imgview.frame.size.height;
    int top = 0;
    int left = 0;
    
    if(PHOTO_SIZE > iw)
        left = (PHOTO_SIZE - iw)/2;
    
    if(PHOTO_SIZE > ih)
        top = (PHOTO_SIZE - ih)/2;
    
    [_imgview setFrame:CGRectMake(left, top, iw, ih)];
}

-(void)setThisImage:(UIImage*)rotatedImage size:(CGSize)size
{
    // reset _scrollView zoom
    CGRect zoomRect = [self zoomRectForScale:1.0f withCenter:_imgview.center];
    [_scrollView zoomToRect:zoomRect animated:NO]; 
    _orangeImg = [rotatedImage retain];
    
    // set image button
    [_imgview setImage: rotatedImage forState:UIControlStateNormal];
    [_imgview setImage: rotatedImage forState:UIControlStateHighlighted];
    [_imgview setImage: rotatedImage forState:UIControlStateSelected];

    [_imgview setFrame:CGRectMake(0, 0, size.width, size.height)];
    [self setImagePosition];
    
    // reset 
    CGRect zoomRect1 = [self zoomRectForScale:1.01f withCenter:_imgview.center];  
    [_scrollView zoomToRect:zoomRect1 animated:YES]; 
}

-(void)isdone
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CGPoint p = _scrollView.contentOffset;
    CGFloat s = [_scrollView zoomScale];
    
    CGFloat y= p.y- _imgview.frame.origin.y + PHOTO_TOP;
    CGFloat x= p.x- _imgview.frame.origin.x ;
    if(y < 0)
        y = 0;
    if(x<0)
        x = 0;
    
    x = x*PHOTO_RATE;
    y = y*PHOTO_RATE;
    
    CGFloat targetsize = PHOTO_SIZE * PHOTO_RATE;
    CGFloat imgh = _imgview.frame.size.height * PHOTO_RATE;
    CGFloat imgw = _imgview.frame.size.width * PHOTO_RATE;
    CGFloat newimgh = targetsize;
    CGFloat newimgw = targetsize;
    
    CGFloat h = imgh - y;
    CGFloat w = imgw - x;
    if (h < targetsize)
    {
        newimgh = h;
    }
    
    if (w < targetsize)
    {
        newimgw = w;
    }
    
    CGRect rect = CGRectMake(x/s, y/s, newimgw /s, newimgh/s);
    CGSize newsize = CGSizeMake( newimgw, newimgh);
    UIImage *rotatedImage = [self cropImage:_orangeImg to:rect andScaleTo:newsize];
    
    //_orangeImg = rotatedImage;
    
    //[self setImage:rotatedImage];
    
    if ([self.delegate respondsToSelector:@selector(didAfterCropImage:width:height:croper:)])
        [self.delegate didAfterCropImage:rotatedImage  width:newimgw height:newimgh croper:self];
    
    [pool drain];
}

-(void)iscancel
{
    if ([self.delegate respondsToSelector:@selector(didCancelCropImage:)])
        [self.delegate didCancelCropImage:self];
}

-(void)StartCropImage:(UIImage*)image
{

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CGSize newSize;
    CGFloat scale_to_width = PHOTO_SIZE * PHOTO_RATE;
    
    UIImage *mrotatedImage = straightenAndScaleImage(image, scale_to_width,&newSize);

    CGFloat snewweight = scale_to_width;
    CGFloat snewheight = (scale_to_width / newSize.width )*newSize.height;

    UIImage *rotatedImage = [self cropImage:mrotatedImage to:CGRectMake(0, 0, newSize.width , newSize.height) andScaleTo:CGSizeMake(snewweight, snewheight)];
    
    [self setThisImage:rotatedImage size:CGSizeMake(snewweight, snewheight)];
    [pool drain];
}
#pragma mark UIScrollViewDelegate methods  
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {  
    return _imgview;  
}  

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [self setImagePosition];
}
#pragma mark TapDetectingImageViewDelegate methods  

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
    
}  

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {  
    // zoom in  
    float newScale = [_scrollView zoomScale] * ZOOM_STEP;  
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];  
    [_scrollView zoomToRect:zoomRect animated:YES];  
    
}  

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {  
    // two-finger tap zooms out  
    float newScale = [_scrollView zoomScale] / ZOOM_STEP;  
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];  
    
    [_scrollView zoomToRect:zoomRect animated:YES];  
}  
#pragma mark - view
- (void)didReceiveMemoryWarning
{

}

-(void)setView:(UIView *)view
{
    if(!view)
        return;
    
    [super setView:view];
}

- (void)viewDidUnload
{
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end

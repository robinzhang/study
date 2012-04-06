//
//  DetailImageViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#define ZOOM_STEP 1.5  
#import "DetailImageViewController.h"

@implementation DetailImageViewController
@synthesize  imageView = imageView;
@synthesize imageScrollView = imageScrollView;

-(id)initWithTitle:(NSString*)title  imgpath:(NSString*)imgpath
{   
	self = [super initWithNibName:nil bundle:nil];
    if (self) 
	{
		self.title = title;
        
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style: UIBarButtonItemStyleDone target: self action: @selector(done)];

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"Close") style: UIBarButtonItemStyleBordered target: self action: @selector(docancel)];

        imageView = [[TTImageView  alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [imageView setUrlPath:imgpath];
        imageView.userInteractionEnabled = YES;  
        imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth );  
        
        imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        imageScrollView.delegate = self;
        [imageScrollView addSubview:imageView];

        imageScrollView.bouncesZoom = YES;
        imageScrollView.clipsToBounds = YES; 
        
        imageScrollView.maximumZoomScale = 3.0f;
        imageScrollView.minimumZoomScale = 0.3f;
        imageScrollView.zoomScale = 1;
        imageScrollView.bounces = NO;
        
        //imageScrollView.contentSize = [imageView frame].size;  
        
        // add gesture recognizers to the image view  
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];  
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];  
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];  
        
        [doubleTap setNumberOfTapsRequired:2];  
        [twoFingerTap setNumberOfTouchesRequired:2];  
        
        [imageView addGestureRecognizer:singleTap];  
        [imageView addGestureRecognizer:doubleTap];  
        [imageView addGestureRecognizer:twoFingerTap];  
        
        
        [singleTap release];  
        [doubleTap release];  
        [twoFingerTap release];  
        
        //[imageScrollView setBackgroundColor:[UIColor redColor]];
        
        CGFloat sw = imageScrollView.width;
        CGFloat sh = imageScrollView.height;
        imageView.center = CGPointMake(sw /2 , sh / 2);
        [self.view addSubview:imageScrollView];

        //self.navigationBarTintColor = RGBCOLOR(0, 0, 0);
        [self.view setBackgroundColor:RGBCOLOR(0, 0, 0)];
        
        self.statusBarStyle = UIStatusBarStyleBlackTranslucent;
        self.navigationBarStyle = UIBarStyleBlackTranslucent;
        self.navigationBarTintColor = nil;
        self.wantsFullScreenLayout = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect frame = self.view.bounds;
    [imageScrollView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatAutoreverses:NO];
    CGRect frame = self.view.bounds;
    [imageScrollView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    CGFloat sw = imageScrollView.width;
    CGFloat sh = imageScrollView.height;
    imageView.center = CGPointMake(sw /2 , sh / 2);
    [UIView commitAnimations];
}


#pragma mark Utility methods  

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {  
    
    CGRect zoomRect;  
    
    // the zoom rect is in the content view's coordinates.   
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.  
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.  
    zoomRect.size.height = [imageScrollView frame].size.height / scale;  
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;  
    
    // choose an origin so as to get the right center.  
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);  
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);  
    
    return zoomRect;  
}  

#pragma mark UIScrollViewDelegate methods  

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {  
    return imageView;  
}  

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isShowingChrome {
    UINavigationBar* bar = self.navigationController.navigationBar;
    return bar ? bar.alpha != 0 : 1;
}



- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    CGFloat sw = imageScrollView.width;
    CGFloat sh = imageScrollView.height;
    CGFloat iw = imageView.width;
    CGFloat ih = imageView.height;
    int top = 0;
    int left = 0;
    if(sw > iw)
        left = (sw - iw )/2;
    if(sh > ih)
        top = (sh - ih)/2;
    
    imageView.left = left;
    imageView.top = top;
}

#pragma mark TapDetectingImageViewDelegate methods  

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
    // single tap does nothing for now  
    if ([self isShowingChrome]) {
        [self showBars:NO animated:YES];
        
    } else {
        [self showBars:YES animated:NO];
    }
}  

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {  
    // zoom in  
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;  
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];  
    [imageScrollView zoomToRect:zoomRect animated:YES];  
    
}  

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {  
    // two-finger tap zooms out  
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;  
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];  
    [imageScrollView zoomToRect:zoomRect animated:YES];  
}  


-(void)done
{
    //UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, nil);
    UIImageWriteToSavedPhotosAlbum( imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil );
    self.navigationItem.rightBarButtonItem.enabled = NO;

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        
        [UserHelper doAlert:self title:@"图片保存失败，请重试!"  message:nil]; //[error description]];
                                                                
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"图片保存成功!" 
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Done", @"确定") 
                                          otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

    self.navigationItem.rightBarButtonItem.enabled = YES;
}




-(void)docancel
{
	[self dismissModalViewControllerAnimated:YES];
}


-(void)dealloc
{
    [imageView release];
    [imageScrollView release];
	[super dealloc];
}

@end

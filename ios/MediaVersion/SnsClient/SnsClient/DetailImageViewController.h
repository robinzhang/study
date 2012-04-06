//
//  DetailImageViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailImageViewController :  TTViewController<UIScrollViewDelegate,UIAlertViewDelegate>
{
    TTImageView *imageView;
    UIScrollView* imageScrollView;
}
@property(nonatomic,retain)TTImageView* imageView;
@property(nonatomic,retain)UIScrollView* imageScrollView;
-(id)initWithTitle:(NSString*)title  imgpath:(NSString*)imgpath;
@end

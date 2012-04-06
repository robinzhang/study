//
//  UserGuideController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface UserGuideController : TTViewController <TTScrollViewDataSource, TTScrollViewDelegate> 
{
    TTScrollView* _scrollView;
    TTPageControl* _pageControl;
}
@end

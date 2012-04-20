//
//  waterFlowAppDelegate.h
//  waterFlow
//
//  Created by kindy_imac on 12-2-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class waterFlowViewController;

@interface waterFlowAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    waterFlowViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet waterFlowViewController *viewController;

@end


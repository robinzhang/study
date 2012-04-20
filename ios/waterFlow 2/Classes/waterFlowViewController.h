//
//  waterFlowViewController.h
//  waterFlow
//
//  Created by kindy_imac on 12-2-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLWaterFlowView.h"

@interface waterFlowViewController : UIViewController<LLWaterFlowViewDelegate, UIScrollViewDelegate> {
	
	int _nCount ;

	LLWaterFlowView *flowView ;
}


- (void)press;

@end


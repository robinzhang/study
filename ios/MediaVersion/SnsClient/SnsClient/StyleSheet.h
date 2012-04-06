//
//  StyleSheet.h
//  SnsClient
//
//  Created by  on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20Style/TTDefaultStyleSheet.h> 
#import <Three20Style/TTDefaultStyleSheet+DragRefreshHeader.h>

@interface StyleSheet : TTDefaultStyleSheet

- (TTStyle*)toolbarButtonForState:(UIControlState)state shape:(TTShape*)shape
                        tintColor:(UIColor*)tintColor font:(UIFont*)font padding:(UIEdgeInsets)padding;
@end

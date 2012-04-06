//
//  SnTableControlItemCell.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnTableControlItemCell.h"

@implementation SnTableControlItemCell

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self.textLabel setTextColor:[UIColor blackColor]];
    self.textLabel.width = 70;
    [self.textLabel  setTextAlignment:UITextAlignmentRight];
    
    
    if([self.control isKindOfClass:[UISwitch class]])
    {
        
    }
    else
    {
        int l = self.control.frame.origin.x;
        int fl = 92 - l;
        self.control.left += fl;
        self.control.width -= fl;
    }
}

@end

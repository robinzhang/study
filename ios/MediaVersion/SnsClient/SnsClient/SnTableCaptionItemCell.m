//
//  SnTableCaptionItem.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnTableCaptionItemCell.h"

@implementation SnTableCaptionItemCell
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self.textLabel setTextColor:[UIColor blackColor]];
    //self.textLabel.top += 2;
    
}
@end

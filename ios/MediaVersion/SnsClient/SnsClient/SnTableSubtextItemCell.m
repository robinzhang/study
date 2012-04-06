//
//  SnTableSubtextItemCell.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnTableSubtextItemCell.h"


@implementation SnTableSubtextItemCell
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
//    CGFloat   kTableCellMargin      = 10;
//    CGFloat   kTableCellHPadding    = 10;
//    
//    TTTableSubtextItem* item = object;
//    
//    CGFloat width = tableView.width - [tableView tableCellMargin]*2 - kTableCellHPadding*2;
//    
//    CGSize detailTextSize = [item.text sizeWithFont:TTSTYLEVAR(tableFont)
//                                  constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
//                                      lineBreakMode:UILineBreakModeTailTruncation];
//    
//    CGSize textSize = [item.caption sizeWithFont:TTSTYLEVAR(font)
//                               constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
//                                   lineBreakMode:UILineBreakModeWordWrap];
//    
//    return kTableCellMargin +  kTableCellVPadding*2 + detailTextSize.height + textSize.height;
//}

@end

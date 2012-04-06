//
//  SnTableNoDataItemCell.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnTableNoDataItemCell.h"

@implementation SnTableNoDataItemCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if (self = [super initWithStyle:style reuseIdentifier:identifier]) 
    {
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        
        //
        UIImageView *img = [[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://nodata_bg.png")];
        [img setFrame:CGRectMake(10, 10, 281, 154)];
        //self.backgroundView = img;
        [self.contentView addSubview:img];
        [img release];
        
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView bringSubviewToFront:self.textLabel];
    [self.textLabel setFrame:CGRectMake(60, 80, 200, 45)];
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    [self.textLabel setFont:[UIFont systemFontOfSize:14]];
    [self.textLabel setTextColor:[UIColor grayColor]];
    [self.textLabel setShadowColor:[UIColor whiteColor]];
    [self.textLabel setShadowOffset:CGSizeMake(0, 1)];
    [self.textLabel setTextAlignment:UITextAlignmentCenter];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 164;
}
@end

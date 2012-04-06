//
//  SnTableSelectItemCell.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnTableSelectItemCell.h"
#define kthisHeight 63
@implementation SnTableSelectItemCell
@synthesize checked =_checked;
- (void)layoutSubviews
{
	[super layoutSubviews];
    if(self.checked == YES)
    {
        [self.checkButton setFrame:CGRectMake(270, 23, 28, 23)];
    }
    else
    {
       [self.checkButton setFrame:CGRectMake(320, 23, 28, 23)];
    }
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    self.detailTextLabel.top -= 8;
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.timestampLabel setTextColor:self.detailTextLabel.textColor];
    [self.titleLabel setTextColor:self.detailTextLabel.textColor];
    
    [self.detailTextLabel setFrame:CGRectMake(self.titleLabel.left, 30, 230, 35)];
    self.detailTextLabel.lineBreakMode = UILineBreakModeClip;
    self.detailTextLabel.font = [UIFont  systemFontOfSize:12];
    self.detailTextLabel.numberOfLines = 10;
    CGSize size = CGSizeMake(230, 200);
    CGSize labelSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font 
                                             constrainedToSize:size
                                                 lineBreakMode:UILineBreakModeClip];
    [self.detailTextLabel setFrame:CGRectMake(self.titleLabel.left, 30, 230, labelSize.height)];
    [self.timestampLabel setFont:[UIFont systemFontOfSize:12]];
    
    self.borderView.top = self.contentView.size.height - 2;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    TTTableMessageItem* item = object;
    
    CGFloat height = TTSTYLEVAR(tableFont).ttLineHeight + kTableCellVPadding*2;
    if (item.text) {
        //     height += TTSTYLEVAR(font).ttLineHeight;
        UIFont* font =[UIFont systemFontOfSize:12];
        CGSize size = [item.text sizeWithFont:font
                            constrainedToSize:CGSizeMake(230, 200)
                                lineBreakMode:UILineBreakModeClip];
        height += size.height;
    }
    
    if(height<kthisHeight)
        height = kthisHeight;
    
    return height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImageView*)usertype {
    if (!_usertype) {
        _usertype = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 14, 14)];
        [_usertype setImage:TTIMAGE(@"bundle://icon-m.png")];
        [self.contentView addSubview:_usertype];
    }
    return _usertype;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if (self = [super initWithStyle:style reuseIdentifier:identifier]) 
    {
        self.titleLabel.shadowColor = [UIColor whiteColor];
        self.titleLabel.shadowOffset = CGSizeMake(0, 1.0);
        
        self.detailTextLabel.shadowColor = [UIColor whiteColor];
        self.detailTextLabel.shadowOffset = CGSizeMake(0, 1.0);
        
        self.timestampLabel.shadowColor = [UIColor whiteColor];
        self.timestampLabel.shadowOffset = CGSizeMake(0, 1.0);
        
        [self.borderView setFrame:CGRectMake(0, kthisHeight-3, 320, 2)];
        
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)borderView {
    if (!_borderView) {
        CGFloat w = 320;
        CGFloat h = kthisHeight;
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, h-3, w, 2)];
        UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 1)];
        [v1 setBackgroundColor:RGBCOLOR(148, 148, 148)];
        UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, w, 1)];
        [v2 setBackgroundColor:RGBCOLOR(255, 255, 255)];
        [_borderView addSubview:v1];
        [_borderView addSubview:v2];
        [v1 release];
        [v2 release];
        [self.contentView addSubview:_borderView];
    }
    return _borderView;
}

- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        SnTableSelectItem* item = (SnTableSelectItem*)object;
        self.checked = item.selected;
        
        
        if(item.UserType == 16)
            [self.usertype setFrame:CGRectMake(38, 38, 14, 14)];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    [self.checkButton setFrame:CGRectMake(320, 23, 28, 23)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImageView*)checkButton {
    if (!_checkButton) {
        _checkButton = [[UIImageView alloc] init];
        _checkButton.frame = CGRectMake(320, 23, 28, 23);
        [_checkButton setBackgroundColor:[UIColor clearColor]];
        [_checkButton setImage:TTIMAGE(@"bundle://appoint_tick.png")];
        [self.contentView addSubview:_checkButton];
    }
    return _checkButton;
}

-(void)checkAction
{
    if(self.checked == YES)
        self.checked = NO;
    else
        self.checked = YES; 
    [self layoutSubviews];
}

- (void)dealloc
{
    [_checkButton release];
    [super dealloc];
}
@end

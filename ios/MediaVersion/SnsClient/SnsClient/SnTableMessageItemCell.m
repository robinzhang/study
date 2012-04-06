//
//  SnTableMessageItemCell.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnTableMessageItemCell.h"
#define kthisHeight 77

@implementation SnTableMessageItemCell

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
//        TTView *_backgroundView=[[TTView alloc] init];
//        _backgroundView.style= [TTSolidFillStyle styleWithColor:RGBCOLOR(228, 229, 222) next:
//                               [TTFourBorderStyle styleWithTop:RGBCOLOR(247, 247, 245) right:nil bottom:RGBCOLOR(119, 119, 116) left:nil width:1 next:nil]];
//        
//        [self setBackgroundView:_backgroundView];
        
        self.detailTextLabel.textAlignment = UITextAlignmentLeft;
        self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.detailTextLabel.adjustsFontSizeToFitWidth = NO;
        self.detailTextLabel.contentMode = UIViewContentModeLeft;        
    }
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)borderView {
    if (!_borderView) {
        CGFloat w = 320;
        CGFloat h = kthisHeight;
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, h-3, w, 2)];
        UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 1)];
        [v1 setBackgroundColor:RGBCOLOR(119, 119, 116)];
        UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, w, 1)];
        [v2 setBackgroundColor:RGBCOLOR(247, 247, 245)];
        [_borderView addSubview:v1];
        [_borderView addSubview:v2];
        [v1 release];
        [v2 release];
        [self.contentView addSubview:_borderView];
    }
    return _borderView;
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImageView*)picIcon {
    if (!_picIcon) {
        _picIcon = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 15, 13)];
        [_picIcon setImage:TTIMAGE(@"bundle://icn-pics.png")];
        [self.contentView addSubview:_picIcon];
    }
    return _picIcon;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    TTTableMessageItem* item = object;
    
    CGFloat height = TTSTYLEVAR(tableFont).ttLineHeight + kTableCellVPadding*2 + 8;
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
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.titleLabel.left = self.imageView2.right + 10;
    
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    
    [self.timestampLabel setTextColor:self.detailTextLabel.textColor];
    [self.titleLabel setTextColor:self.detailTextLabel.textColor];
    
    int title_t = 8;
    int detail_t = 40;
    if(TTIsStringWithAnyText(self.captionLabel.text)){
        detail_t = 28;
        title_t = 5;
        [self.captionLabel setFont:[UIFont systemFontOfSize:12]];
        [self.captionLabel setBackgroundColor:[UIColor clearColor]];
        [self.captionLabel setTextColor:self.detailTextLabel.textColor];
        
        [self.captionLabel setFrame:CGRectMake(self.titleLabel.left , 33, 230, 35)];
    }

    
    self.titleLabel.top += title_t;
    
    [self.detailTextLabel setFrame:CGRectMake(self.titleLabel.left , detail_t, 230, 35)];
    self.detailTextLabel.lineBreakMode = UILineBreakModeClip;
    self.detailTextLabel.font = [UIFont  systemFontOfSize:12];
    self.detailTextLabel.numberOfLines = 10;
    CGSize size = CGSizeMake(230, 200);
    CGSize labelSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font 
                                             constrainedToSize:size
                                                 lineBreakMode:UILineBreakModeClip];
    [self.detailTextLabel setFrame:CGRectMake(self.titleLabel.left , detail_t, 230, labelSize.height)];
    [self.timestampLabel setFont:[UIFont systemFontOfSize:12]];
    self.imageView2.top += 8;
    self.borderView.top = self.contentView.size.height - 2;
}

-(void)setObject:(id)object
{
    [super setObject:object];
    SnTableMessageItem *item= (SnTableMessageItem*)object;
    if(item.UserType == 16)
        [self.usertype setFrame:CGRectMake(38, 45, 14, 14)];
    if(item.PicFlag == 1)
        [self.picIcon setFrame:CGRectMake(320-50, 40, 15, 13)];
    
//    if(TTIsStringWithAnyText( item.commentCount))
//    {
//        [self.commentCountButton setTitle:item.commentCount forState:UIControlStateNormal];
//        [self.commentCountButton setFrame:CGRectMake(320-80, 40, 80, 13)];
//    }
//    
//    if(TTIsStringWithAnyText( item.viewcount))
//    {
//        [self.viewCountButton setTitle:item.viewcount forState:UIControlStateNormal];
//        if(TTIsStringWithAnyText( item.commentCount))
//            [self.commentCountButton setFrame:CGRectMake(320-130, 40, 80, 13)];
//    }
    
    if(item.timestamp)
        [self.timestampLabel setText:[item.timestamp formatRelativeTime]];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (MinViewCountButton*)viewCountButton {
//    if (!_viewCountButton) {
//        _viewCountButton = [[MinViewCountButton alloc] initWithFrame:CGRectMake(320, 0, 14, 14)];
//        [self.contentView addSubview:_viewCountButton];
//    }
//    return _viewCountButton;
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (MinCommentCountButton*)commentCountButton {
//    if (!_commentCountButton) {
//        _commentCountButton = [[MinCommentCountButton alloc] initWithFrame:CGRectMake(320, 0, 14, 14)];
//        [self.contentView addSubview:_commentCountButton];
//    }
//    return _commentCountButton;
//}


-(void)prepareForReuse
{
    [super prepareForReuse];
    [self.usertype setFrame:CGRectMake(320, 40, 14, 14)];
    [self.picIcon setFrame:CGRectMake(320, 40, 15, 13)];
    //[self.viewCountButton setTitle:@"" forState:UIControlStateNormal];
    //[self.commentCountButton setTitle:@"" forState:UIControlStateNormal];
    //[self.viewCountButton setFrame:CGRectMake(320, 40, 14, 14)];
    //[self.commentCountButton setFrame:CGRectMake(320, 40, 14, 14)];
    [self.detailTextLabel setText:@""];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
//    return kthisHeight;
//}

@end

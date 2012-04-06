//
//  SnTableMessageItemCell.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MinViewCountButton.h"
#import "MinCommentCountButton.h"

@interface SnTableMessageItemCell : TTTableMessageItemCell
{
    UIView *_borderView;
    UIImageView *_usertype;
    UIImageView *_picIcon;
    //MinViewCountButton *_viewCountButton;
    //MinCommentCountButton *_commentCountButton;
}
//@property (nonatomic, readonly, retain) MinCommentCountButton* commentCountButton;
//@property (nonatomic, readonly, retain) MinViewCountButton* viewCountButton;
@property (nonatomic, readonly, retain) UIView* borderView;
@property (nonatomic, readonly, retain) UIImageView* usertype;
@property (nonatomic, readonly, retain) UIImageView* picIcon;
@end

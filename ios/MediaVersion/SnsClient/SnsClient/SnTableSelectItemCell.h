//
//  SnTableSelectItemCell.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnTableSelectItem.h"

@interface SnTableSelectItemCell : TTTableMessageItemCell
{
   UIImageView *_checkButton;
    bool _checked;
    UIView *_borderView;
    UIImageView *_usertype;
}
@property (nonatomic, readonly, retain)  UIImageView *checkButton;
@property (nonatomic, assign)  bool checked;
@property (nonatomic, readonly, retain) UIView* borderView;
@property (nonatomic, readonly, retain) UIImageView* usertype;
-(void)checkAction;
@end

//
//  SnInfoView.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnInfoView.h"

@implementation SnInfoView
-(id)initWithFrame:(CGRect)frame msg:(NSString*)msg
{
    
    self = [super initWithFrame:frame];
    if(self)
    {
        //////// -----  _nodataView ////
        //_nodataView = [[UIView alloc] initWithFrame:CGRectMake(80, 80, 160, 80)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *innerBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [innerBg setBackgroundColor:[UIColor blackColor]];
        innerBg.layer.masksToBounds = YES;  
        innerBg.layer.cornerRadius = 10;  
        [innerBg  setAlpha:0.5f];
        [self addSubview:innerBg];
        
        UILabel *label = [[UILabel alloc] init];
        [label setText:msg];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
        label.numberOfLines = 5;
        [label setTextAlignment:UITextAlignmentCenter];
        [label setFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:label];
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setFrame:innerBg.frame];
//        [btn setBackgroundColor:[UIColor clearColor]];
//        [btn addTarget:self action:@selector(doSearchBeiJing) forControlEvents:UIControlEventTouchUpInside];
//        [_nodataView addSubview:btn];
        
        [innerBg release];
        [label release];
        ////// -----  _nodataView ///////
    }
    return  self;
}

@end

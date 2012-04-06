//
//  MessageMapAnnotationView.h
//  Kanguo
//
//  Created by zhou fangyu on 11-9-8.
//  Copyright 2011年 no. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnMessage.h"


@interface MessageMapAnnotationView : UIView{
    TTImageView* avator;
    UILabel* userNickName;
    UILabel* messageBody;
    UILabel* createDate;
    UILabel* commentCount;
    
    SnMessage* _post;
    
}

@property (nonatomic,retain) SnMessage* post;

- (id)initWithPost:(SnMessage*)post;

@end

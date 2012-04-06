//
//  MessageMapAnnotationView.m
//  Kanguo
//
//  Created by zhou fangyu on 11-9-8.
//  Copyright 2011年 no. All rights reserved.
//

#import "MessageMapAnnotationView.h"

@implementation MessageMapAnnotationView
@synthesize post=_post;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

- (id)initWithPost:(SnMessage*)post{
    self=[super init];
    
    if (self) {
        _post=post;
        
        CGRect avatorFrame={{5, 5}, {40, 40}};
        CGRect nickFrame={{50, 3}, {200, 22}};
        CGRect bodyFrame={{50, 25}, {200, 22}};
        CGRect commentCountFrame={{0, 0}, {0, 0}};
        CGRect createDateFrame={{0, 0}, {0, 0}};
        
        avator = [[TTImageView alloc] init];
        avator.frame=avatorFrame;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserProfile)];
        [avator addGestureRecognizer:tap];
        [tap release];
        [avator setUrlPath:[NSString stringWithFormat:@"%@_80_80.jpg", post.UserFace]];
        
        
        userNickName=[[UILabel alloc] initWithFrame:nickFrame];
        userNickName.text=post.UserName;
        userNickName.backgroundColor=[UIColor clearColor];
        userNickName.font = [UIFont boldSystemFontOfSize:14];
        userNickName.textColor =[UIColor whiteColor];
        userNickName.contentMode = UIViewContentModeTop;
        userNickName.lineBreakMode = UILineBreakModeTailTruncation;
        userNickName.numberOfLines = 1;
        
        messageBody=[[UILabel alloc] initWithFrame:bodyFrame];
        messageBody.text=post.MessageBody;
        messageBody.backgroundColor=[UIColor clearColor];
        messageBody.font = TTSTYLEVAR(font);
        messageBody.textColor = RGBCOLOR(200, 200, 200);
        messageBody.contentMode = UIViewContentModeTop;
        messageBody.lineBreakMode = UILineBreakModeTailTruncation;
        messageBody.numberOfLines = 3;
        
        
        createDate=[[UILabel alloc] initWithFrame:createDateFrame];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
        createDate.text=[dateFormatter stringFromDate:post.PublicDate];
        [dateFormatter release];
        createDate.backgroundColor=[UIColor clearColor];
        createDate.font = [UIFont systemFontOfSize:12];
        //[createDate sizeToFit];
        createDate.textColor = RGBCOLOR(233, 233, 233);;
        createDate.contentMode = UIViewContentModeTop;
        createDate.lineBreakMode = UILineBreakModeTailTruncation;
        createDate.numberOfLines = 1;
        
        commentCount=[[UILabel alloc] initWithFrame:commentCountFrame];
        commentCount.text=[NSString stringWithFormat:@"回复:%d",post.CommentCount];
        commentCount.backgroundColor=[UIColor clearColor];
        commentCount.font = TTSTYLEVAR(font);
        commentCount.textColor = RGBCOLOR(233, 233, 233);;
        commentCount.contentMode = UIViewContentModeTop;
        commentCount.lineBreakMode = UILineBreakModeTailTruncation;
        commentCount.numberOfLines = 1;
        
        [self addSubview:avator];
        [self addSubview:userNickName];
        [self addSubview:messageBody];
        [self addSubview:createDate];
        [self addSubview:commentCount];
        
        return self;
    }
    
    return nil;
}

- (void)dealloc{
    [super dealloc];
    TT_RELEASE_SAFELY(avator);
    TT_RELEASE_SAFELY(userNickName);
    TT_RELEASE_SAFELY(createDate);
    TT_RELEASE_SAFELY(commentCount);
    TT_RELEASE_SAFELY(messageBody);
}

- (void)gotoUserProfile{
    TTOpenURL([NSString stringWithFormat:@"tt://uprofile/%@",self.post.UserID]);
}

- (void)layoutSubviews{
    
    
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

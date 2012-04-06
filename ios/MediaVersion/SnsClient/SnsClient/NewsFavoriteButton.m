//
//  FavoriteButton.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewsFavoriteButton.h"
#define imagePath_no   @"bundle://tab_collection.png"
#define imagePath_se   @"bundle://tab_collection_se.png"
#define imagePath_de   @"bundle://tab_collection_de.png"
@implementation NewsFavoriteButton
@synthesize myUserId=_myUserId,muserid=_muserid,messageid = _messageid;
- (void)checkStatus{
    [imgv setImage:TTIMAGE(imagePath_de)];
//    if([self.myUserId isEqualToString:self.muserid])
//    {
//        //[UserHelper doAlert:self title:@"操作提示" message:@"不能收藏自己发布的新闻哦！"];
//        return;
//    }
    
    if(!userUtil)
    {
        userUtil = [[NewsFavoriteHelper alloc] init];
        userUtil.delegate = self;
    }
    [userUtil checkFavorite:self.myUserId muserid:self.muserid messgeid:self.messageid];
}


- (void)onClick{
    if(!userUtil)
    {
        userUtil = [[NewsFavoriteHelper alloc] init];
        userUtil.delegate = self;
    }
    self.enabled = NO;
    switch (self.tag) {
        case 0:
            [userUtil addFavorite:self.myUserId muserid:self.muserid messgeid:self.messageid];
            break;
        case 1:
            [userUtil delFavorite:self.myUserId muserid:self.muserid messgeid:self.messageid];
            break;
        default:
            break;
    }
    [self checkStatus];
}

- (void)CheckNewsFavoriteSuccess:(int)tag{
    self.tag=tag;
    switch (tag) {
        case 0: 
            [imgv setImage:TTIMAGE(imagePath_no)];
            break;
        case 1:
            [imgv setImage:TTIMAGE(imagePath_se)];
            break;
        default:
            [imgv setImage:TTIMAGE(imagePath_de)];
            break;
    }
    self.enabled = YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithUserid:(NSString*)userid muserid:(NSString*)muserid messageid:(NSString*)messageid
{
    self = [super init];
    if (self) {
        self.myUserId=userid;
        self.muserid=muserid;
        self.messageid=messageid;
        
        userUtil = [[NewsFavoriteHelper alloc] init];
        userUtil.delegate = self;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFrame:CGRectMake(0, 0, 60, 40)];
        
        imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 26, 26)];
      
        //if([userid isEqualToString:muserid])
        //    [imgv setImage:TTIMAGE(imagePath_de)];
        //else
        //{
            [imgv setImage:TTIMAGE(imagePath_no)];
            [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        //}
        [self addSubview:imgv];
        
        lble = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, 60, 14)];
        [lble setText:@"收藏"];
        [lble setFont:[UIFont systemFontOfSize:12]];
        [lble setBackgroundColor:[UIColor clearColor]];
        [lble setTextAlignment:UITextAlignmentCenter];
        [lble setTextColor:[UIColor whiteColor]];
        [self addSubview:lble];
    }
    return self;
}

-(void)dealloc
{
    //[imgv release];
    //[lble release];
    //[userUtil release];
    [super dealloc];
}
@end

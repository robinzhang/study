//
//  FavoriteButton.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFavoriteHelper.h"

@interface NewsFavoriteButton : UIButton<NewsFavoriteHelperDelegate>
{
    NSString* _myUserId;
    NSString* _messageid;
    NSString* _muserid;
    NSString* _title;
    NewsFavoriteHelper *userUtil;
    UIImageView *imgv;
    UILabel *lble;
}
@property (nonatomic,retain)  NSString* myUserId;
@property (nonatomic,retain) NSString* messageid;
@property (nonatomic,retain) NSString* muserid;
-(void)checkStatus;
-(id)initWithUserid:(NSString*)userid muserid:(NSString*)muserid messageid:(NSString*)messageid;
@end

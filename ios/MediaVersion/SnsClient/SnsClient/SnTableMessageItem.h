//
//  SnTableMessageItem.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnTableMessageItem : TTTableMessageItem
{
    int _UserType;
    int _PicFlag;
    NSString * _viewcount;
    NSString * _commentCount;
}
@property (nonatomic,copy) NSString *viewcount;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,assign) int UserType;
@property (nonatomic,assign) int PicFlag;
@end

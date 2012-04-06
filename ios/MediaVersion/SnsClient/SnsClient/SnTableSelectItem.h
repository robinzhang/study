//
//  SnTableSelectItem.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnTableSelectItem : TTTableMessageItem
{
    bool _selected;
    NSString * _userid;
    int _UserType;
}
@property (nonatomic,assign) int UserType;
@property (nonatomic , assign) bool selected;
@property (nonatomic , assign) NSString* userid;
@end

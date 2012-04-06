//
//  MessageVisterController.h
//  Kanguo
//
//  Created by zhan xiaoping on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageVisterDataSource.h"
#import "NewsDetailObject.h"

@interface MessageVisterController : SnTableViewController
{
    NSString *_messageid;
    NSString *_userid;
    NSString *_me;
}
@property (nonatomic, retain) NSString* messageid;
@property (nonatomic, retain) NSString* userid;
@property (nonatomic, retain) NSString* me;
-(id)initWidthMessage:(NewsDetailObject*)message;
@end

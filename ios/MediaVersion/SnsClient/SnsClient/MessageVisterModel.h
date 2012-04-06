//
//  MessageVisterModel.h
//  Kanguo
//
//  Created by zhan xiaoping on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"

@interface MessageVisterModel  : TTURLRequestModel
{
    NSString* _userid;
    NSString* _messageid;
    NSMutableArray*  _posts;
    NSUInteger _page;             
    NSUInteger _resultsPerPage;  
    BOOL _finished;
    
    CLLocation* _location;
    
}
@property (nonatomic, assign)   CLLocation* location;
@property (nonatomic, copy)     NSString* userid;
@property (nonatomic, copy)     NSString* messageid;
@property (nonatomic, readonly) NSMutableArray* posts;
@property (nonatomic, assign)   NSUInteger    resultsPerPage;
@property (nonatomic, readonly) BOOL          finished;

- (id)initWithQuery:(NSString*)userid messageid:(NSString*)messageid;
@end

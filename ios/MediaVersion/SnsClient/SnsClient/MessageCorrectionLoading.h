//
//  MessageCorrectionLoading.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <CoreLocation/CoreLocation.h>
#import <extThree20JSON/extThree20JSON.h>
#import "SnMessage.h"

@interface MessageCorrectionLoading : TTActivityLabel<TTURLRequestDelegate>
-(void)Post:(NSString*)userid muserid:(NSString*)muserid messageid:(NSString*)messageid content:(NSString*)content;
@end

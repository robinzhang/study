//
//  NotifyMessageHelper.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NotifyMessageHelper : NSObject<TTURLRequestDelegate>
{
    TTURLRequest *_loadingRequest;
}
- (void)NotifyMessageByLocation:(CLLocation *)newLocation;
- (BOOL)isLoading;
+ (NotifyMessageHelper*)sharedInstance;
@end

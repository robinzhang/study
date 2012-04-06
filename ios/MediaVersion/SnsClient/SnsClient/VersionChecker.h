//
//  VersionChecker.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionChecker : NSObject<TTURLRequestDelegate,UIAlertViewDelegate>
{
     TTURLRequest *_loadingRequest;
}
-(void)CheckVersionUpdate;
- (BOOL)isLoading;
- (void)cancel;
+ (VersionChecker*)sharedInstance;
@end

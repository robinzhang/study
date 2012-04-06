//
//  UcenterViewModel.h
//  SnsClient
//
//  Created by  on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import "UserProfile.h"

@interface UcenterViewModel : TTURLRequestModel
{
    UserProfile* _profie;
    NSString *_userid;
}
@property (nonatomic, copy)   NSString*  userid;
@property (nonatomic, readonly)   UserProfile* profie;
-(id)initWithUserId:(NSString*)userid;
-(void)clearCache:(NSString*)userid;
@end

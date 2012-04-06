//
//  SnComment.h
//  SnsClient
//
//  Created by  on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnComment : NSObject
{
    NSString* _UserID;
    NSString* _MessageID;
    NSString* _UserName; 
    NSString* _UserFace; 
    NSDate* _PublicDate;
    NSString* _MessageBody;
}
@property (nonatomic,copy)  NSString* MessageID;
@property (nonatomic,copy)  NSString* UserID;
@property (nonatomic,copy)  NSString* UserName;
@property (nonatomic,copy)  NSString* UserFace;
@property (nonatomic,retain)  NSDate* PublicDate;
@property (nonatomic,copy)  NSString* MessageBody;
@end

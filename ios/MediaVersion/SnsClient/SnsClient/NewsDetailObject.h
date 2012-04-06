//
//  MessageDetailObject.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDetailObject : NSObject
{
    NSString* _UserID;
    NSString* _Address;
    NSString* _MessageID;
    NSString* _UserName; 
    NSString* _UserFace; 
    NSDate* _PublicDate;
    NSString* _NewsText;
    NSString* _MessageBody;
    NSString* _PicPath; 
    NSUInteger _CommentCount;
    NSUInteger _LikeCount;
    double  _Longitude;
    double  _Latitude;
         NSUInteger _UserType;
      NSUInteger _CloneCount;

}
@property (nonatomic,assign) NSUInteger UserType;
@property (nonatomic,assign) NSUInteger CloneCount;
@property (nonatomic,copy)  NSString* MessageID;
@property (nonatomic,copy)  NSString* Address;
@property (nonatomic,copy)  NSString* UserID;
@property (nonatomic,copy)  NSString* UserName;
@property (nonatomic,copy)  NSString* UserFace;
@property (nonatomic,retain)  NSDate* PublicDate;
@property (nonatomic,copy)  NSString* MessageBody;
@property (nonatomic,copy)  NSString* NewsText;
@property (nonatomic,copy)  NSString* PicPath;
@property (nonatomic,assign)  NSUInteger CommentCount;
@property (nonatomic,assign)  NSUInteger LikeCount;
@property (nonatomic,assign)  double Longitude;
@property (nonatomic,assign)  double Latitude;
@end

//
//  SnMessage.h
//  SnsClient
//
//  Created by  on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SnMessage : NSObject<NSCoding>
{
    NSString* _UserID;
    NSString* _MessageID;
    NSString* _UserName; 
    NSString* _UserFace; 
    NSDate* _PublicDate;
    NSString* _MessageBody;
    NSString* _PicPath; 
    NSUInteger _CommentCount;
    NSUInteger _ViewCount;
    double  _Longitude;
    double  _Latitude;
        int _UserType;
}
@property (nonatomic,assign) int UserType;
@property (nonatomic,copy)  NSString* MessageID;
@property (nonatomic,copy)  NSString* UserID;
@property (nonatomic,copy)  NSString* UserName;
@property (nonatomic,copy)  NSString* UserFace;
@property (nonatomic,retain)  NSDate* PublicDate;
@property (nonatomic,copy)  NSString* MessageBody;
@property (nonatomic,copy)  NSString* PicPath;
@property (nonatomic,assign)  NSUInteger CommentCount;
@property (nonatomic,assign)  NSUInteger ViewCount;
@property (nonatomic,assign)  double Longitude;
@property (nonatomic,assign)  double Latitude;
@end

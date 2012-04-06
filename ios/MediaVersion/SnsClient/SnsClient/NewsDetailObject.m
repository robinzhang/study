//
//  MessageDetailObject.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailObject.h"

@implementation NewsDetailObject
@synthesize UserID = _UserID;
@synthesize MessageID = _MessageID;
@synthesize UserName = _UserName;
@synthesize UserFace = _UserFace;
@synthesize PublicDate = _PublicDate;
@synthesize MessageBody = _MessageBody;
@synthesize PicPath = _PicPath;
@synthesize CommentCount = _CommentCount;
@synthesize LikeCount = _LikeCount;
@synthesize Longitude = _Longitude;
@synthesize Latitude = _Latitude;
@synthesize NewsText = _NewsText;
@synthesize  Address = _Address;
@synthesize UserType = _UserType;
@synthesize CloneCount = _CloneCount;

- (void)dealloc {
    TT_RELEASE_SAFELY(_Address);
    TT_RELEASE_SAFELY(_UserID);
    TT_RELEASE_SAFELY(_MessageID);
    TT_RELEASE_SAFELY(_UserName);
    TT_RELEASE_SAFELY(_UserFace);
    TT_RELEASE_SAFELY(_PublicDate);
    TT_RELEASE_SAFELY(_MessageBody);
    TT_RELEASE_SAFELY(_PicPath);
    TT_RELEASE_SAFELY(_NewsText);
    //TT_RELEASE_SAFELY(_CommentCount);
    //TT_RELEASE_SAFELY(_LikeCount);
    [super dealloc];
}

@end

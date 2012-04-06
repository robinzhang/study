//
//  SnMessage.m
//  SnsClient
//
//  Created by  on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "SnMessage.h"

@implementation SnMessage

@synthesize UserID = _UserID;
@synthesize MessageID = _MessageID;
@synthesize UserName = _UserName;
@synthesize UserFace = _UserFace;
@synthesize PublicDate = _PublicDate;
@synthesize MessageBody = _MessageBody;
@synthesize PicPath = _PicPath;
@synthesize CommentCount = _CommentCount;
@synthesize ViewCount = _ViewCount;
@synthesize Longitude = _Longitude;
@synthesize Latitude = _Latitude;
@synthesize UserType = _UserType;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
	self = [self init];
    if (self) {
        self.UserName = [NSString stringWithFormat:@"%@", [decoder decodeObjectForKey:@"UserName"]];
        self.UserID = [NSString stringWithFormat:@"%@", [decoder decodeObjectForKey:@"UserID"]];
        self.MessageID = [NSString stringWithFormat:@"%@", [decoder decodeObjectForKey:@"MessageID"]];
        self.UserFace = [NSString stringWithFormat:@"%@", [decoder decodeObjectForKey:@"UserFace"]];
        self.CommentCount = [[decoder decodeObjectForKey:@"CommentCount"] intValue];
        self.ViewCount = [[decoder decodeObjectForKey:@"LikeCount"] intValue];
        self.PicPath = [decoder decodeObjectForKey:@"PicPath"];
        self.MessageBody = [decoder decodeObjectForKey:@"MessageBody"];
         self.UserType = [[decoder decodeObjectForKey:@"UserType"] intValue];
        if(TTIsStringWithAnyText([decoder decodeObjectForKey:@"Longitude"]))
            self. Longitude = [[decoder decodeObjectForKey:@"Longitude"] doubleValue];
        if(TTIsStringWithAnyText([decoder decodeObjectForKey:@"Latitude"]))
            self. Latitude = [[decoder decodeObjectForKey:@"Latitude"] doubleValue];
        if(TTIsStringWithAnyText([decoder decodeObjectForKey:@"PublicDate"]))
            self.PublicDate = [decoder decodeObjectForKey:@"PublicDate"];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    //[super encodeWithCoder:encoder];
    if(self.UserName)
        [encoder encodeObject:self.UserName forKey:@"UserName"];
    if(self.UserID)
        [encoder encodeObject:self.UserID forKey:@"UserID"];
    if(self.UserType)
        [encoder encodeObject:[NSString stringWithFormat:@"%d", self.UserType] forKey:@"UserType"];
    if(self.MessageID)
        [encoder encodeObject:self.MessageID forKey:@"MessageID"];
    if(self.UserFace)
        [encoder encodeObject:self.UserFace forKey:@"UserFace"];
    if(self.CommentCount)
        [encoder encodeObject:[NSString stringWithFormat:@"%d", self.CommentCount] forKey:@"CommentCount"];
    if(self.ViewCount)
        [encoder encodeObject:[NSString stringWithFormat:@"%d", self.ViewCount] forKey:@"LikeCount"];
    if(self.MessageBody)
        [encoder encodeObject:self.MessageBody forKey:@"MessageBody"];
    if(self.PicPath)
        [encoder encodeObject:self.PicPath forKey:@"PicPath"];
    [encoder encodeObject:[NSString stringWithFormat:@"%f",self.Longitude] forKey:@"longitude"];
    [encoder encodeObject:[NSString stringWithFormat:@"%f",self.Latitude] forKey:@"latitude"];
    if(self.PublicDate)
        [encoder encodeObject:self.PublicDate   forKey:@"PublicDate"];
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_UserID);
    TT_RELEASE_SAFELY(_MessageID);
    TT_RELEASE_SAFELY(_UserName);
    TT_RELEASE_SAFELY(_UserFace);
    TT_RELEASE_SAFELY(_PublicDate);
    TT_RELEASE_SAFELY(_MessageBody);
    TT_RELEASE_SAFELY(_PicPath);
    //TT_RELEASE_SAFELY(_location);
    //TT_RELEASE_SAFELY(_CommentCount);
    //TT_RELEASE_SAFELY(_LikeCount);
    [super dealloc];
}
@end

//
//  SnComment.m
//  SnsClient
//
//  Created by  on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnComment.h"

@implementation SnComment
@synthesize UserID = _UserID;
@synthesize MessageID = _MessageID;
@synthesize UserName = _UserName;
@synthesize UserFace = _UserFace;
@synthesize PublicDate = _PublicDate;
@synthesize MessageBody = _MessageBody;

- (void)dealloc {
    TT_RELEASE_SAFELY(_UserID);
    TT_RELEASE_SAFELY(_MessageID);
    TT_RELEASE_SAFELY(_UserName);
    TT_RELEASE_SAFELY(_UserFace);
    TT_RELEASE_SAFELY(_PublicDate);
    TT_RELEASE_SAFELY(_MessageBody);
    //TT_RELEASE_SAFELY(_CommentCount);
    //TT_RELEASE_SAFELY(_LikeCount);
    [super dealloc];
}
@end

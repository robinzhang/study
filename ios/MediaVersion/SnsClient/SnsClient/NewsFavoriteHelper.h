//
//  NewsFavoriteHelper.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NewsFavoriteHelperDelegate
- (void)CheckNewsFavoriteSuccess:(int)tag;
@end

#import <Foundation/Foundation.h>
#import <extThree20JSON/extThree20JSON.h>
#import <extThree20JSON/SBJsonParser.h>

@interface NewsFavoriteHelper : NSObject<TTURLRequestDelegate>
{
    id<NewsFavoriteHelperDelegate> _delegate;
}
@property (nonatomic, assign) id<NewsFavoriteHelperDelegate> delegate;
-(void)addFavorite:(NSString*)userid muserid:(NSString*)muserid messgeid:(NSString*)messgeid;
-(void)delFavorite:(NSString*)userid muserid:(NSString*)muserid messgeid:(NSString*)messgeid;
-(void)checkFavorite:(NSString*)userid muserid:(NSString*)muserid  messgeid:(NSString*)messgeid;
@end

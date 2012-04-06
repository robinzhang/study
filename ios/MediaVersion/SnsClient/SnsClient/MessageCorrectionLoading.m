//
//  MessageCorrectionLoading.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MessageCorrectionLoading.h"

@implementation MessageCorrectionLoading
-(void)Post:(NSString*)userid muserid:(NSString*)muserid messageid:(NSString*)messageid content:(NSString*)content
{
    NSString* url = [NSString stringWithFormat:URLPostUserCorrection, 
                     KApi_Domain,
                     userid,
                     muserid,
                     messageid,
                     content];
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
  
    request.cachePolicy =  TTURLRequestCachePolicyNoCache;
    [request setValue:[UserHelper GetSecToken] forHTTPHeaderField:KUserSecToken];
    [request setValue:[UserHelper GetUserID] forHTTPHeaderField:KUserID];
    [request setValue:KAppKValue forHTTPHeaderField:KAppKey];
    
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [UserHelper DegBugWidthLog:url title:@"Post UserCorrection"];
    [request send];
}

- (void)requestDidStartLoad:(TTURLRequest*)request
{
    [self setText:@"正在提交..."];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request
{
    [self setText:@"提交成功！"];
    if([self superview])
        [self removeFromSuperview];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error
{
    [self setText:@"提交失败！"];
    if([self superview])
        [self removeFromSuperview];
}
@end

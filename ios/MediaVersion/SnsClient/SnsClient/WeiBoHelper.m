//
//  WeiBoHelper.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-12-17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WeiBoHelper.h"
#import <extThree20JSON/extThree20JSON.h>
#import "extThree20JSON/JSON.h"
#import "ASIFormDataRequest.h"

@implementation WeiBoHelper
@synthesize weibo  = weibo,changeUser = changeUser,  delegate = _delegate;

WeiBoHelper *shareWeiboHelper;
+ (WeiBoHelper*)sharedInstance
{
    if(shareWeiboHelper == nil)
    {
        shareWeiboHelper = [[WeiBoHelper alloc] init];
    }
    return shareWeiboHelper;
}

-(id)init
{
    self  = [super init];
    if(self)
    {
        weibo =  weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoAPPKey 
                                        withAppSecret:SinaWeiBoAPPSecret];
        weibo.delegate = self;
        changeUser = NO;
    }
    return  self;
}

-(bool)isWeiBoLogon
{
    if(self)
    {
        weibo =  weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoAPPKey 
                                        withAppSecret:SinaWeiBoAPPSecret];
        weibo.delegate = self;
    }
    return [weibo isUserLoggedin];
}

#pragma mark weibo
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sendWeibo:(NSString*)text image:(UIImage*)image andDelegate:(id<WBSendViewDelegate>)WBSendDelegate{
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
    weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoAPPKey 
						   withAppSecret:SinaWeiBoAPPSecret];
    weibo.delegate = self;
    [weibo startAuthorize];
    [weibo showSendViewWithWeiboText:text andImage:image andDelegate:WBSendDelegate];
}


- (void)sendWeiboByPost:(NSString*)text image:(UIImage*)image andDelegate:(id<WBRequestDelegate>)WBReqDelegate{
    weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoAPPKey 
						   withAppSecret:SinaWeiBoAPPSecret];
    weibo.delegate = self;
    [weibo startAuthorize];
    [weibo postWeiboRequestWithText:text andImage:image andDelegate:WBReqDelegate];
}


- (void)dismissWeiboSendView{
    if( !weibo )
    {
        weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoAPPKey 
                               withAppSecret:SinaWeiBoAPPSecret];
        weibo.delegate = self;
    }
    [weibo dismissSendView];
}

- (void)weiboLogout{
     if( !weibo )
     {
         weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoAPPKey 
                                withAppSecret:SinaWeiBoAPPSecret];
         weibo.delegate = self;
     }
    [weibo LogOut];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)weiboLogin{
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoAPPKey 
						   withAppSecret:SinaWeiBoAPPSecret];
	weibo.delegate = self;
	[weibo startAuthorize];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)weiboDidLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:weibo.userID forKey:KWeiboUID];
    [userDefaults synchronize];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    weibo.userID, @"user_id",
                                    nil];
    [weibo requestWithMethodName:@"users/show.json" andParams:params andHttpMethod:@"GET" andDelegate:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)weiboLoginFailed:(BOOL)userCancelled withError:(NSError*)error
{
    
//	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"用户验证失败！"  
//													   message:userCancelled?@"用户取消操作":[error description]  
//													  delegate:nil
//											 cancelButtonTitle:@"确定" 
//											 otherButtonTitles:nil];
//	[alertView show];
//	[alertView release];
    
    if ([self.delegate respondsToSelector:@selector(didAfterWeiBologinError:)]) {
        [self.delegate didAfterWeiBologinError:[error description]];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)weiboDidLogout
{
    
    SnUserAppInfo *uinfo = [UserHelper GetUserAppInfo];
    uinfo.WeiBoUserID = @"";
    [UserHelper SetUserAppInfo:uinfo];
    
    
    if ([self.delegate respondsToSelector:@selector(didAfterWeiboLogiout)]) {
        [self.delegate didAfterWeiboLogiout];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(WBRequest *)request didFailWithError:(NSError *)error
{
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:[NSString stringWithFormat:@"发送失败：%@",[error description] ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
    
    if ([self.delegate respondsToSelector:@selector(didAfterWeiBologinError:)]) {
        [self.delegate didAfterWeiBologinError:[error description]];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* encodeToPercentEscapeString(NSString *string) {
    return (NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(WBRequest *)request didLoad:(id)result
{
	NSString *urlString = request.url;
	if ([urlString rangeOfString:@"users/show"].location !=  NSNotFound)
	{
        if(!self.changeUser)
        {
            if ([self.delegate respondsToSelector:@selector(didAfterWeiBologin:)]) {
                [self.delegate didAfterWeiBologin:@""];
            }
            return;
        }
        
        NSString *weiboUid=weibo.userID;
        NSString *userToken=weibo.accessToken;
        NSString *userSec=weibo.accessTokenSecret;
        NSString *faceUrl=@"";
        NSString *nick=@"";
        
		SBJsonParser *parser=[[SBJsonParser alloc] init];
        id jsonObject=[parser objectWithData:request.responseText];
        nick = [jsonObject objectForKey:@"name"];
        faceUrl = [jsonObject objectForKey:@"profile_image_url"];
        faceUrl=encodeToPercentEscapeString(faceUrl);
        
        nick =[nick stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url= [NSString stringWithFormat:
                        URLSinaUserLoginIn,KApi_Domain,
                        weiboUid,
                        nick,
                        userToken,
                        userSec,
                        faceUrl
                        ];
        
        NSURL *nUrl=[NSURL URLWithString:url];
        
        [UserHelper DegBugWidthLog:url title:@"weibo"];
        ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :nUrl];
        request.delegate = self;
        [request setUserAgent:KUserAgent];
        [request startSynchronous ];
        NSString *response = [request responseString ];
        id jobj=[parser objectWithString:response];
        id resultval  = [jobj objectForKey:@"SinaUserLoginInResult"];
        
        if([[resultval objectForKey:@"Success"] boolValue])
        {
            NSString* uid  = [resultval objectForKey:@"UserId"];
            NSString* returnSec  = [resultval objectForKey:@"UserSecToken"]; 
            [UserHelper SetUserLogon:uid usertoken:returnSec];
            
            SnUserAppInfo *uinfo = [UserHelper GetUserAppInfo];
            uinfo.WeiBoUserID = uid;
            [UserHelper SetUserAppInfo:uinfo];
            
            if ([self.delegate respondsToSelector:@selector(didAfterWeiBologin:)]) {
                [self.delegate didAfterWeiBologin:uid];
            }
        }
        else
        {
            NSString* errormsg = @"使用微博认证失败，请重试！";
            if([resultval objectForKey:@"ErrorMessage"])
                errormsg = [resultval objectForKey:@"ErrorMessage"];
            
            if ([self.delegate respondsToSelector:@selector(didAfterWeiBologinError:)]) {
                [self.delegate didAfterWeiBologinError:errormsg];
            }
        }
        TT_RELEASE_SAFELY(parser);
	}
}
@end

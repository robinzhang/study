//
//  SinaWeiBoHelper.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SinaWeiBoHelper.h"

@implementation SinaWeiBoHelper
@synthesize weibo = weibo;
-(id)init
{
    if(self = [super init])
    {
        weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoAPPKey 
                               withAppSecret:SinaWeiBoAPPSecret];
    }
    return  self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sendWeibo:(NSString*)text image:(UIImage*)image andDelegate:(id<WBSendViewDelegate>)WBSendDelegate{
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
    
    weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoAPPKey 
						   withAppSecret:SinaWeiBoAPPSecret];
    [weibo startAuthorize];
    [weibo showSendViewWithWeiboText:text andImage:image andDelegate:WBSendDelegate];
}


- (void)sendWeiboByPost:(NSString*)text image:(UIImage*)image andDelegate:(id<WBRequestDelegate>)WBReqDelegate{
    weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoAPPKey 
						   withAppSecret:SinaWeiBoAPPSecret];
    [weibo startAuthorize];
    [weibo postWeiboRequestWithText:text andImage:image andDelegate:WBReqDelegate];
}


- (void)dismissWeiboSendView{
    [weibo dismissSendView];
}

- (void)weiboLogout{
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
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"用户验证失败！"  
													   message:userCancelled?@"用户取消操作":[error description]  
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)weiboDidLogout
{
    // MyUserCenterController *tocontroller =  [[MyUserCenterController alloc] init];
    // [self.window.viewController.navigationController pushViewController: tocontroller animated:YES];
    // [tocontroller release];
    TTNavigator* navigator = [TTNavigator navigator];
    [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://ucenter"]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(WBRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:[NSString stringWithFormat:@"发送失败：%@",[error description] ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
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
        NSString *weiboUid=weibo.userID;
        NSString *userToken=weibo.accessToken;
        NSString *userSec=weibo.accessTokenSecret;
        NSString *faceUrl=@"";
        NSString *nick=@"";
        
		SBJsonParser *parser=[[SBJsonParser alloc] init];
        id jsonObject=[parser objectWithData:request.responseText];
        //weiboUid = [jsonObject objectForKey:@"id"];
        nick = [jsonObject objectForKey:@"name"];
        faceUrl = [jsonObject objectForKey:@"profile_image_url"];
        faceUrl=encodeToPercentEscapeString(faceUrl);
        
        nick =[nick stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url= [NSString stringWithFormat:
                        @"http://open.kanguo.com/users/SinaLogin?accountId=%@&accountName=%@&userToken=%@&userTokenSecret=%@&Open_Account_TypeValue=1&userFaceUrl=%@",
                        weiboUid,
                        nick,
                        userToken,
                        userSec,
                        faceUrl
                        ];
        
        NSURL *nUrl=[NSURL URLWithString:url];
        
        [UserHelper DegBugWidthLog:url title:@"weibo"];
        
        //NSLog(@"reg weibo user:%@",url);
        //NSLog(@"uid:%@",weiboUid);
        ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :nUrl];
        [request setUserAgent:KUserAgent];
        [request startSynchronous ];
        NSString *response = [request responseString ];
        //{"SinaUserLoginInResult":{"ErrorMessage":null,"Success":true,"UserId":"46d3679f0c8849d8","UserSecToken":"06b9b12db019ad6bad46d0bb8dc4e04dcce0d92d"}}
        id jobj=[parser objectWithString:response];
        id resultval  = [jobj objectForKey:@"SinaUserLoginInResult"];
        
        if([[resultval objectForKey:@"Success"] boolValue])
        {
            NSString* uid  = [resultval objectForKey:KUserID];
            NSString* returnSec  = [resultval objectForKey:KUserSecToken]; 
            [UserHelper SetUserLogon:uid usertoken:returnSec];
            
//          NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//          [userDefaults setObject:uid forKey:KUserID];
//          [userDefaults setObject:returnSec forKey:KUserSecToken];
//          [userDefaults synchronize];
//            [self.delegate didAfterLogon];
//            TTOpenURL(@"tt://main");
           [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoginInSuccess" object:uid];
        }
        TT_RELEASE_SAFELY(parser);
	}
}
@end

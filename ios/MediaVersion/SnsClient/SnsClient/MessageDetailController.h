//
//  MessageDetailController.h
//  SnsClient
//
//  Created by  on 11-10-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#import "extThree20JSON/JSON.h"
#import "ASIFormDataRequest.h"
#import <MessageUI/MessageUI.h>

#import "UserHelper.h"
#import "SnMessage.h"
#import "ShareViewController.h"
#import "DetailMapViewController.h"
#import "DetailCommentViewController.h"
#import "UserProfileViewController.h"
#import "NewsCommentModel.h"
#import "DeatilCommentDataSource.h"
#import "NewsDetailObject.h"
#import "NewsFavoriteButton.h"
#import "MessageCorrectionLoading.h"
#import "DetailImageViewController.h"
#import "WeiBoHelper.h"

@interface MessageDetailController : SnTableViewController<UIAlertViewDelegate,TTURLRequestDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate,ASIHTTPRequestDelegate,DetailCommentDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,WBSendViewDelegate,SnAppWeiboDelegate>
{
    NewsDetailObject *_message;
    
    NSString* _userid;
    NSString* _from;
    NSString* _messageid;
    NSMutableArray*  _posts;
    UIToolbar* _toolBar;
    NewsFavoriteButton *favoriteButton;
    UILabel *lCommentCount;
}
-(void)sendToWeibo;

-(id)initWidthMessage:(SnMessage*)message ;
-(id)initWidthMessageid:(NSString*)messageid query:(NSDictionary*)query;

-(void)RequestMainInfo;
-(void)initMainInfo:(NewsDetailObject*)message;
-(UIView*)initUserInfo:(NewsDetailObject*)message frame:(CGRect)frame;
-(UIToolbar*)initToobar;

@property (nonatomic, retain) NewsDetailObject* message;
@property (nonatomic, retain) NSString* messageid;
@property (nonatomic, retain) NSString* userid;
@property (nonatomic, retain) NSString* from;
@end

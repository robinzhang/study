//
//  DetailCommentViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol DetailCommentDelegate
- (void)didAfterComment;
@end


#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import <extThree20JSON/extThree20JSON.h>
#define kCommentMaxTextCount  120
#import "SnsClientAppDelegate.h"
#import "WeiBoHelper.h"
#import "SnSectionedDataSource.h"

@interface DetailCommentViewController : TTTableViewController<UITextViewDelegate,TTURLRequestDelegate,WBSendViewDelegate,SnAppWeiboDelegate>
{
    UITextView *_text;
    UILabel *_wordCountLabel;
    NSString *_me;
    NSString *_messageid;
    NSString *_userid;
    id<DetailCommentDelegate> _delegate;
    UISwitch* switchy;
    UIButton *button;
    
    UIBarButtonItem *btnSubmit;
    TTActivityLabel *postloading;
}
@property (nonatomic, retain) NSString* messageid;
@property (nonatomic, retain) NSString* userid;
@property (nonatomic, retain) NSString* me;
- (id)initWithMessage:(NSString*)messageid userid:(NSString*)userid;
@property (nonatomic, assign) id<DetailCommentDelegate> delegate;
- (int)calculateTextNumber:(NSString *) textA;
@end

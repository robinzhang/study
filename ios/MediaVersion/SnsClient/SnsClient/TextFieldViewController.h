//
//  TextFiledViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SnTextFieldDelegate
- (void)didTextFieEndEditing:(NSString*)text tag:(int)tag;
@end

#import <Foundation/Foundation.h>

@interface TextFieldViewController : TTTableViewController<UITextViewDelegate,UIAlertViewDelegate>
{
    id<SnTextFieldDelegate> _delegate;
    int _callBackTag;
    
    UITextField *_text;
}
@property (nonatomic, assign) int callBackTag;
@property (nonatomic, assign) id<SnTextFieldDelegate> delegate;
- (id)initWithText:(NSString*)text  tag:(int)tag;
@end

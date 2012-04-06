//
//  TextEditorViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SnTextEditorDelegate
- (void)didTextEditorEndEditing:(NSString*)text tag:(int)tag;
@end

#import <UIKit/UIKit.h>
#import "SnSectionedDataSource.h"
@interface TextEditorViewController : TTViewController<UITextViewDelegate,UIAlertViewDelegate>
{
    id<SnTextEditorDelegate> _delegate;
    int _callBackTag;
    UITextView *_text;
    UILabel *_wordCountLabel;
    int _maxTextLenght;
}
@property (nonatomic, assign) int callBackTag;
@property (nonatomic, assign) id<SnTextEditorDelegate> delegate;
- (void)textLengthCount;
- (int)calculateTextNumber:(NSString *) textA;
- (id)initWithText:(NSString*)text title:(NSString*)title tag:(int)tag  maxlength:(int)maxlength;
@end

//
//  DetailViewController.h
//  Three20UICommon
//
//  Created by robin on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyTableViewControler.h"
#import <Three20/Three20.h>
@interface DetailViewController :UIViewController<UIWebViewDelegate> {    
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *opaqueview;
    NSString *title;
    NSString *doc_path; 
    
}
-(id)initWidthMessageid:(NSString*)doc;
- (void)loadWebPageWithString:(NSString*)urlString;
@end


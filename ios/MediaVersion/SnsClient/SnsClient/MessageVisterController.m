//
//  MessageVisterController.m
//  Kanguo
//
//  Created by zhan xiaoping on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailObject.h"
#import "MessageVisterController.h"

@implementation MessageVisterController
@synthesize messageid = _messageid;
@synthesize userid = _userid;
@synthesize me = _me;


-(id)initWidthMessage:(NewsDetailObject*)message;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.messageid = message.MessageID;
        self.userid = message.UserID;
        self.me  = [UserHelper GetUserID];
        self.title = @"他们看过";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.me = [UserHelper GetUserID];
    [super viewWillAppear:animated];
    
    TTButton *rbtn = [TTButton buttonWithStyle:@"blueImgToolbarButton:" title:nil]; 
    [rbtn setImage:@"bundle://icon_home.png" forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    [rbtn setFrame:CGRectMake(0, 0, 36, 34)];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rbtn]; 
    //icon_home
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}

-(void)goHome
{
    MainViewController *main = [[MainViewController alloc] initWithNibName:nil bundle:nil]; 
    [self.navigationController presentModalViewController:main animated:NO];
    [main release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    self.dataSource =  [[[MessageVisterDataSource alloc]
                        initWithQuery:self.userid messageid:self.messageid] autorelease];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}
@end

//
//  UcenterViewDataSource.m
//  SnsClient
//
//  Created by  on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UcenterViewDataSource.h"

@implementation UcenterViewDataSource

-(id)initWithUserId:(NSString*)userid
{
    if (self = [super init]) {
        _UcenterViewModel = [[UcenterViewModel alloc] initWithUserId:userid];
        
    }
    return self;
}

-(id)initWithProfile:(UserProfile*)profile
{
    if (self = [super init]) {
        _UcenterViewModel = [[UcenterViewModel alloc] initWithUserId:profile.UserID];
        [self SetItemsByProfile:profile];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_UcenterViewModel);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
    return _UcenterViewModel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView 
{
    [self SetItemsByProfile:_UcenterViewModel.profie];
}

-(void)SetItemsByProfile:(UserProfile *)profile
{
    NSMutableArray* items = [NSMutableArray array];
    NSMutableArray* sections = [NSMutableArray array];
    
    ////// 11
    [sections addObject:@""];
    NSMutableArray* section = [NSMutableArray array];
    TTTableCaptionItem *item = [TTTableCaptionItem itemWithText:profile.Email caption:NSLocalizedString(@"Email", @"Email")];
    
    [section addObject:item];
    [items addObject:section];
    
    
    ////// 33
    [sections addObject:@""];
    NSMutableArray*  section2 = [NSMutableArray array];
    
    [section2 addObject:[TTTableImageItem itemWithText:@"我收到的通知" imageURL:@"bundle://icon_news.png" URL:@"tt://uevent"]];
    
    [section2 addObject:[TTTableImageItem itemWithText:@"我发表的新闻" imageURL:@"bundle://icon_news.png" URL:@"tt://myposts"]];
    
    [section2 addObject:[TTTableImageItem itemWithText:@"我收藏的新闻" imageURL:@"bundle://icon_fav.png" URL:@"tt://myfavorites"]];
    
    if(profile.UserType == 16)
    {
        TTTableImageItem *cell3 = [TTTableImageItem itemWithText:@"我收到的报料" delegate:self selector:@selector(newsforme)];
        cell3.imageURL = @"bundle://icon_tome.png";
        [section2 addObject:cell3]; 
    }
    [items addObject:section2];
    
    [sections addObject:@""];
    NSMutableArray*  section3 = [NSMutableArray array];
    [section3 addObject:[TTTableImageItem itemWithText:@"用户设置" imageURL:@"bundle://more_setting.png" URL:@"tt://setting"]];
    
    TTTableImageItem *itmeh = [TTTableImageItem itemWithText:@"帮助说明"  delegate:self selector:@selector(onShowHelper)];
    [itmeh setImageURL:@"bundle://icon_Helper.png"];
    [section3 addObject:itmeh];

    
    [items addObject:section3];

    self.sections = sections;
    self.items = items;
}


-(void)newsforme
{   
    TTOpenURL([NSString stringWithFormat:@"tt://newsforme/%@",[UserHelper GetUserID]]);
}



-(void)onShowHelper
{
    TTOpenURL(@"tt://userguide" );
}
@end

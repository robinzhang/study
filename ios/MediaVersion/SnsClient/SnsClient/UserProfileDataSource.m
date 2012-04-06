//
//  UserProfileDataSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserProfileDataSource.h"

@implementation UserProfileDataSource

-(id)initWithUserId:(NSString*)userid
{
    if (self = [super init]) {
        _UcenterViewModel = [[UcenterViewModel alloc] initWithUserId:userid];
        
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
- (void)tableViewDidLoadModel:(UITableView*)tableView {
    if(!TTIsStringWithAnyText( _UcenterViewModel.profie.UserID))
        return;
    
    NSMutableArray* items = [NSMutableArray array];
    NSMutableArray* sections = [NSMutableArray array];
    
    ////// 11
    [sections addObject:@""];
    NSMutableArray*  section0 = [NSMutableArray array];
    if(_UcenterViewModel.profie.UserType == 16)
    {
        [section0 addObject:[TTTableCaptionItem itemWithText:_UcenterViewModel.profie.UserName caption:@"官方认证:"]];
    }
    
    TTTableSubtextItem *introItem = [TTTableSubtextItem itemWithText:@"自我介绍:" caption:_UcenterViewModel.profie.Intro ];
    //[introItem setCaption:_profile.Intro];
    [section0 addObject:introItem];
    
    //[section0 addObject:[TTTableSubtextItem itemWithText:_UcenterViewModel.profie.Intro caption:@"自我介绍:"]];
    [items addObject:section0];
    
    ////// 11
    [sections addObject:@""];
    NSMutableArray*  section1 = [NSMutableArray array];
    
    NSString *url = [NSString stringWithFormat:@"tt://userposts/%@",_UcenterViewModel.profie.UserID];
    [section1 addObject:[TTTableImageItem itemWithText:@"他发表的新闻" imageURL:@"bundle://icon_news.png" URL:url]];

    
    NSString *url2 = [NSString stringWithFormat:@"tt://userfavorites/%@",_UcenterViewModel.profie.UserID];
    [section1 addObject:[TTTableImageItem itemWithText:@"他收藏的新闻" imageURL:@"bundle://icon_fav.png" URL:url2]];
    [items addObject:section1];
    
    self.sections = sections;
    self.items = items;
}

@end

//
//  HomeViewDataSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NearUsersDataSource.h"

@implementation NearUsersDataSource
- (id)initWithSearchQuery:(CLLocation*)location range:(NSString*)range
{  
    if (self = [super init]) {
        _searchFeedModel = [[NearUsersModel alloc] initWithSearchQuery:location range:range];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_searchFeedModel);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
    return _searchFeedModel;
}



//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView { 
//    //if(searching)
//    //    return nil;
//    
//    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//    [tempArray addObject:@"1"];
//    [tempArray addObject:@"2"];
//    [tempArray addObject:@"3"];
//    [tempArray addObject:@"4"];
//    [tempArray addObject:@"5"];
//    [tempArray addObject:@"6"];
//    [tempArray addObject:@"7"];
//    [tempArray addObject:@"8"];
//    [tempArray addObject:@"9"];
//    [tempArray addObject:@"10"];
//    [tempArray addObject:@"11"];
//    [tempArray addObject:@"12"];
//    [tempArray addObject:@"13"];
//    [tempArray addObject:@"14"];
//    [tempArray addObject:@"15"];
//    [tempArray addObject:@"16"];
//    [tempArray addObject:@"17"];
//    [tempArray addObject:@"18"];
//    [tempArray addObject:@"19"];
//    [tempArray addObject:@"20"];
//    [tempArray addObject:@"21"];
//    [tempArray addObject:@"22"];
//    [tempArray addObject:@"23"];
//    [tempArray addObject:@"24"];
//    [tempArray addObject:@"25"];
//    [tempArray addObject:@"26"];
//    
//    return tempArray;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    //if(searching)
//    //    return -1;
//    //return index % 2;
//    return 0;
//}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
   // if(_searchFeedModel.posts.count <= 0)
   //     return;
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    CLLocation *locaton =  ((NearUsersModel *)self.model).location;
    
    for (UserProfile* post in _searchFeedModel.posts) {
        //NSString *url = [NSString stringWithFormat:@"tt://tprofile/%@",post.UserID];
        NSString *userFace = [NSString stringWithFormat:@"%@_80_80.jpg",post.UserFace];
        NSString *text =@"";
        if(post.Latitude > 0)
        {
            CLLocation *another = [[CLLocation alloc] initWithLatitude:post.Latitude longitude:post.Longitude];
            text =[NSString stringWithFormat:@"%@ /", [UserHelper getDistance:locaton another:another]];
            //[another release];
        }
        
        SnTableMessageItem *item = [SnTableMessageItem itemWithTitle:post.UserName caption:post.Intro text:text timestamp:post.CreateTime URL:nil];
        
        [item setImageURL:userFace];
        item.userInfo = post;
        //[item setUserid:post.UserID];
        //if(post.Sex !=0)
        //post.Sex  = 1;
        //[item setSex:post.Sex];
        [items addObject:item];
        //TT_RELEASE_SAFELY(item);
    }
    
    if (_searchFeedModel.finished == NO)
    {
        [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
    }
    
    self.items = items;
    TT_RELEASE_SAFELY(items);
}
@end

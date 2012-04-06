//
//  NewsForMeViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsForMeDataSource.h"
#import "NewsForMeModel.h"

@interface NewsForMeViewController : SnTableViewController<TTTabDelegate>
{
    NSString *_queryUserid;
    NewsForMeDataSource *datasource0;
    NewsForMeDataSource *datasource1;
    int _seIndex;
}
@property (nonatomic,copy) NSString *queryUserid;
-(id)initWidthUserId:(NSString*)queryUserid;
@end

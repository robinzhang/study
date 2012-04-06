//
//  SnSectionedDataSource.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnSectionedDataSource.h"


@implementation SnSectionedDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {   
    if ([object isKindOfClass:[TTTableSubtextItem class]]) {  
        return [SnTableSubtextItemCell class];  
    } 
    else if ([object isKindOfClass:[TTTableCaptionItem class]]) {  
        return [SnTableCaptionItemCell class];  
    } 
    else if([object isKindOfClass:[TTTableControlItem class]])
    {
        return [SnTableControlItemCell class];  
    }
    else if([object isKindOfClass:[SnTableSelectItem class]])
    {
        return [SnTableSelectItemCell class];  
    }
    else if([object isKindOfClass:[SnTableMessageItem class]])
    {
        return [SnTableMessageItemCell class];  
    }
    else {  
        return [super tableView:tableView cellClassForObject:object];  
    }  
}  

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView*)tableView prepareCell:(UITableViewCell*)cell  
forRowAtIndexPath:(NSIndexPath*)indexPath {  
    cell.accessoryType = UITableViewCellAccessoryNone;  
}  


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
    if (reloading) {
        return @"正在更新...";
    } else {
        return @"正在加载...";
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (NSString*)titleForEmpty {
//    return NSLocalizedString(@"No Data", @"没有数据");
//}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (UIImage*)imageForEmpty{
//    return TTIMAGE(@"bundle://nodata.png");
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
    return @"哎呀，出错了！";
}
@end

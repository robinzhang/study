//
//  SnDataSource.m
//  SnsClient
//
//  Created by  on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnListDataSource.h"
#import "SnTableCaptionItemCell.h"

@implementation SnListDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {   
    if ([object isKindOfClass:[TTTableCaptionItem class]]) {  
        return [SnTableCaptionItemCell class];  
    } 
    else if([object isKindOfClass:[SnTableSelectItem class]])
    {
        return [SnTableSelectItemCell class];  
    }
    else if([object isKindOfClass:[SnTableMessageItem class]])
    {
        return [SnTableMessageItemCell class];  
    }
    else if([object isKindOfClass:[SnTableNoDataItem class]])
    {
        return [SnTableNoDataItemCell class];  
    }
    else {  
        return [super tableView:tableView cellClassForObject:object];  
    }  
}  

- (void)tableView:(UITableView*)tableView cell:(UITableViewCell*)cell
willAppearAtIndexPath:(NSIndexPath*)indexPath {
	[super tableView:tableView cell:cell
willAppearAtIndexPath:indexPath];
    
	if (indexPath.row == self.items.count-1 
        && [cell isKindOfClass:[TTTableMoreButtonCell class]]) 
    {
		TTTableMoreButton* moreLink = [(TTTableMoreButtonCell *)cell object];
		moreLink.isLoading = YES;
		[(TTTableMoreButtonCell *)cell setAnimating:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self.model load:TTURLRequestCachePolicyNetwork more:YES];
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
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (UIImage*)imageForEmpty{
//    return TTIMAGE(@"bundle://nodata.png");
//}
//


/////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
    return @"哎呀，出错了！";
}

@end

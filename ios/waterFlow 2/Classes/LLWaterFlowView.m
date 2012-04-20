//
//  LLWaterFlowView.m
//  waterFlow
//
//  Created by kindy_imac on 12-2-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LLWaterFlowView.h"


@implementation LLWaterFlowView
@synthesize arrCellHeight = _arrCellHeight, arrVisibleCells = _arrVisibleCells, dicReuseCells = _dicReuseCells, flowdelegate = _flowdelegate;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.delegate  = self;
    }
    return self;
}

-(void)setFlowdelegate:(id <LLWaterFlowViewDelegate>)t_del
{
	_flowdelegate = t_del;
	
	[self didInit];
	
}

- (LLWaterFlowCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
	if(identifier == nil || identifier.length ==0)
	{
		return nil;
	}
	
	NSMutableArray *arrIndentifier_ = [_dicReuseCells objectForKey:identifier];
	if(arrIndentifier_ && [arrIndentifier_ isKindOfClass:[NSArray class]] && arrIndentifier_.count > 0)
	{
		//找到了重用的 
		LLWaterFlowCell *cell_ = [arrIndentifier_ lastObject];
		[cell_ retain];
		[arrIndentifier_ removeLastObject];
		return [cell_	 autorelease];
	}
	
	return nil;
}

//将要移除屏幕的cell添加到可重用列表中
- (void)addCellToReuseQueue:(LLWaterFlowCell *)cell
{
	if(cell.strReuseIndentifier.length == 0)
		return ;
	
	if(self.dicReuseCells == nil)
	{
		self.dicReuseCells = [NSMutableDictionary dictionaryWithCapacity:3];
		
		NSMutableArray *arr_ = [NSMutableArray arrayWithObject:cell];
		[_dicReuseCells setObject:arr_ forKey:cell.strReuseIndentifier];
	}
	
	else {
		NSMutableArray *arr_ = [_dicReuseCells objectForKey:cell.strReuseIndentifier];
		
		if(arr_ == nil)
		{
			arr_ = [NSMutableArray arrayWithObject:cell];
			[_dicReuseCells setObject:arr_ forKey:cell.strReuseIndentifier];
		}
		else {
			[arr_ addObject:cell];
		}
	}
}

- (void)reloadData
{
	
	//重新加载时 ， 将当前所有的cell移除， 拿来重用
	for(int i = 0; i < _nColumns; i++)
	{
		NSMutableArray *arrEachCell_ = [_arrVisibleCells objectAtIndex:i];
		for(int j =0; j < [arrEachCell_ count]; j ++)
		{
			LLWaterFlowCell *cell_ = [arrEachCell_ objectAtIndex:j];
			
			[self addCellToReuseQueue:cell_];
			[cell_ removeFromSuperview];
		}
	}
	
	[self didInit];
}

- (void)didInit
{
	
	
	_nColumns = [_flowdelegate numberOfColumnsInFlowView:self];
	
	
	
	self.dicReuseCells = [NSMutableDictionary dictionaryWithCapacity:4];
	
	//每列用一个数组保存高度
	self.arrCellHeight = [NSMutableArray arrayWithCapacity:_nColumns];
	
	//整个scrollview的高度
	float maxHeight = 0;

	self.arrVisibleCells = [NSMutableArray arrayWithCapacity:_nColumns];
	
	
	//保存所有cell的高度
	for(int i = 0; i < _nColumns; i++)
	{
	    NSMutableArray *arrEachcell_ = [NSMutableArray arrayWithCapacity:12];
		[_arrVisibleCells addObject:arrEachcell_];
		
		int numberOfColums_ = [_flowdelegate flowView:self numberOfRowsInColumn:i];
		
		NSMutableArray *arrEachColumns_ = [NSMutableArray arrayWithCapacity:numberOfColums_];
		[_arrCellHeight addObject:arrEachColumns_];
		
		float fTotal_ = 0;
		for(int j = 0 ; j < numberOfColums_ ; j ++)
		{
			float fHeight_ = [_flowdelegate flowView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
		//	NSLog(@"height = %f", fHeight_);
			fTotal_ += fHeight_;
			[arrEachColumns_ addObject:[NSNumber numberWithFloat:fTotal_]];
		}
		
		maxHeight = (maxHeight >= fTotal_) ? maxHeight : fTotal_;
	}
	
	//取最大的高度作为scrollview的contensize 的height；
	self.contentSize = CGSizeMake(self.frame.size.width, maxHeight);
	[self pageChanged];
}

- (void)pageChanged
{
	CGPoint offset = self.contentOffset;
	
	
	//判断每一列的 需要添加和移除的cell
	for( int i = 0; i < _nColumns; i++)
	{
		float origionx_ = i * (320.0 / _nColumns);
		float feachWidth = 320.0 / _nColumns;
		
		NSArray *arrEachHeigth_ = [_arrCellHeight objectAtIndex:i];
		NSMutableArray *arrEachCell_ = [_arrVisibleCells objectAtIndex:i];
		
		//当前列的当前显示在页面上的第一个cell
		LLWaterFlowCell *cell = nil;
		if(arrEachCell_ == nil || [arrEachCell_ count] == 0)
		{
			int cRow_ = 0;
			//确定当前需要加载的第一行 是哪一行
			for( int j = 0; j < [arrEachHeigth_ count] - 1; j++)
			{
				float eachHeigth_ = [[arrEachHeigth_ objectAtIndex:j] floatValue];
				if(eachHeigth_ < offset.y)
				{
					cRow_++;
				}
			}
			
			NSLog(@"first Loaddata row = %d", cRow_);
			
			float origony_ = 0;
			float heigth_ = 0;
			if(cRow_ == 0)
			{
				origony_ = 0;
				heigth_ = [[arrEachHeigth_ objectAtIndex:cRow_] floatValue];
			}
			else if(cRow_   < [arrEachHeigth_ count] ) {
				origony_ = [[arrEachHeigth_ objectAtIndex:cRow_ - 1] floatValue];
				heigth_  = [[arrEachHeigth_ objectAtIndex:cRow_ ] floatValue] - origony_;
			}
			
			cell = [_flowdelegate flowView:self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cRow_ inSection:i]];
			cell.indexPath = [NSIndexPath indexPathForRow: cRow_ inSection:i];
			cell.frame = CGRectMake(origionx_, origony_, feachWidth, heigth_);
			[self addSubview:cell];
			[arrEachCell_ insertObject:cell atIndex:0];
		}
		
		else 
		{
			cell = [arrEachCell_ objectAtIndex:0];
		}
		
		//NSLog(@"cell.frame = %@", NSStringFromCGRect(cell.frame));
		//加载上面的 
		while ( cell && ((cell.frame.origin.y - offset.y) > 0.0001)) 
		{
			int cRow_ = cell.indexPath.row;
			float origony_ = 0;
			float heigth_ = 0;
			
			if(cRow_ == 0)
			{
				cell = nil;
				continue;
			}
			
			//当前是第一行， 需要加载第0行
			else if(cRow_ == 1)
			{
				origony_ = 0;
				heigth_ = [[arrEachHeigth_ objectAtIndex:cRow_ - 1] floatValue];
			}
			
			else if(cRow_   < [arrEachHeigth_ count] ) {
				origony_ = [[arrEachHeigth_ objectAtIndex:cRow_ - 2] floatValue];
				heigth_  = [[arrEachHeigth_ objectAtIndex:cRow_ - 1] floatValue] - origony_;
			}

			cell = [_flowdelegate flowView:self cellForRowAtIndexPath:[NSIndexPath indexPathForRow: cRow_> 0 ? (cRow_ - 1) : 0 inSection:i]];
			cell.indexPath = [NSIndexPath indexPathForRow:cRow_ > 0 ? (cRow_ - 1) : 0 inSection:i];
			cell.frame = CGRectMake(origionx_, origony_, feachWidth, heigth_);
			
			NSLog(@"加载上面的.....");
			NSLog(@"crow- = %d", cRow_);
			NSLog(@"section = %d, row = %d , frame = %@", cell.indexPath.section, cell.indexPath.row, NSStringFromCGRect(cell.frame));
			[arrEachCell_ insertObject:cell atIndex:0];
			
			[self addSubview:cell];
			
			if(cRow_ == 0)
				break;
		}
		
		//去掉上面的
		while (cell &&  ((cell.frame.origin.y + cell.frame.size.height  - offset.y) <  0.0001)) 
		{
			NSLog(@"去掉上面的.....");
			NSLog(@"section = %d, row = %d", cell.indexPath.section, cell.indexPath.row);
			[cell removeFromSuperview];
			[self addCellToReuseQueue:cell];
			[arrEachCell_ removeObject:cell];
			
			if(arrEachCell_.count > 0)
			{
				cell = [arrEachCell_ objectAtIndex:0];
			}
			else {
				cell = nil;
			}
		}
		
		//==================================================================================
		//加载下面的
		
		cell = [arrEachCell_ lastObject];
		while (cell &&  ((cell.frame.origin.y + cell.frame.size.height - self.frame.size.height - offset.y) <  0.0001)) 
		{
			NSLog(@"加载下面的.....");
		//	NSLog(@"cell.frame = %@", NSStringFromCGRect(cell.frame));
			int cRow_ = cell.indexPath.row;
			float origony_ = 0;
			float heigth_ = 0;
			
			//if(cRow_ ==
			
			if(cRow_ == [arrEachHeigth_ count] - 1)
			{
				origony_ = 0;
				cell = nil;
				break;;
			}
			
			else 
			{
				origony_ = [[arrEachHeigth_ objectAtIndex:cRow_ ] floatValue];
				heigth_  = [[arrEachHeigth_ objectAtIndex:cRow_ + 1] floatValue] - origony_;
			}
			
			cell = [_flowdelegate flowView:self cellForRowAtIndexPath:[NSIndexPath indexPathForRow: cRow_ + 1 inSection:i]];
			cell.indexPath = [NSIndexPath indexPathForRow:cRow_ + 1 inSection:i];
			cell.frame = CGRectMake(origionx_, origony_, feachWidth, heigth_);
			[arrEachCell_ addObject:cell];
			
			[self addSubview:cell];
		}
		
		//去掉下面的
		while (cell &&  ((cell.frame.origin.y - self.frame.size.height - offset.y) > 0.0001)) 
		{
		//	NSLog(@"去掉下面的.....");
			[cell removeFromSuperview];
			
			[self addCellToReuseQueue:cell];
			[arrEachCell_ removeObject:cell];
			
			if(arrEachCell_.count > 0)
			{
				cell = [arrEachCell_ lastObject];
			}
			else {
				cell = nil;
			}
		}
	}
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if([_flowdelegate  conformsToProtocol:@protocol(UIScrollViewDelegate)]  && [_flowdelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
	{
		[(id<UIScrollViewDelegate>) _flowdelegate  scrollViewDidEndDecelerating:self];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self pageChanged];
	
	NSLog(@"subviewcont = %d", [self.subviews count]);
	
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//NSLog(@"scrollViewDidScroll = %@", NSStringFromCGPoint(scrollView.contentOffset));
	[self pageChanged];
	
	NSLog(@"subviewcont = %d", [self.subviews count]);
	
	if([_flowdelegate  conformsToProtocol:@protocol(UIScrollViewDelegate)]  && [_flowdelegate respondsToSelector:@selector(scrollViewDidScroll:)])
	{
		[(id<UIScrollViewDelegate>) _flowdelegate  scrollViewDidScroll:self];
	}
	
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
	
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	
}	


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	return YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	
}





- (void)dealloc {
    [super dealloc];
}

@end


//-------------------------------------------------------------------------------------------------------------------------------
//
//
//LLWaterFlowCell
//
//-------------------------------------------------------------------------------------------------------------------------------
@implementation LLWaterFlowCell
@synthesize indexPath = _indexPath;
@synthesize strReuseIndentifier = _strReuseIndentifier;

-(id)initWithIdentifier:(NSString *)indentifier
{
	if(self = [super init])
	{
		self.strReuseIndentifier = indentifier;
	}
	
	return self;
}
- (void)dealloc
{
	self.indexPath = nil;
	self.strReuseIndentifier = nil;
	[super dealloc];
}
@end
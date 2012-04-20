//
//  LLWaterFlowView.h
//  waterFlow
//
//  Created by kindy_imac on 12-2-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


//爱生活 爱分享，爱拍拍
#import <UIKit/UIKit.h>
@protocol LLWaterFlowViewDelegate;
@class LLWaterFlowCell;

//LL = Lin & Lin

@interface LLWaterFlowView : UIScrollView
<UIScrollViewDelegate>
{
	//data 
	int _nColumns ; // 列数
	
	NSMutableArray *_arrCellHeight; //cell 高度
	NSMutableArray *_arrVisibleCells; // 当前可见的cell
	NSMutableDictionary *_dicReuseCells; //重用的cell
	
	id <LLWaterFlowViewDelegate> _flowdelegate;
}


- (void)reloadData;
- (void)didInit;
- (void)pageChanged;


//获取重用的cell
- (LLWaterFlowCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;


//将要移除屏幕的cell添加到可重用列表中
- (void)addCellToReuseQueue:(LLWaterFlowCell *)cell;

@property (nonatomic, retain) NSMutableArray *arrCellHeight;
@property (nonatomic, retain) NSMutableArray *arrVisibleCells;
@property (nonatomic, retain) NSMutableDictionary *dicReuseCells;
@property (nonatomic, assign) id <LLWaterFlowViewDelegate> flowdelegate;
@end



//-------------------------------------------------------------------------------------------------------------------------------
//
//
//LLWaterFlowViewDelegate
//
//-------------------------------------------------------------------------------------------------------------------------------
@protocol LLWaterFlowViewDelegate<NSObject>
@required
- (NSUInteger)numberOfColumnsInFlowView:(LLWaterFlowView *)flowView;
- (NSInteger)flowView:(LLWaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column;
- (LLWaterFlowCell *)flowView:(LLWaterFlowView *)flowView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)flowView:(LLWaterFlowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
	

@end


//-------------------------------------------------------------------------------------------------------------------------------
//
//
//LLWaterFlowCell
//
//-------------------------------------------------------------------------------------------------------------------------------
@interface LLWaterFlowCell:UIView
{
	NSIndexPath *_indexPath; //位置
	NSString *_strReuseIndentifier; //重用标识
}

@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) NSString *strReuseIndentifier;


-(id)initWithIdentifier:(NSString *)indentifier;

@end
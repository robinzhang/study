//
//  waterFlowViewController.m
//  waterFlow
//
//  Created by kindy_imac on 12-2-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "waterFlowViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation waterFlowViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	_nCount = 1;
	
	flowView = [[LLWaterFlowView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	flowView.flowdelegate = self;
	flowView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:flowView];
	//[flowView release];
	
	[flowView setContentOffset:CGPointMake(0, 300)];
	
	
	UIButton *btn  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn.frame = CGRectMake(10, 410, 300, 40);
	[btn setTitle:@"加载下20条" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(press) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
}


- (void)press
{
	
	_nCount++;
	
	[flowView reloadData];
}

- (NSUInteger)numberOfColumnsInFlowView:(LLWaterFlowView *)flowView
{
	return 3;
}
- (NSInteger)flowView:(LLWaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
	return  _nCount * 20;;
}
- (LLWaterFlowCell *)flowView:(LLWaterFlowView *)flowView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellTag_Airport_weather";
	LLWaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[LLWaterFlowCell alloc] initWithIdentifier:CellIdentifier] autorelease];
		
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:iv];
		iv.layer.borderColor = [[UIColor whiteColor] CGColor];
		iv.layer.borderWidth = 4;
		[iv release];
		iv.tag = 101;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		[cell addSubview:label];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont boldSystemFontOfSize:30];
		label.shadowOffset = CGSizeMake(0, 1);
		label.shadowColor = [UIColor redColor];
		label.textColor = [UIColor whiteColor];
		[label release];
		label.tag = 102;
	}
	
	else 
	{
		NSLog(@"此条是从重用列表中获取的。。。。。");
	}

	
	float hei = [self flowView:nil heightForRowAtIndexPath:indexPath];
	
	UIImageView *iv  = (UIImageView *)[cell viewWithTag:101];
	iv.frame = CGRectMake(5, 5, 100, hei - 10);
	iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"img%d.png", (indexPath.row + indexPath.section + 1)  % 7 + 1]];
	
	UILabel *label = (UILabel *)[cell viewWithTag:102];
	label.frame = CGRectMake(3, 5, 100, hei - 10);
	label.text = [NSString stringWithFormat:@"%d", indexPath.row];
	
	return cell;
}
- (CGFloat)flowView:(LLWaterFlowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	float heigth= 0;
	switch ((indexPath.row + indexPath.section + 1)  % 7) {
		case 0:
			heigth = 147 + 10;
			break;
		case 1:
			heigth = 240 + 10;
			break;
		case 2:
			heigth = 200 + 10;
			break;
		case 3:
			heigth = 150 + 10;
			break;
		case 4:
			heigth = 147 + 10;
			break;
		case 5:
			heigth = 200 + 10;
			break;

		case 6:
			heigth = 100 + 10;
			break;
		case 7:
			heigth = 127 + 10;
			break;
		
		default:
			break;
	}
	
	heigth += (indexPath.section *2);
	
	return heigth;
}



#pragma mark -
#pragma UIScrollViewDelegate methods

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGPoint pt = scrollView.contentOffset;
	
	NSLog(@"scrollViewDidScroll = %@", NSStringFromCGPoint(scrollView.contentOffset));

	if(((pt.y + scrollView.frame.size.height	- scrollView.contentSize.height) > 0) && !scrollView.dragging)
	{
		
		NSLog(@"scrollViewDidScroll fjlaf; = %@", NSStringFromCGPoint(scrollView.contentOffset));

		_nCount++;
		
		[flowView reloadData];
	}
}
 */

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

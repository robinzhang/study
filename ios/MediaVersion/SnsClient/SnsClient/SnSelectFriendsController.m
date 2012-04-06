//
//  SnSelectFriendsController.m
//  SnsClient
//
//  Created by  on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnSelectFriendsController.h"

@implementation SnSelectFriendsController
@synthesize delegate = _delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _me = [UserHelper GetUserID];
        self.tableViewStyle = UITableViewStylePlain;
        self.variableHeightRows = YES;
        self.title = @"同时报料给";
        _seNames = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    
    
    TTButton *rbtn = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"确认"  ]; 
    [rbtn addTarget:self action:@selector(doSelectLocation:) forControlEvents:UIControlEventTouchUpInside];
    [rbtn sizeToFit];
    self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc] initWithCustomView:rbtn] autorelease];

    
    TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:NSLocalizedString(@"Cancel",@"取消")   ]; 
    [rbtn2 addTarget:self action:@selector(OnClick_btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [rbtn2 sizeToFit];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rbtn2] autorelease];

}

-(IBAction)OnClick_btnBack:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:self.navigationController.parentViewController animated:YES];
}

-(void)cancelSelectLocation:(id)sender
{
   // [self dismissModalViewController];
}

-(void)doSelectLocation:(id)sender
{
    NSString *titles = @"";
    NSString *names = @"";
    for (NSString* item in _source.selecteditems ) {
        titles = [NSString stringWithFormat:@"%@,%@",item,titles];
    }
    
    for (NSString* item in _seNames ) {
        names = [NSString stringWithFormat:@"%@,%@",item,names];
    }
    
    //[self.navigationController bringControllerToFront:self.presentedViewController animated:YES];
    [self.delegate didSelectFriends:titles names:names];
    //[self dismissModalViewController];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

-(void)createModel
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _source = [[SnSelectFriendDataSource alloc] initWithSearchQuery:_me sendType:1];
    self.dataSource = _source;
}

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if ([object isKindOfClass:[SnTableSelectItem class]]) {  
        SnTableSelectItem *item = (SnTableSelectItem *)object;
        if(item.selected == YES)
        {
            if([_source.selecteditems containsObject:item.userid])
                [_source.selecteditems removeObject:item.userid];
            
            if([_seNames containsObject:item.title])
                [_seNames removeObject:item.title];
        }
        else
        {
            [_source.selecteditems addObject:item.userid];
            [_seNames addObject:item.title];
        }
        
        
        item.selected = !item.selected;
        
        //self.selectedItems=[[NSMutableArray alloc] initWithArray:self.source.selecteditems];
        SnTableSelectItemCell *targetCustomCell = (SnTableSelectItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [targetCustomCell checkAction];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View lifecycle
-(void)setView:(UIView *)view
{
    if(view == nil)
        return;
    
    [super setView:view];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewDidUnload
{
    
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

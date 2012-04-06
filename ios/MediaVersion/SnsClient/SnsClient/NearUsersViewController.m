//
//  HomeViewController.m
//  SnsClient
//
//  Created by  on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NearUsersViewController.h"
#import "NearUsersDataSource.h"
#import <CoreLocation/CoreLocation.h>
#import "UserHelper.h"
#import "StyleSheet.h"
#import <MapKit/MapKit.h>
#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "AccessorizedCalloutMapAnnotationView.h"
#import "MessageMapAnnotationView.h"
#import "BasicMapAnnotationView.h"



@implementation NearUsersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Near",@"附近");
        //tab_fav
        UITabBarItem *item = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_message.png"] tag:0] autorelease];
       
        self.tabBarItem = item;
       
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


-(void)viewDidLoad
{
    _mapview=[[MKMapView alloc] init];
    _mapview.showsUserLocation=YES;
    _mapview.delegate=self;
    _mapview.mapType = MKMapTypeStandard;
    
    _messageType = 11;
    listType = 1;
    magicNumber = 0;
    
    locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    
    currentLocation=[[CLLocation alloc] initWithLatitude:39.916250 longitude:116.525130];
    
    CGRect frame=self.view.bounds;
    [_mapview setFrame:frame];

    
//    CGRect frame=self.view.bounds;
//    CGRect mapViewFrame;
//    mapViewFrame=frame;
//    mapViewFrame.size.height=frame.size.height-42;
//    mapViewFrame.origin.y = 42;
//    [_mapview setFrame:mapViewFrame];
//    [self.tableView setFrame:mapViewFrame];
//    [self.view addSubview:_mapview];
//    
//    [self initTitleView];
    [locManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UIButton *btn_img = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn_img setFrame:CGRectMake(0, 0, 31, 33)];
//    [btn_img setBackgroundImage:TTIMAGE(@"bundle://btn_icon_refresh_wt-new.png") forState:UIControlStateNormal];
//    [btn_img addTarget:self action:@selector(doRefresh) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:btn_img] ;
    
    TTButton *btn = [TTButton buttonWithStyle:@"blueImgToolbarButton:" title:nil]; 
    [btn setImage:@"bundle://btn_icon_refresh_wt.png" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doRefresh) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 36, 34)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];  
    
    
//    UIBarButtonItem *btn =[[UIBarButtonItem alloc]  initWithImage:TTIMAGE(@"bundle://btn_icon_refresh_wt.png") style:UIBarButtonItemStyleBordered target:self action:@selector(doRefresh)];
//    btn.width = 35;
//    self.navigationItem.leftBarButtonItem =btn;
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}


- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    //[self dismissModalViewController];
    
    //TTTableMessageItem *item = (TTTableMessageItem*)object;
    
    //[_delegate didSelectObject:item.userid];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setListType];
}


-(void)doRefresh
{

    [self setListType];
}

#pragma mark Location
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapView:(MKMapView *)mv annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSString *url = [NSString stringWithFormat:@"tt://message/?messageid=%@&userid=%@&username=%@&userface=%@"
                     ,_calloutAnnotation.post.MessageID
                     ,_calloutAnnotation.post.UserID
                     ,[_calloutAnnotation.post.UserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
                     ,_calloutAnnotation.post.UserFace];
    TTOpenURL(url);
}


- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CalloutMapAnnotationView *calloutMapAnnotationView = [[[AccessorizedCalloutMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutAnnotation"] autorelease];
        CalloutMapAnnotation *anno=(CalloutMapAnnotation*)annotation;
        calloutMapAnnotationView.post=anno.post;
        calloutMapAnnotationView.contentHeight = 164;
        
        MessageMapAnnotationView *v=[[MessageMapAnnotationView alloc] initWithPost:anno.post];
        v.frame=CGRectMake(5, 2, 285, 164);
        
        [calloutMapAnnotationView.contentView addSubview:v];
        [v release];
		//}
		calloutMapAnnotationView.parentAnnotationView = _selectedAnnotationView;
		calloutMapAnnotationView.mapView = mapview;
        
		return calloutMapAnnotationView;
	} else if([annotation isKindOfClass:[BasicMapAnnotation class]]){
        BasicMapAnnotationView *annotationView = [[[BasicMapAnnotationView alloc] initWithAnnotation:annotation 
                                                                                     reuseIdentifier:@"CustomAnnotation"] autorelease];
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorGreen;
        CalloutMapAnnotation *anno=(CalloutMapAnnotation*)annotation;
        annotationView.post=anno.post;
		return annotationView;
    }else {
        if (annotation==mapview.userLocation) {
            return nil;
        }
		MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
																			   reuseIdentifier:@"BehindCalloutAnnotation"] autorelease];
		annotationView.canShowCallout = YES;
		//annotationView.pinColor = MKPinAnnotationColorRed;
		return annotationView;
	}
	return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapView:(MKMapView *)mv didSelectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation) {
        [mv removeAnnotation:_calloutAnnotation];
    }
    
	//if (view.annotation == self.customAnnotation) {
    if ([view isKindOfClass:[BasicMapAnnotationView class]]){
        BasicMapAnnotationView *callout=(BasicMapAnnotationView*)view;
        _calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                               andLongitude:view.annotation.coordinate.longitude 
                                                                       post:callout.post];

        [mv addAnnotation:_calloutAnnotation];
        _selectedAnnotationView = callout;
        magicNumber+=1;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapView:(MKMapView *)mv didDeselectAnnotationView:(MKAnnotationView *)view {
    if (magicNumber>1 ) {
        magicNumber=magicNumber-1;
        return;
    }
	if (_calloutAnnotation ) {
		[mv removeAnnotation: _calloutAnnotation];
        magicNumber=magicNumber-1;
	}
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
        BasicMapAnnotation *anno=annotationView.annotation;
        currentLocation= [[CLLocation alloc] initWithLatitude:anno.coordinate.latitude longitude:anno.coordinate.longitude];
	}
}

///////////////////////////CLLocationManagerDelegate////////////////////////////////////////
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	currentLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [locManager stopUpdatingLocation];
    [self setListType];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)gotoLocation:(CLLocation *)location {
    
    CLLocationCoordinate2D loc = [location coordinate];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    //self.currentLocation=location;
    
    span.latitudeDelta=0.02f; //zoom level
    span.longitudeDelta=0.02f; //zoom level
    
    region.span=span;
    region.center=loc;
    
    [_mapview setRegion:region animated:YES];
    [_mapview regionThatFits:region];
    
    
    //[helper notifyMessageByLocation:location];
}


-(void)initTitleView
{
    // segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   @"所有给我",    //11
                                   @"指定给我",     //8
                                   @"我朋友的", //3
                                   @"我关注的",   //2
								   nil];
    
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(onMessageTypeChange:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor = TTSTYLEVAR(navigationBarTintColor);
    
    UIToolbar *toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
    
    UIBarButtonItem *btnPostMessage= [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    
    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc]                                              
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace                              
                                                target:nil action:nil];
    
    toobar.items = [NSArray arrayWithObjects:
                    flexibleSpaceButtonItem,
                    btnPostMessage,
                    flexibleSpaceButtonItem,
                    nil];
    
    toobar.tintColor = TTSTYLEVAR(navigationBarTintColor);
    [self.view addSubview:toobar];
    [toobar release];
    
    [btnPostMessage release];
	[segmentedControl release];
    [flexibleSpaceButtonItem release];
}

-(void)onMessageTypeChange:(id)sender
{
    UISegmentedControl *segmentedControl =(UISegmentedControl*)sender;
    if(segmentedControl.selectedSegmentIndex == 0)
    {
        _messageType = 11;
    }
    if(segmentedControl.selectedSegmentIndex == 1)
    {
        _messageType = 8;
    }
    if(segmentedControl.selectedSegmentIndex == 2)
    {
        _messageType = 3;
    }
    if(segmentedControl.selectedSegmentIndex == 3)
    {
        _messageType = 2;
    }
    [self createModel];
    [self setListType];
}

-(void)setListType
{
    if (listType == 1 && [_mapview superview]) {
        [UIView beginAnimations:@"animationOut" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES]; 
        [_mapview removeFromSuperview];
        [UIView commitAnimations];
    }
    else if(listType != 1 && ![_mapview superview]) 
    {
        [UIView beginAnimations:@"animationIn" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES]; 
        [self.view addSubview:_mapview];
        [UIView commitAnimations];
    }
    
    if(listType == 1)
    {
        TTButton *btn = [TTButton buttonWithStyle:@"blueImgToolbarButton:" title:nil]; 
        [btn setImage:@"bundle://btn_list.png" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(swithListType) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(0, 0, 36, 34)];
      
//        UIButton *btn_img = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn_img setFrame:CGRectMake(0, 0, 34, 30)];
//        [btn_img setBackgroundImage:TTIMAGE(@"bundle://btn_list.png") forState:UIControlStateNormal];
//        [btn_img addTarget:self action:@selector(swithListType) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:btn];
       
        [self refresh];
    }
    else
    {
//        UIButton *btn_img = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn_img setFrame:CGRectMake(0, 0, 34, 30)];
//        [btn_img setBackgroundImage:TTIMAGE(@"bundle://btn_grid.png") forState:UIControlStateNormal];
//        [btn_img addTarget:self action:@selector(swithListType) forControlEvents:UIControlEventTouchUpInside];
        
        TTButton *btn = [TTButton buttonWithStyle:@"blueImgToolbarButton:" title:nil]; 
        [btn setImage:@"bundle://btn_grid.png" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(swithListType) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(0, 0, 36, 34)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn]; 
        
        
        [self gotoLocation:currentLocation];
        
       // if([self.model isLoaded])
        //{
           [_mapview removeAnnotations:_mapview.annotations];
           [_mapview addAnnotation:_mapview.userLocation];
           // HomeViewModel *ds=(HomeViewModel*)self.model;
            for (UserProfile* entry in _posts) {
                BasicMapAnnotation *customAnnotation = [[[BasicMapAnnotation alloc] initWithLatitude:entry.Latitude andLongitude:entry.Longitude post:nil] autorelease];
                [_mapview addAnnotation:customAnnotation];
            }
       // }
    }
 
}



-(void)swithListType
{
    if(listType == 1)
        listType = 0;
    else
        listType = 1;

    [self setListType];
    //[UserHelper SetHomeListType:listType];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    //CLLocation *nowlocation=currentLocation;
    //NSString *userid = [UserHelper GetUserID];
    self.dataSource =  [[NearUsersDataSource alloc] initWithSearchQuery:currentLocation range:@"2000"];

    [self gotoLocation:currentLocation];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) modelDidFinishLoad:(id<TTModel>)model{
   
    NearUsersModel *smodle = (NearUsersModel*)self.model;
    _posts = smodle.posts;
    [self setListType];
     [super modelDidFinishLoad:model];
}



#pragma mark - View lifecycle
-(void)dealloc
{
    [locManager release];
    [super dealloc];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

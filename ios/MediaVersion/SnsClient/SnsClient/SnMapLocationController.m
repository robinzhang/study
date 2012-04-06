//
//  UIMapLocationController.m
//  SnsClient
//
//  Created by  on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnMapLocationController.h"
#define K_SearchBarHeight 45

@implementation SnMapLocationController
@synthesize delegate = _delegate;
@synthesize maddress = _maddress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       self.title = @"新闻发生地";
        _stopCallAdress = NO;
    }
    return self;
}

-(void)viewDidLoad
{
    _mapview=[[MKMapView alloc] init];
    _mapview.showsUserLocation=YES;
    _mapview.delegate=self;
    _mapview.scrollEnabled = YES;
    _mapview.zoomEnabled = YES;
    _mapview.mapType = MKMapTypeStandard;
    CGRect frame=self.view.bounds;
    [_mapview setFrame:CGRectMake(0, 45, frame.size.width, frame.size.height- K_SearchBarHeight )];
    [self.view addSubview:_mapview];
    
//    _searchKey = [[UITextField alloc] init];
//    [_searchKey setBorderStyle:UITextBorderStyleRoundedRect];
//    [_searchKey  setFrame:CGRectMake(15, 10, frame.size.width - 60 - 10 - 30, 25)];
//    [self.view addSubview:_searchKey];
//    
//    _btnSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_btnSearch setTitle:@"Search" forState:UIControlStateNormal];
//    [_btnSearch addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
//    [_btnSearch setFrame:CGRectMake(frame.size.width - 100 + 15, 10, 60, 25)];
//    [self.view addSubview:_btnSearch];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, K_SearchBarHeight)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.tintColor = TTSTYLEVAR(searchBarTintColor);
    [self.view addSubview:_searchBar];
    
    self.maddress = @"";
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(frame.size.width, 10+25, 320, 320-30) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tableView];
    
    googleLocalConnection = [[GoogleLocalConnection alloc] initWithDelegate:self]; 
    
    loadingView = [[TTActivityLabel alloc] initWithFrame:CGRectMake(60, 100, 200, 80) style:TTActivityLabelStyleBlackBezel text:NSLocalizedString(@"Searching", @"Searching")];
    
    //locManager = [[CLLocationManager alloc] init];
    //locManager.delegate = self;
    
    centerpoint = [[BasicMapAnnotation alloc] init];
    [_mapview addAnnotation:centerpoint];
    
    coordinate = [UserHelper GetUserLocation].coordinate ;
}

-(void)reset
{
    coordinate = [UserHelper GetUserLocation].coordinate ;
    self.maddress = @"";
}

/////////////////////////////CLLocationManagerDelegate////////////////////////////////////////
//- (void)locationManager:(CLLocationManager *)manager
//	didUpdateToLocation:(CLLocation *)newLocation
//		   fromLocation:(CLLocation *)oldLocation
//{
//	[self gotoLocation:newLocation];
//    [manager stopUpdatingLocation];
//}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//	//CLLocation *newLocation=[[CLLocation alloc] initWithLatitude:39.916250 longitude:116.525130];
//    [self gotoLocation:[UserHelper GetUserLocation]];
//    [manager stopUpdatingLocation];
//}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)goPin:(CLLocationCoordinate2D)location {
    
    CLLocationCoordinate2D loc = location;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta=0.01f; //zoom level
    span.longitudeDelta=0.01f; //zoom level
    
    region.span=span;
    region.center=loc;
    
    coordinate = location;
    
    [_mapview setRegion:region animated:YES];
    [_mapview regionThatFits:region];
    
    //[_mapview removeAnnotations:_mapview.annotations];
    //centerpoint.title = geoAddress;
    //centerpoint.subtitle = [NSString stringWithFormat:@"@f,@f",location.latitude,location.longitude];
    //centerpoint.coordinate = loc;
    //[_mapview addAnnotation:centerpoint];
    //[centerpoint release];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)gotoLocation:(CLLocation *)location {
//    
//    CLLocationCoordinate2D loc = [location coordinate];
//    [self goPin:loc];
//}


-(void)dealloc
{
    [super dealloc];
    //TT_RELEASE_SAFELY(_mapview);
    //TT_RELEASE_SAFELY(_searchKey);
    //TT_RELEASE_SAFELY(_searchBar);
}

-(void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];

    TTButton *rbtn2 = [TTButton buttonWithStyle:@"blueButtonStyle:" title:@"确认" ]; 
    [rbtn2 addTarget:self action:@selector(doSelectLocation:) forControlEvents:UIControlEventTouchUpInside];
    [rbtn2 sizeToFit];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rbtn2] autorelease];

    
    [self goPin:coordinate];
    
    TTButton *rbtn = [TTButton buttonWithStyle:@"blueButtonStyle:" title:NSLocalizedString(@"Cancel",@"取消")  ]; 
    [rbtn addTarget:self action:@selector(OnClick_btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [rbtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rbtn] autorelease];
    
    CGRect frame=self.view.bounds;
    [_mapview setFrame:CGRectMake(0, 45, frame.size.width, frame.size.height- K_SearchBarHeight )];
}

-(IBAction)OnClick_btnBack:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:self.navigationController.parentViewController animated:YES];
}

-(void)cancelSelectLocation:(id)sender
{
   //[self dismissModalViewController];
}

-(void)doSelectLocation:(id)sender
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [_delegate didSelectLocation:location adress: self.maddress];
}

#pragma mark - searchBar 
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (![loadingView superview]) {
        [self.view addSubview:loadingView];
    }
    
    [_searchBar resignFirstResponder];
    // [_searchKey resignFirstResponder];
    //[googleLocalConnection getGoogleObjectsWithQuery:_searchKey.text 
    [googleLocalConnection getGoogleObjectsWithQuery:_searchBar.text 
                                        andMapRegion:[_mapview region] 
                                  andNumberOfResults:8 
                                       addressesOnly:NO 
                                          andReferer:@"http://mysuperiorsitechangethis.com"];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
//    [UIView beginAnimations:@"showSearchBar" context:nil];
//    [UIView setAnimationDuration:0.2];
//    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    [UIView setAnimationRepeatAutoreverses:NO];
//    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    tableView.left = self.view.bounds.size.width;
    tableView.dataSource = nil;
    [tableView reloadData];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [UIView commitAnimations];
}

//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    [UIView beginAnimations:@"showSearchBar" context:nil];
//    [UIView setAnimationDuration:0.2];
//    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    [UIView setAnimationRepeatAutoreverses:NO];
//    _searchBar.showsCancelButton = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [UIView commitAnimations];
//}

//- (void)doSearch
//{
//    if (![loadingView superview]) {
//        [self.view addSubview:loadingView];
//    }
//    
//     [_searchBar resignFirstResponder];
//   // [_searchKey resignFirstResponder];
//    //[googleLocalConnection getGoogleObjectsWithQuery:_searchKey.text 
//     [googleLocalConnection getGoogleObjectsWithQuery:_searchBar.text 
//                                        andMapRegion:[_mapview region] 
//                                  andNumberOfResults:8 
//                                       addressesOnly:NO 
//                                          andReferer:@"http://mysuperiorsitechangethis.com"];
//}



#pragma mark - GoogleLocalConnection 
- (void) googleLocalConnection:(GoogleLocalConnection *)conn didFinishLoadingWithGoogleLocalObjects:(NSMutableArray *)objects andViewPort:(MKCoordinateRegion)region
{
        if ([loadingView superview]) {
               [loadingView removeFromSuperview];
        }
    
    if ([objects count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有匹配的地点." message:@"请尝试其他关键字或移动地图." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        //[self doCancel];
    }
    else {
        searchArray=[[NSMutableArray alloc] initWithArray:objects];
        tableView.dataSource=self;
        tableView.delegate=self;
        [tableView reloadData];
        tableView.left = 0;
        
        //[_mapView removeAnnotations:_mapView.annotations];
        //[_mapView addAnnotations:objects];
        //[self bringSubviewToFront:tableView];
    }
}


- (void) googleLocalConnection:(GoogleLocalConnection *)conn didFailWithError:(NSError *)error
{
    if ([loadingView superview]) {
        [loadingView removeFromSuperview];
    }
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有匹配的地点." message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(searchArray.count<7)
        return searchArray.count;
    else
        return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    GoogleLocalObject *obj=(GoogleLocalObject*)[searchArray objectAtIndex:indexPath.row];
	cell.textLabel.text=obj.title;
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.detailTextLabel.text=obj.subtitle;
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
	//cell.textlabel.textcolor=;
	cell.accessoryType=UITableViewCellAccessoryNone;
	return cell;
    
}
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoogleLocalObject *obj=(GoogleLocalObject*)[searchArray objectAtIndex:indexPath.row];
    coordinate=obj.coordinate;
    _stopCallAdress = YES;
    
    [self goPin:obj.coordinate];
    [_searchBar setText:obj.title];
    _maddress  = obj.title;
    
    tableView.left = self.view.frame.size.width;
    //[_searchKey resignFirstResponder];
    [_searchBar resignFirstResponder];
    //[self startedReverseGeoderWithLatitude:obj.coordinate.latitude longitude:obj.coordinate.longitude];
}


#pragma mark -  ReverseGeoder
- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude{
	CLLocationCoordinate2D coordinate2D;
	coordinate2D.longitude = longitude;
	coordinate2D.latitude = latitude;
    
    
    geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D];
    geoCoder.delegate = self;
    [geoCoder start];
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    
}

///////////////////////////////////MKReverseGeocoderDelegate///////////////////////////////////
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    //    NSString *address=@"";
    NSString *addressShorten=@"";
    //    if ([placemark.administrativeArea isEqualToString:placemark.locality]) {
    //        address = [NSString stringWithFormat:@"%@ %@ %@ %@%@", 
    //                   placemark.country,
    //                   placemark.administrativeArea,
    //                   placemark.subLocality,
    //                   placemark.thoroughfare,
    //                   placemark.subThoroughfare];
    //    }else{
    //        address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@%@", 
    //                   placemark.country,
    //                   placemark.administrativeArea,
    //                   placemark.locality,
    //                   placemark.subLocality,
    //                   placemark.thoroughfare,
    //                   placemark.subThoroughfare];
    //    }
    
    addressShorten = [NSString stringWithFormat:@"%@%@%@", 
                      placemark.subLocality,
                      placemark.thoroughfare,
                      placemark.subThoroughfare];
    
    
    //    address=[address stringByReplacingOccurrencesOfString:@"(null)"
    //                                            withString:@""];
    //    address=[address stringByReplacingOccurrencesOfString:@"null"
    //                                               withString:@""];
    //    address=[address stringByReplacingOccurrencesOfString:@"  "
    //                                               withString:@" "];
    
    addressShorten=[addressShorten stringByReplacingOccurrencesOfString:@"(null)"
                                                             withString:@""];
    addressShorten=[addressShorten stringByReplacingOccurrencesOfString:@"null"
                                                             withString:@""];
    addressShorten=[addressShorten stringByReplacingOccurrencesOfString:@"  "
                                                             withString:@" "];
    
    [_searchBar setText:addressShorten];
     self.maddress = addressShorten;
    //_searchKey.text=addressShorten;
    //geoAddress=addressShorten;
    
	geocoder = nil;
}



#pragma mark - View mapView
///////////////////////////////////MKMapViewDelegate/////////////////////////////////////////
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    [_mapview removeAnnotations:_mapview.annotations];
    [_mapview addAnnotation:_mapview.userLocation];
    
    BasicMapAnnotation *customAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:newLocation.coordinate.latitude andLongitude:newLocation.coordinate.longitude post:nil]; 
    [_mapview addAnnotation:customAnnotation];
    
    //[newLocation release];
    coordinate =[mapView convertPoint:mapView.center toCoordinateFromView:mapView];
    if(_stopCallAdress == YES)
        _stopCallAdress = NO;
    else
        [self startedReverseGeoderWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

////////////////////////////////// mapView  didChangeDragState ///////////////////////
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
        BasicMapAnnotation *anno=annotationView.annotation;
        coordinate=anno.coordinate;
	}
}

//-(void)initToobar
//{
//    UIToolbar *toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
//    

//    
//    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc]                                              
//                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace                              
//                                                target:nil action:nil];
//    
//    toobar.items = [NSArray arrayWithObjects:
//                    leftBarButton,
//                    flexibleSpaceButtonItem,
//                    rightBarButton,
//                    nil];
//    
//    toobar.tintColor = RGBCOLOR(0, 125, 215);
//    [self.view addSubview:toobar];
//}

//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//   }


- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[BasicMapAnnotation class]]){
        BasicMapAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"];
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorGreen;
        CalloutMapAnnotation *anno=(CalloutMapAnnotation*)annotation;
        annotationView.post=anno.post;
		return annotationView;
    }
    else 
    {
        if (annotation==mapview.userLocation) {
            return nil;
        }
		MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation 
																			   reuseIdentifier:@"BehindCalloutAnnotation"];
		annotationView.canShowCallout = YES;
		return annotationView;
	}
	return nil;
}


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

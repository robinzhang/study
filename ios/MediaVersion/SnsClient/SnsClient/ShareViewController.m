//
//  ShareViewController.m
//  SnsClient
//
//  Created by  on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"
#import "UserHelper.h"
#import "ShareViewModel.h"
#import <MapKit/MapKit.h>
#import "SnInfoView.h"
#import <CoreLocation/CoreLocation.h>
#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "AccessorizedCalloutMapAnnotationView.h"
#import "MessageMapAnnotationView.h"
#import "BasicMapAnnotationView.h"
#import "SnsClientAppDelegate.h"


@implementation ShareViewController
//@synthesize uAppInfo= _uAppInfo;
@synthesize fristload = _fristload;
@synthesize reRange= _reRange;
@synthesize reLocation = _reLocation;
@synthesize mapview = _mapview, posts = _posts;

-(MKMapView*)mapview
{
    if(!_mapview)
    {
        _mapview=[[MKMapView alloc] init];
        //_mapview.showsUserLocation=YES;
        _mapview.delegate=self;
        _mapview.mapType = MKMapTypeStandard;
    }
    return _mapview;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"位置";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_map.png"] tag:0];

        _me = [UserHelper GetUserID];
        
        SnUserAppInfo  *uAppInfo = [UserHelper GetUserAppInfo];
        
        _reRange = uAppInfo.LastMapRange;
        _reLocation = [[CLLocation alloc] initWithLatitude:uAppInfo.MapCenterLa longitude:uAppInfo.MapCenterLo];
        CGRect frame=self.view.bounds;
        [self.mapview setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.view addSubview:self.mapview];
        
        
        
        _searcheBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
        _searcheBar.showsCancelButton = YES;
        _searcheBar.delegate = self;
        _searcheBar.tintColor = TTSTYLEVAR(searchBarTintColor);
        _searcheBar.placeholder =@"输入地名或邮编";
        //_searcheBar.showsSearchResultsButton = YES;
        //_searcheBar.showsScopeBar = YES;
        [self.view addSubview:_searcheBar];
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cancelButton setBackgroundColor:[UIColor clearColor]];
        [_cancelButton addTarget:self action:@selector(showSearchBar) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelButton];
        
        tableView=[[UITableView alloc] initWithFrame:CGRectMake(320, 45, 320, 420-45) style:UITableViewStyleGrouped];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:tableView];
        
        [self initEmptyView];

        self.posts= [[NSMutableArray alloc] init];
        
        loading = [[TTActivityLabel alloc] initWithFrame:CGRectMake(100, 80, 120, 25) style:TTActivityLabelStyleBlackBezel text:@"正在加载..."];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(doAfterPublish:) 
                                                     name:@"userPublishNewsSucc" 
                                                   object:nil];
        [self doRefreshLocation];
        _fristload = YES;
    }
    return self;
}

-(void)initEmptyView
{
    //////// -----  _nodataView ////
    _nodataView = [[UIView alloc] initWithFrame:CGRectMake(80, 80, 160, 80)];
    [_nodataView setBackgroundColor:[UIColor clearColor]];
    
    UIView *innerBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 80)];
    [innerBg setBackgroundColor:[UIColor blackColor]];
    innerBg.layer.masksToBounds = YES;  
    innerBg.layer.cornerRadius = 10;  
    [innerBg  setAlpha:0.5f];
    [_nodataView addSubview:innerBg];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"这里还是空位，等你来发新闻，或者移步其他地方如Beijing"];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    label.numberOfLines = 3;
    [label setTextAlignment:UITextAlignmentCenter];
    [label setFrame:CGRectMake(10, 10, 140, 60)];
    [label setBackgroundColor:[UIColor clearColor]];
    [_nodataView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:innerBg.frame];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(doSearchBeiJing) forControlEvents:UIControlEventTouchUpInside];
    [_nodataView addSubview:btn];
    
    [innerBg release];
    [label release];
    ////// -----  _nodataView ///////
}


-(void)doAfterPublish:(NSNotification*)notification
{
    
    SnUserAppInfo  *uAppInfo = [UserHelper GetUserAppInfo];
    CLLocation *newscoordinate = (CLLocation*)notification.object;
    uAppInfo.MapCenterLa = newscoordinate.coordinate.latitude;
    uAppInfo.MapCenterLo = newscoordinate.coordinate.longitude;
    uAppInfo.LastMapZoomX = 0.1f;
    uAppInfo.LastMapZoomY = 0.1f;
    uAppInfo.LastMapRange = 15000;
    
    ShareViewModel *model  = (ShareViewModel*)self.model;
    [model clearCache:_me range:uAppInfo.LastMapRange location:newscoordinate sendType:128 sendModel:2];
    model.location = newscoordinate;
    model.sendType = 128;
    model.sendModel = 2;
    model.range = uAppInfo.LastMapRange;
    model.userid = [UserHelper GetUserID];
    [model load:TTURLRequestCachePolicyNone more:NO];
    
    [UserHelper SetUserAppInfo:uAppInfo];
    
//    SnMessage *entry = [[SnMessage alloc] init];
//    BasicMapAnnotation *customAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:entry.Latitude andLongitude:entry.Longitude post:entry]; 
//    [self.mapview addAnnotation:customAnnotation];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    //listType = [UserHelper GetShareListType];
    magicNumber = 0;
    googleLocalConnection = [[GoogleLocalConnection alloc] initWithDelegate:self]; 
    
    
    TTButton *btn = [TTButton buttonWithStyle:@"blueImgToolbarButton:" title:nil]; 
    [btn setImage:@"bundle://user_location.png" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doRefreshLocation) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 36, 34)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];  
    
    TTButton *rbtn = [TTButton buttonWithStyle:@"blueImgToolbarButton:" title:nil]; 
    [rbtn setImage:@"bundle://white_search.png" forState:UIControlStateNormal];
    [rbtn addTarget:self action:@selector(showSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [rbtn setFrame:CGRectMake(0, 0, 36, 34)];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rbtn]; 

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden=YES;
    [super viewWillAppear:animated];
    
    //SnUserAppInfo  *uAppInfo = [UserHelper GetUserAppInfo];
    //self.uAppInfo = [UserHelper GetUserAppInfo];
    CGRect frame=self.view.bounds;
    [self.mapview setFrame:CGRectMake(0, KPageTitleHeight, frame.size.width, frame.size.height - KPageTitleHeight)];
    self.mapview.showsUserLocation = YES;
   
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(_fristload)
    {
        SnUserAppInfo  *uAppInfo = [UserHelper GetUserAppInfo];
        CLLocationCoordinate2D loc = [[CLLocation alloc] initWithLatitude:uAppInfo.MapCenterLa longitude:uAppInfo.MapCenterLo].coordinate;
    
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta=uAppInfo.LastMapZoomX;
        span.longitudeDelta=uAppInfo.LastMapZoomY;
        region.span=span;
        region.center=loc;
        [self.mapview regionThatFits:region];
        [self.mapview setRegion:region animated:YES];
        _fristload = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(self.mapview && [self.mapview superview])
    {
        SnUserAppInfo  *uAppInfo = [UserHelper GetUserAppInfo];
        uAppInfo.MapCenterLa = self.mapview.centerCoordinate.latitude;
        uAppInfo.MapCenterLo = self.mapview.centerCoordinate.longitude;
        uAppInfo.LastMapZoomX = self.mapview.region.span.latitudeDelta;
        uAppInfo.LastMapZoomY =  self.mapview.region.span.longitudeDelta;
        [UserHelper SetUserAppInfo:uAppInfo];
    }
    [super viewWillDisappear:animated];
}

-(void)showSearchBar
{ 
    [UIView beginAnimations:@"showSearchBar" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatAutoreverses:NO];
    if(_searcheBar.top < 0)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        loading.top = 100;
        [_searcheBar becomeFirstResponder];
        [_searcheBar setFrame:CGRectMake(0, 0, 320, 44)];
        [_cancelButton setFrame:CGRectMake(320-60, 0, 60, 30)];
        tableView.left = 0;
        tableView.dataSource = nil;
        [tableView reloadData];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        loading.top = 80;
        [_searcheBar resignFirstResponder];
        [_searcheBar setFrame:CGRectMake(0, -44, 320, 44)];
        tableView.left = self.view.frame.size.width;
    }
    [UIView commitAnimations];
    
    CGRect frame=self.view.bounds;
    [self.mapview setFrame:CGRectMake(0, KPageTitleHeight, frame.size.width, frame.size.height - KPageTitleHeight)];
}

-(void)doSearchBeiJing
{
    if([_nodataView superview])
        [_nodataView removeFromSuperview];
    _searcheBar.text = @"beijing";
    [self showSearchBar];
}

-(void)doRefreshLocation
{
    LocaltionHelper *localtionHelper = [[LocaltionHelper alloc] init];
    localtionHelper.useMonitoringSignificantLocationChanges = NO;
    localtionHelper.delegate = self;
    [localtionHelper startUpdatingLocation];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    [manager stopUpdatingLocation];
//}

///////////////////////////CLLocationManagerDelegate////////////////////////////////////////
- (void)didGetUserLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if ([newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp]<2) {
        return;
    }
    
    SnUserAppInfo  *uAppInfo = [UserHelper GetUserAppInfo];
    uAppInfo.LastMapZoomX = 0.1f;
    uAppInfo.LastMapZoomY = 0.1f;
    uAppInfo.LastMapRange = 15000;
    uAppInfo.MapCenterLa = newLocation.coordinate.latitude;
    uAppInfo.MapCenterLo = newLocation.coordinate.longitude;
    [UserHelper SetUserAppInfo:uAppInfo];
    
    if(_hasViewAppeared)
    {
        CLLocationCoordinate2D loc = newLocation.coordinate;
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta=0.1f;
        span.longitudeDelta=0.1f;
        region.span=span;
        region.center=loc;
        [self.mapview setRegion:region animated:YES];
        [self.mapview regionThatFits:region];
        [_searcheBar setText:@""];
        
        if(self.model)
        {
            if([self.model isLoading])
                [self.model cancel];
            
            
            ShareViewModel *model  = (ShareViewModel*)self.model;
            //[model clearCache:[UserHelper GetUserID] range:_uAppInfo.LastMapRange location:newLocation sendType:128 sendModel:2];
            model.location = newLocation;
            model.sendType = 128;
            model.sendModel = 2;
            model.range = uAppInfo.LastMapRange;
            model.userid = [UserHelper GetUserID];
            [model load:TTURLRequestCachePolicyDefault more:NO];
        }
    }
}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
//{
    //NSMutableString *errorString = [[NSMutableString alloc] init];
    
//    if ([error domain] == kCLErrorDomain) {
//        
//        // We handle CoreLocation-related errors here
//        switch ([error code]) {
//                // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
//                // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
//            case kCLErrorDenied:
//                [UserHelper doAlert:nil title:NSLocalizedString(@"Notice", @"警告") message:@"(001)该设备不支持定位服务！"];
//                break;
//            case kCLErrorLocationUnknown:
//                [UserHelper doAlert:nil title:NSLocalizedString(@"Notice", @"警告") message:@"(002)该设备不支持定位服务！"];
//                break;
//            default:
//                break;
//        }
//        
//        [UserHelper doAlert:nil title:NSLocalizedString(@"Notice", @"警告") message:@"该设备不支持定位服务！"];
//        
//    } else {
//        if (error.code==kCLErrorDenied) {
//            [UserHelper doAlert:nil title:NSLocalizedString(@"Notice", @"警告") message:NSLocalizedString(@"Location Permission Request", @"不允许看过使用定位服务会使您无法收到来自朋友的任何消息，请在系统设置中重新打开。")];
//        }
//    }
//}
#pragma mark GoogleLocalConnection
- (void) googleLocalConnection:(GoogleLocalConnection *)conn didFinishLoadingWithGoogleLocalObjects:(NSMutableArray *)objects andViewPort:(MKCoordinateRegion)region
{
    [self showLoading:NO];
    
    if ([objects count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有匹配的地点." message:@"请尝试其他关键字或移动地图." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else {
        searchArray=[[NSMutableArray alloc] initWithArray:objects];
        tableView.dataSource=self;
        tableView.delegate=self;
        [tableView reloadData];
        //tableView.left = 0;
        [_searcheBar resignFirstResponder];
    }
}


- (void) googleLocalConnection:(GoogleLocalConnection *)conn didFailWithError:(NSError *)error
{
    [self showLoading:NO];
    
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
    
    CLLocationCoordinate2D loc = [obj coordinate];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.1f;
    span.longitudeDelta=0.1f;
    region.span=span;
    region.center=loc;
    [self.mapview setRegion:region animated:YES];
    [self.mapview regionThatFits:region];
    [self showSearchBar];
    
    SnUserAppInfo  *uAppInfo = [UserHelper GetUserAppInfo];
    uAppInfo.LastMapZoomX = span.latitudeDelta;
    uAppInfo.LastMapZoomY = span.longitudeDelta;
    uAppInfo.LastMapRange = 15000;
    uAppInfo.MapCenterLa = obj.coordinate.latitude;
    uAppInfo.MapCenterLo = obj.coordinate.longitude;
    [UserHelper SetUserAppInfo:uAppInfo];
}

#pragma mark UISearchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [googleLocalConnection getGoogleObjectsWithQuery:searchBar.text 
                                        andMapRegion:[self.mapview region] 
                                  andNumberOfResults:8 
                                       addressesOnly:NO 
                                          andReferer:@"http://mysuperiorsitechangethis.com"];
    [self showLoading:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    // tableView.left = self.view.frame.size.width;
    [self showSearchBar];
}


#pragma mark Location
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapView:(MKMapView *)mv annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
//    NSString *url = [NSString stringWithFormat:@"tt://message/?messageid=%@&userid=%@&username=%@&userface=%@"
//                     ,_calloutAnnotation.post.MessageID
//                     ,_calloutAnnotation.post.UserID
//                     ,[_calloutAnnotation.post.UserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
//                     ,_calloutAnnotation.post.UserFace];
//    
//    TTOpenURL(url);
    
   if(_searcheBar.top >= 0)
       [self showSearchBar];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    SnMessage *message = (SnMessage*)_calloutAnnotation.post;
    MessageDetailController *controller = [[MessageDetailController alloc] initWidthMessage:message];
    //TTNavigationController *nav = [[[TTNavigationController alloc] initWithRootViewController:controller]];

    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CalloutMapAnnotationView *calloutMapAnnotationView = [[AccessorizedCalloutMapAnnotationView alloc] initWithAnnotation:annotation    reuseIdentifier:@"CalloutAnnotation"];
        CalloutMapAnnotation *anno=(CalloutMapAnnotation*)annotation;
        calloutMapAnnotationView.post=anno.post;
        calloutMapAnnotationView.contentHeight = 60;
        
        MessageMapAnnotationView *v=[[MessageMapAnnotationView alloc] initWithPost:anno.post];
        v.frame=CGRectMake(5, 2, 150, 60);
        
        [calloutMapAnnotationView.contentView addSubview:v];
        [v release];
		//}
		calloutMapAnnotationView.parentAnnotationView = _selectedAnnotationView;
		calloutMapAnnotationView.mapView = mapview;
        if(anno.post.UserType == 16)
            calloutMapAnnotationView.image=[UIImage imageNamed:@"pin_blue.png"];
		return calloutMapAnnotationView;
	} else 
        if([annotation isKindOfClass:[BasicMapAnnotation class]]){
        BasicMapAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation 
                                                                                     reuseIdentifier:@"CustomAnnotation"];
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorGreen;
        CalloutMapAnnotation *anno=(CalloutMapAnnotation*)annotation;
        annotationView.post=anno.post;
        if(anno.post.UserType == 16)
            annotationView.image=[UIImage imageNamed:@"pin_blue.png"];
        //    annotationView.pinColor = MKPinAnnotationColorRed;
        
		return annotationView;
    }else {
    
        if (annotation!=mapview.userLocation)
        {
            MKPinAnnotationView *annotationView =[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
																			   reuseIdentifier:@"BehindCalloutAnnotation"];
            annotationView.canShowCallout = YES;
            //if(anno.post.UserType == 16)
            //    annotationView.image=[UIImage imageNamed:@"pin_blue.png"];
            //annotationView.pinColor = MKPinAnnotationColorRed;
            return annotationView;
        }
    
	}
	return nil;
}

//
/////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapView:(MKMapView *)mv didSelectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation) {
        [mv removeAnnotation:_calloutAnnotation];
    }
    
    //[self.mapview setSelectedAnnotations:[NSArray arrayWithObject:view.annotation]];
    //return;
    
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
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
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
        SnUserAppInfo  *uAppInfo = [UserHelper GetUserAppInfo];
        uAppInfo.MapCenterLa = anno.coordinate.latitude;
        uAppInfo.MapCenterLo = anno.coordinate.longitude;
        uAppInfo.LastMapZoomX = self.mapview.region.span.latitudeDelta;
        uAppInfo.LastMapZoomY =  self.mapview.region.span.longitudeDelta;
        [UserHelper SetUserAppInfo:uAppInfo];
	}
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    float zoom = mapView.region.span.latitudeDelta;
    
    SnUserAppInfo  *uAppInfo = [UserHelper GetUserAppInfo];
    uAppInfo.LastMapZoomX = mapView.region.span.latitudeDelta;
    uAppInfo.LastMapZoomY = mapView.region.span.longitudeDelta;
    uAppInfo.MapCenterLa = newLocation.coordinate.latitude;
    uAppInfo.MapCenterLo = newLocation.coordinate.longitude;
    float  distance = [_reLocation distanceFromLocation:newLocation];
    float range = mapView.visibleMapRect.size.width/10;
    uAppInfo.LastMapRange = range;
    
    if(zoom  > 0.5f)
    {
         [self.mapview removeAnnotations:self.mapview.annotations];
    }
    else if([self.model isLoading])
    {
        
    }
    else
    {
        bool moveTo = distance  > range;
        bool rangeTo = (range / _reRange) > 2 ;
        [UserHelper DegBugWidthLog:[NSString stringWithFormat:@"distance %f   range:%f  moveTo:%@  rangeTo:%@",distance,range,moveTo?@"YES":@"NO",rangeTo?@"YES":@"NO"] title:@"map event"];

        //NSLog(@"la:%f  lo:%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
        
        uAppInfo.MapCenterChange = YES;
        if(moveTo  ||  rangeTo)
        {
            _reRange = range;
            _reLocation = newLocation;
            
            if(self.model)
            {
                if([self.model isLoading])
                    [self.model cancel];
                
                ShareViewModel *model  = (ShareViewModel*)self.model;
                //[model clearCache:[UserHelper GetUserID] range:_uAppInfo.LastMapRange location:newLocation sendType:128 sendModel:2];
                model.location = newLocation;
                model.sendType = 128;
                model.sendModel = 2;
                model.range = uAppInfo.LastMapRange;
                model.userid = [UserHelper GetUserID];
                [model load:TTURLRequestCachePolicyDefault more:NO];
            }
        }
    }
    [UserHelper SetUserAppInfo:uAppInfo];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)gotoLocation:(CLLocation *)location {
//    
//    CLLocationCoordinate2D loc = [location coordinate];
//    MKCoordinateRegion region;
//    //MKCoordinateSpan span;
//    
//    //self.currentLocation=location;
//    
//    //span.latitudeDelta=0.02f; //zoom level
//    //span.longitudeDelta=0.02f; //zoom level
//    //region.span=span;
//    region.span = self.mapview.region.span;
//    region.center=loc;
//    
//    [self.mapview setRegion:region animated:YES];
//    [self.mapview regionThatFits:region];
//}

-(void)showLoading:(BOOL)show
{
    if(show)
    {
        [self.view addSubview:loading];
        //[self.mapview setZoomEnabled:NO];
        //[self.mapview setScrollEnabled:NO];
    }
    else
    {
        [loading removeFromSuperview];
        //[self.mapview setZoomEnabled:YES];
        //[self.mapview setScrollEnabled:YES];
    }
}


#pragma mark - View DataModel
-(void)setListType
{
    if (!_hasViewAppeared)
         return;
    
    ////////  _nodataView ////
    if(!self.posts || self.posts.count <= 0 )
    {
        if(_nodataView && ![_nodataView superview])
            [self.view addSubview:_nodataView];
    }
    else
    {
        if(_nodataView && [_nodataView superview])
            [_nodataView removeFromSuperview];
        
        //[self gotoLocation:self.currentLocation];
        if(self.mapview && [self.mapview superview])
        {
            [self.mapview removeAnnotations:self.mapview.annotations];
            //[self.mapview addAnnotation:self.mapview.userLocation];
            for (SnMessage* entry in self.posts) {
                    BasicMapAnnotation *customAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:entry.Latitude andLongitude:entry.Longitude post:entry]; 
                    [self.mapview addAnnotation:customAnnotation];
            }
            self.mapview.showsUserLocation = YES;
        }
    }
}



/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)loadMapViewAnnotation:(id<TTModel>)model{
//    [self.mapview removeAnnotations:self.mapview.annotations];
//    [self.mapview addAnnotation:self.mapview.userLocation];
//    ShareViewModel *ds=(ShareViewModel*)model;
//    for (SnMessage* entry in [ds posts]) {
//        BasicMapAnnotation *customAnnotation = [[[BasicMapAnnotation alloc] initWithLatitude:entry.location.latitude andLongitude:entry.location.longitude post:entry] ]; 
//        [self.mapview addAnnotation:customAnnotation];
//    }
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    SnUserAppInfo  *uAppInfo = [UserHelper GetUserAppInfo];
    CLLocation *nowlocation=[[CLLocation alloc] initWithLatitude:uAppInfo.MapCenterLa longitude:uAppInfo.MapCenterLo]; 
    ShareViewModel *m = [[ShareViewModel alloc] initWithSearchQuery:_me range:uAppInfo.LastMapRange location:nowlocation sendType:128 sendModel:1];
    [self setModel:m];
    [m release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) modelDidFinishLoad:(id<TTModel>)model{
    
    ShareViewModel *smodle = (ShareViewModel*)self.model;
    self.posts = [smodle.posts mutableCopy];
    [self setListType];
    
    [super modelDidFinishLoad:model];
}


-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
{
//    NSString *key = [NSString stringWithFormat: @"share_list_%@",_me];
//    NSMutableArray *list = [UserHelper GetMessageList:key];
//     _posts = list;
    
    if(!errorinfoview)
    {
        errorinfoview = [[SnInfoView alloc] initWithFrame:CGRectMake(80, 135, 160,80) msg:@"出错了，请检查您的网络环境！"];
    }
    if(![errorinfoview superview])
        [self.view addSubview:errorinfoview];
    [self performSelector:@selector(removeErrorView) withObject:nil afterDelay:3.0];
    [super model:model didFailLoadWithError:error];
}

-(void)removeErrorView
{
    if(errorinfoview && [errorinfoview superview])
        [errorinfoview removeFromSuperview];
}



-(void)modelDidStartLoad:(id<TTModel>)model
{
    [super modelDidStartLoad:model];
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
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userPublishNewsSucc" object:nil];
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
-(void)dealloc{
//   TT_RELEASE_SAFELY(self.mapview);
    //TT_RELEASE_SAFELY(_reLocation);
//    TT_RELEASE_SAFELY(_calloutAnnotation);
//    TT_RELEASE_SAFELY(_selectedAnnotationView);
    //TT_RELEASE_SAFELY(_posts);
    //TT_RELEASE_SAFELY(_me);
//     TT_RELEASE_SAFELY(loading);
//     TT_RELEASE_SAFELY(_searcheBar);
//     TT_RELEASE_SAFELY(_cancelButton);
//     TT_RELEASE_SAFELY(tableView);
//     TT_RELEASE_SAFELY(searchArray);
//    TT_RELEASE_SAFELY(googleLocalConnection);
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

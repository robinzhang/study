//
//  DetailMapViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DetailMapViewController.h"

@implementation DetailMapViewController
@synthesize location = _location;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"地理位置";
        
       
        _mapview = [[MKMapView alloc] init];
        _mapview=[[MKMapView alloc] init];
        //_mapview.showsUserLocation=YES;
        _mapview.delegate=self;
        _mapview.mapType = MKMapTypeStandard;
        
        [self.view addSubview:_mapview];
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //blueColorBackButton
    
    TTButton *btn = [TTButton buttonWithStyle:@"blueColorBackButton:" title:NSLocalizedString(@"Back",@"Back")];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    //UIBarButtonItem *leftBarButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back",@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
     CGRect frame = self.view.bounds;
    [_mapview setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    // CLLocation *location=[[CLLocation alloc] initWithLatitude:39.916250 longitude:116.525130];
    
    CLLocationCoordinate2D loc = _location.coordinate;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta=0.01f; //zoom level
    span.longitudeDelta=0.01f; //zoom level
    
    region.span=span;
    region.center=loc;

    BasicMapAnnotation *anno = [[BasicMapAnnotation alloc] initWithLatitude:loc.latitude andLongitude:loc.longitude post:nil];
    [_mapview addAnnotation:anno];
    [anno release];
    
    [_mapview setRegion:region animated:YES];
    [_mapview regionThatFits:region];
    
    [_mapview setFrame:CGRectMake(0, KPageTitleHeight, frame.size.width, frame.size.height - KPageTitleHeight)];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)goBack
{
    [self dismissModalViewControllerAnimated:YES];
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
-(void)dealloc
{
    //[_location release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

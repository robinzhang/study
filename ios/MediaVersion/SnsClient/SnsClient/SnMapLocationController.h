//
//  UIMapLocationController.h
//  SnsClient
//
//  Created by  on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol SnMapLocationDelegate
- (void)didSelectLocation:(CLLocation*)location  adress:(NSString*)adress;
@end


#import <UIKit/UIKit.h>
#import "BasicMapAnnotation.h"
#import "GoogleLocalConnection.h"
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotationView.h"

@interface SnMapLocationController : TTViewController<MKMapViewDelegate,GoogleLocalConnectionDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,MKReverseGeocoderDelegate,UISearchBarDelegate,MKReverseGeocoderDelegate>
{
    id<SnMapLocationDelegate> _delegate;
    MKMapView *_mapview;
    //UITextField *_searchKey;
    //UIButton *_btnSearch;
    
    UISearchBar *_searchBar;
    NSString *_maddress;
    
    TTActivityLabel *loadingView;
    GoogleLocalConnection *googleLocalConnection;
    
    CLLocationCoordinate2D coordinate;
    //NSString *geoAddress;
    BasicMapAnnotation *centerpoint;
    
    MKReverseGeocoder *geoCoder;
    //CLLocationManager* locManager;
    
    UITableView *tableView;
    NSMutableArray *searchArray;
    
    bool _stopCallAdress;
}
@property (nonatomic, copy) NSString* maddress;
@property (nonatomic, assign) id<SnMapLocationDelegate> delegate;
-(void)reset;
//- (void)gotoLocation:(CLLocation *)location;
@end

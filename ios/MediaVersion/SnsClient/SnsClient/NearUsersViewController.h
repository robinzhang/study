//
//  HomeViewController.h
//  SnsClient
//
//  Created by  on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotation.h"

@interface NearUsersViewController : SnTableViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    int _messageType;
    
    int listType;
    MKMapView *_mapview;
    CLLocationManager* locManager;
    CLLocation *currentLocation;
    
    CalloutMapAnnotation *_calloutAnnotation;
    MKAnnotationView *_selectedAnnotationView;
    int magicNumber;
    
    NSMutableArray*  _posts;
}
-(void)swithListType;
-(void)setListType;
//-(void)initTitleView;
//- (void)loadMapViewAnnotation:(id<TTModel>)model;
- (void)gotoLocation:(CLLocation *)location;
@end

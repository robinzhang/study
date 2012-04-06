//
//  DetailMapViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BasicMapAnnotation.h"

@interface DetailMapViewController : SnViewController<MKMapViewDelegate>
{
    MKMapView *_mapview;
    CLLocation *_location;
}
@property (nonatomic, retain) CLLocation* location;
@end

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SnMessage.h"

@interface BasicMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
	NSString *_title;
    SnMessage *_post;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic,retain) SnMessage *post;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
                  post:(SnMessage*)post;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end

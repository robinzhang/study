#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SnMessage.h"

@interface CalloutMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    SnMessage *_post;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic,retain) SnMessage *post;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
                  post:(SnMessage*)post;

@end

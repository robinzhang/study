#import "CalloutMapAnnotation.h"

@interface CalloutMapAnnotation()


@end

@implementation CalloutMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize post=_post;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
                  post:(SnMessage*)post{
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.post=post;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

@end

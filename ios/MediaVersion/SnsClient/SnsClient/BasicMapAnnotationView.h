#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SnMessage.h"

@interface BasicMapAnnotationView : MKPinAnnotationView {
	BOOL _preventSelectionChange;
    SnMessage *_post;
}

@property (nonatomic) BOOL preventSelectionChange;
@property (nonatomic, retain) SnMessage *post;

@end

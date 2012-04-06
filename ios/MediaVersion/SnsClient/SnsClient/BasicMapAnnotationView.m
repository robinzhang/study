#import "BasicMapAnnotationView.h"


@implementation BasicMapAnnotationView

@synthesize preventSelectionChange = _preventSelectionChange;
@synthesize post= _post;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (!self.preventSelectionChange) {
		[super setSelected:selected animated: animated];
	}
}

- (SnMessage *)post{
    return _post;
}

@end

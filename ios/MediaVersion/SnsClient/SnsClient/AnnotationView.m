//
//  AnnotationView.m
//  SnsClient
//
//  Created by  on 11-10-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AnnotationView.h"

@implementation AnnotationView
@synthesize userAvator=userAvator;

- (void)layoutSubviews{
    [super layoutSubviews];
    
    userAvator=[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://fakeicon.png")];
    userAvator.frame=CGRectMake(0, 0, 40, 40);
    [self addSubview:userAvator];
}

- (BOOL)canShowCallout{
	return YES;
}

- (CGPoint)centerOffset{
	return CGPointMake(4, -10);
}

-(CGPoint)calloutOffset{
	return CGPointMake(-4, -1);
}

@end
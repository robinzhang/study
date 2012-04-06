//
//  AnnotationView.h
//  SnsClient
//
//  Created by  on 11-10-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>


@interface AnnotationView : MKAnnotationView {
    UIImageView* userAvator;
    
}

@property (nonatomic,retain) UIImageView* userAvator;
@end

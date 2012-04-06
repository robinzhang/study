//
//  Annotation.m
//  SnsClient
//
//  Created by  on 11-10-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize coordinate,title,subtitle;
-(void)dealloc{
    [title release];
    [subtitle release];
    [super dealloc];
}


@end
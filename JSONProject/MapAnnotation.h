//
//  MapAnnotation.h
//  MapTest
//
//  Created by Dmitriy Demchenko on 12/13/14.
//  Copyright (c) 2014 Organization98. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

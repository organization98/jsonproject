//
//  LocationManager.h
//  MapTest
//
//  Created by Dmitriy Demchenko on 12/15/14.
//  Copyright (c) 2014 Organization98. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

- (void)startTrackLocation;
- (void)stopTrackLocation;
- (CLLocation *)currentLocation;
+ (LocationManager *)sharedManager;

@end

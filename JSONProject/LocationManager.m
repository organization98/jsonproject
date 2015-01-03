//
//  LocationManager.m
//  MapTest
//
//  Created by Dmitriy Demchenko on 12/15/14.
//  Copyright (c) 2014 Organization98. All rights reserved.
//

#import "LocationManager.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation LocationManager

+ (LocationManager *)sharedManager {
    static LocationManager* sharedManager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^{
        sharedManager = [LocationManager new];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (void)startTrackLocation {
    
    self.locationManager.delegate = self;
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // с каким шагом проверять локацию
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // качество локации
    
    // проверка доступен ли метод в данный момент
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        //[self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
}

- (void)stopTrackLocation {
    [self.locationManager stopUpdatingLocation];
}

- (CLLocation *)currentLocation {
    return self.locationManager.location;
}

@end
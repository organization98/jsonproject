//
//  Geo.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Geo.h"
#import "Address.h"


@implementation Geo

@dynamic lat;
@dynamic lng;
@dynamic address;

- (NSDictionary *)dictionaryFromGeo {
    
    NSDictionary *geo =  @{
                           @"lat" : self.lat,
                           @"lat" : self.lng
                           };
    return geo;
}

@end

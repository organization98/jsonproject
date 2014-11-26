//
//  Address.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Address.h"
#import "Geo.h"
#import "User.h"


@implementation Address

@dynamic city;
@dynamic street;
@dynamic suite;
@dynamic zipcode;
@dynamic geo;
@dynamic user;

- (NSDictionary *)dictionaryFromAddress {
    
    NSDictionary *address =  @{
                               @"city" : self.city,
                               @"street" : self.street,
                               @"suite": self.suite,
                               @"geo" : [self.geo dictionaryFromGeo]
                               };
    return address;
}

- (void)addUserObject:(User *)value {
    NSLog(@"addUserObject CALLeD");
}

@end

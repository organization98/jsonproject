//
//  Geo.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address;

@interface Geo : NSManagedObject

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) Address *address;

+ (Geo *)geoFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromGeo;

@end

//
//  Geo.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Geo.h"
#import "Address.h"
#import "User.h"
#import "CoreDataManager.h"


@implementation Geo

@dynamic lat;
@dynamic lng;
@dynamic address;

+ (Geo *)geoFromDictionary:(NSDictionary *)dictionary {
    NSNumber *lat = [dictionary objectForKey:@"lat"];
    NSNumber *lng = [dictionary objectForKey:@"lng"];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lat == %@ OR lng == %@", lat, lng];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Geo"
                                              inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *result = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    Geo *geo = nil;
    if ([result count]) {
        geo = [result firstObject];
    } else {
        geo = [NSEntityDescription insertNewObjectForEntityForName:@"Geo"
                                            inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    }
    
    geo.lat = [NSNumber numberWithFloat:[lat floatValue]];
    geo.lng = [NSNumber numberWithFloat:[lng floatValue]];
    
    [[[CoreDataManager sharedManager] managedObjectContext] save:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    return geo;
}

- (NSDictionary *)dictionaryFromGeo {
    
    NSDictionary *geo =  @{
                           @"lat" : self.lat,
                           @"lat" : self.lng
                           };
    return geo;
}

@end

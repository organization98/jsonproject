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
#import "CoreDataManager.h"


@implementation Address

@dynamic city;
@dynamic street;
@dynamic suite;
@dynamic zipcode;
@dynamic geo;
@dynamic user;

+ (Address *)addressFromDictionary:(NSDictionary *)dictionary {
    
    // проверка : существует ли такой Address
    NSString *streetId = [dictionary objectForKey:@"street"];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"street == %@", streetId];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Address"
                                              inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSArray *array = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
    Address *address = [array firstObject];
    if (!address) {
        address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
        address.street = [dictionary objectForKey:@"street"];
        address.suite = [dictionary objectForKey:@"suite"];
        address.city = [dictionary objectForKey:@"city"];
        address.zipcode = [dictionary objectForKey:@"zipcode"];
    }
    return address;
}

- (NSDictionary *)dictionaryFromAddress {
    
    NSDictionary *address =  @{
                               @"suite"     : self.suite,
                               @"street"    : self.street,
                               @"city"      : self.city,
                               @"zipcode"   : self.zipcode,
                               @"geo"       : [NSString stringWithFormat:@"%@ : %@", self.geo.lat, self.geo.lng]
                               };
    return address;
}

@end

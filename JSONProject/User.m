//
//  User.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "User.h"
#import "Address.h"
#import "Albums.h"
#import "Company.h"
#import "CoreDataManager.h"
#import "Geo.h"


@implementation User

@dynamic email;
@dynamic idUser;
@dynamic name;
@dynamic phone;
@dynamic username;
@dynamic website;
@dynamic address;
@dynamic albums;
@dynamic company;

+ (User *)userFromDictionary:(NSDictionary *)dictionary {
    
    // проверка : существует ли такой пользователь
    NSNumber *userId = [dictionary objectForKey:@"id"];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idUser == %@", userId];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    
    // проверку вынести CDManage, реализовать проверку в каждом из классов User, Company, Address, Geo
    
    NSArray *array = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
    
    /*
     // так нужно сделать для: User, Company, Address, Geo
    User *user = [array firstObject];
    
    if (!user) {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
        user.idUser = [dictionary objectForKey:@"id"];
        user.name = [dictionary objectForKey:@"name"];
        user.username = [dictionary objectForKey:@"username"];
        user.email = [dictionary objectForKey:@"email"];
        user.phone = [dictionary objectForKey:@"phone"];
        user.website = [dictionary objectForKey:@"website"];
    }
    */
    
    if (array.count) {
        return [array firstObject];
    }
    // при расхождении данные нужно обновить
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    user.idUser = [dictionary objectForKey:@"id"];
    user.name = [dictionary objectForKey:@"name"];
    user.username = [dictionary objectForKey:@"username"];
    user.email = [dictionary objectForKey:@"email"];
    user.phone = [dictionary objectForKey:@"phone"];
    user.website = [dictionary objectForKey:@"website"];
    
    
    Company *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    NSDictionary *dictionaryCompany = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"company"]];
    company.name = [dictionaryCompany objectForKey:@"name"];
    company.bs = [dictionaryCompany objectForKey:@"bs"];
    company.catchPhrase = [dictionaryCompany objectForKey:@"catchPhrase"];
    
    Address *address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    NSDictionary *dictionaryAddress = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"address"]];
    address.street = [dictionaryAddress objectForKey:@"street"];
    address.suite = [dictionaryAddress objectForKey:@"suite"];
    address.city = [dictionaryAddress objectForKey:@"city"];
    address.zipcode = [dictionaryAddress objectForKey:@"zipcode"];
    
    Geo *geo = [NSEntityDescription insertNewObjectForEntityForName:@"Geo" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    NSDictionary *dictionaryGeo = [NSDictionary dictionaryWithDictionary:[dictionaryAddress objectForKey:@"geo"]];
    geo.lat = [NSNumber numberWithInt:[[dictionaryGeo objectForKey:@"lat"] intValue]];
    geo.lng = [NSNumber numberWithInt:[[dictionaryGeo objectForKey:@"lng"] intValue]];
    
    address.geo = geo;
    user.company = company;
    user.address = address;
    
    NSLog(@"%@", geo);
    
    return user;
}

- (NSDictionary *)dictionaryFromFullUser {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"general":self.dictionaryFromUser}];
    [dict setObject:[self.address dictionaryFromAddress] forKey:@"address"];
    [dict setObject:[self.company dictionaryFromCompany] forKey:@"company"];
    return dict;
}

- (NSDictionary *)dictionaryFromUser {
    
    NSDictionary *dict =  @{
                            @"name" : self.name,
                            @"username" : self.username,
                            @"email": self.email,
                            @"phone" : self.phone,
                            @"website":self.website
                            };
    return dict;
}

@end

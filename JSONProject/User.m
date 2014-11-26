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
    
    NSArray *array = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
    
    if (array.count) {
        return [array firstObject];
    }
    
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    
    NSLog(@"insertNewObjectForEntityForName CALLED");
    
    user.idUser = [dictionary objectForKey:@"id"];
    user.name = [dictionary objectForKey:@"name"];
    user.username = [dictionary objectForKey:@"username"];
    user.email = [dictionary objectForKey:@"email"];
    user.phone = [dictionary objectForKey:@"phone"];
    user.website = [dictionary objectForKey:@"website"];
    
    /*
     NSDictionary *company = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"company"]];
     user.company.name = [company objectForKey:@"name"];
     user.company.bs = [company objectForKey:@"bs"];
     user.company.catchPhrase = [company objectForKey:@"catchPhrase"];
     */
    
    Company *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    
    company.name = [dictionary objectForKey:@"name"];
    company.bs = [dictionary objectForKey:@"bs"];
    company.catchPhrase = [dictionary objectForKey:@"catchPhrase"];
    
    //    NSLog(@"%@", company);
    
    /*
     NSDictionary *address = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"address"]];
     user.address.street = [address objectForKey:@"street"];
     user.address.suite = [address objectForKey:@"suite"];
     user.address.city = [address objectForKey:@"city"];
     user.address.zipcode = [address objectForKey:@"zipcode"];// id - уточнить
     */
    
    Address *address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    
    address.street = [dictionary objectForKey:@"street"];
    address.suite = [dictionary objectForKey:@"suite"];
    address.city = [dictionary objectForKey:@"city"];
    address.zipcode = [dictionary objectForKey:@"zipcode"];
    
    /*
     NSDictionary *geo = [NSDictionary dictionaryWithDictionary:[address objectForKey:@"geo"]];
     user.address.geo.lat = [geo objectForKey:@"lat"];
     user.address.geo.lng = [geo objectForKey:@"lng"];
     */
    
    Geo *geo = [NSEntityDescription insertNewObjectForEntityForName:@"Geo" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    
    geo.lat = [dictionary objectForKey:@"lat"];
    geo.lat = [dictionary objectForKey:@"lng"];
    
    return user;
}


- (NSDictionary *)dictionaryFromFullUser {
    NSLog(@"%@", [self.address class]);
    NSLog(@"%@", [self.address dictionaryFromAddress]);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"general":self.dictionaryFromUser}];
    [dict setObject:[self.address dictionaryFromAddress] forKey:@"address"];
    [dict setObject:[self.company dictionaryFromCompany] forKey:@"company"];
    return dict;
    NSDictionary *dic = [[NSDictionary alloc] init];
    return dic;
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

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
    NSNumber *userId = [dictionary objectForKey:@"id"];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idUser == %@", userId];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSArray *array = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
    User *user = [array firstObject];
    if (!user) {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
        user.idUser = [dictionary objectForKey:@"id"];
        user.name = [dictionary objectForKey:@"name"];
        user.username = [dictionary objectForKey:@"username"];
        user.email = [dictionary objectForKey:@"email"];
        user.phone = [dictionary objectForKey:@"phone"];
        user.website = [dictionary objectForKey:@"website"];
    }
    
    user.company = [Company companyFromDictionary:[dictionary objectForKey:@"company"]];
    user.address = [Address addressFromDictionary:[dictionary objectForKey:@"address"]];
    user.address.geo = [Geo geoFromDictionary:[dictionary objectForKey:@"geo"]];

    [[CoreDataManager sharedManager] saveContext];
    
    return user;
}

- (NSDictionary *)dictionaryFromFullUser {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"general":self.dictionaryFromUser}];
    [dict setObject:[self.address dictionaryFromAddress] forKey:@"address"];
//    [dict setObject:[self.address.geo dictionaryFromGeo] forKey:@"geo"];
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

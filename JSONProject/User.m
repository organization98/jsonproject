//
//  User.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "User.h"
#import "Address.h"
#import "Geo.h"
#import "Company.h"
#import "Albums.h"
#import "Photos.h"
#import "CoreDataManager.h"
#import "NetworkManager.h"

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
    NSError *error;
    NSArray *result = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    User *user = nil;
    if ([result count]) {
        user = [result objectAtIndex:0];
    } else {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    }
    user.idUser = [dictionary objectForKey:@"id"];
    user.name = [dictionary objectForKey:@"name"];
    user.username = [dictionary objectForKey:@"username"];
    user.email = [dictionary objectForKey:@"email"];
    user.phone = [dictionary objectForKey:@"phone"];
    user.website = [dictionary objectForKey:@"website"];
//    NSLog(@"%@", dictionary);
    [[[CoreDataManager sharedManager] managedObjectContext] save:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    user.company = [Company companyFromDictionary:[dictionary objectForKey:@"company"]];
    user.address = [Address addressFromDictionary:[dictionary objectForKey:@"address"]];
    user.address.geo = [Geo geoFromDictionary:[[dictionary objectForKey:@"address"] objectForKey:@"geo"]];
    
    user.albums = [Albums albumFromDictionary:[dictionary objectForKey:@"albums"]];
    user.albums.photos = [Photos photosFromDictionary:[[dictionary objectForKey:@"albums"] objectForKey:@"photos"]];
    
    user.albums.userId = user.idUser;
    user.albums.photos.albumId = user.albums.userId;
    
    NSLog(@"%@", user.albums.photos);
    
    return user;
}

- (NSDictionary *)dictionaryFromUser {
    
    NSDictionary *dict =  @{
                            @"id"       : [NSString stringWithFormat:@"%@", self.idUser],
                            @"name"     : self.name,
                            @"username" : self.username,
                            @"phone"    : self.phone,
                            @"email"    : self.email,
                            @"website"  : self.website
                            };
    return dict;
}

- (NSDictionary *)dictionaryFromFullUser {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:self.dictionaryFromUser forKey:@"general"];
    [dict setObject:[self.address dictionaryFromAddress] forKey:@"address"];
    [dict setObject:[self.company dictionaryFromCompany] forKey:@"company"];
    
    return dict;
}

@end
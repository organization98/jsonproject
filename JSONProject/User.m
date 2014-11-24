//
//  User.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/24/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "User.h"
#import "Address.h"
#import "Albums.h"
#import "Company.h"

#import "CoreDataManager.h"


@implementation User

@dynamic idUser;
@dynamic name;
@dynamic username;
@dynamic email;
@dynamic phone;
@dynamic website;
@dynamic address;
@dynamic company;
@dynamic albums;

// old methods
+ (User *)userFromDictionary:(NSDictionary *)dictionary {
    
    // проверка : существует ли такой пользователь
    NSNumber *userId = [dictionary objectForKey:@"id"];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSPredicate predicateWithFormat:@"idUser == %@", userId];
// закончить запрос и сделать проверку    
// ДЗ -- выполнить проверку, если пользователя с таким ИД нет -- создается новый, есль есть перезаписывается
    
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    
    
    NSLog(@"%@", user);
    
    user.idUser = [dictionary objectForKey:@"id"];
    user.name = [dictionary objectForKey:@"name"];
    user.username = [dictionary objectForKey:@"username"];
    user.email = [dictionary objectForKey:@"email"];
    user.phone = [dictionary objectForKey:@"phone"];
    user.website = [dictionary objectForKey:@"website"];
//    user.company = [dictionary objectForKey:@"company"];
    
//    NSMutableDictionary *address = [[NSMutableDictionary alloc] initWithDictionary:[dictionary objectForKey:@"address"]];
//    [address removeObjectForKey:@"geo"];
//    user.address = address;
    
    return user;
}


//- (NSDictionary *)dictionaryFromFullUser {
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"general":self.dictionaryFromUser}];
//    [dict setObject:self.address forKey:@"address"];
//    [dict setObject:self.company forKey:@"company"];
//    
//    return dict;
//}


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

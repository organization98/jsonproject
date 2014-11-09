//
//  LMLUser.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "LMLUser.h"


@implementation LMLUser


+ (LMLUser *)userFromDictionary:(NSDictionary *)dictionary {
    
    LMLUser *user = [[LMLUser alloc] init];
    
    user.name = [dictionary objectForKey:@"name"];
    user.username = [dictionary objectForKey:@"username"];
    user.email = [dictionary objectForKey:@"email"];
    user.phone = [dictionary objectForKey:@"phone"];
    user.website = [dictionary objectForKey:@"website"];
    user.company = [dictionary objectForKey:@"company"];
    
    NSMutableDictionary *address = [[NSMutableDictionary alloc] initWithDictionary:[dictionary objectForKey:@"address"]];
    [address removeObjectForKey:@"geo"];
    user.address = address;
    
    return user;
}


- (NSDictionary *)dictionaryFromFullUser {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"general":self.dictionaryFromUser}];
    [dict setObject:self.address forKey:@"address"];
    [dict setObject:self.company forKey:@"company"];
    
    return dict;
}


- (NSDictionary*) dictionaryFromUser {
    
    NSDictionary* dict =  @{
                            @"name" : self.name,
                            @"username" : self.username,
                            @"email": self.email,
                            @"phone" : self.phone,
                            @"website":self.website
                            };
    return dict;
}

@end
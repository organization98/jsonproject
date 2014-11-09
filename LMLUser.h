//
//  LMLUser.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMLUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSDictionary *address;
@property (strong, nonatomic) NSDictionary *company;

+ (LMLUser *)userFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromUser;
- (NSDictionary *)dictionaryFromFullUser;

@end
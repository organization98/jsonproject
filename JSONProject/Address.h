//
//  Address.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class Geo, User;

@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * suite;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) Geo *geo;
@property (nonatomic, retain) NSSet *user;
@end

@interface Address (CoreDataGeneratedAccessors)

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

+ (Address *)addressFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromAddress;

@end

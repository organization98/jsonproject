//
//  Company.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class User;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * bs;
@property (nonatomic, retain) NSString * catchPhrase;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *user;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

- (NSDictionary *)dictionaryFromCompany;

@end

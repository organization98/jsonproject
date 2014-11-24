//
//  Company.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/24/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * catchPhrase;
@property (nonatomic, retain) NSString * bs;
@property (nonatomic, retain) NSSet *company;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addCompanyObject:(User *)value;
- (void)removeCompanyObject:(User *)value;
- (void)addCompany:(NSSet *)values;
- (void)removeCompany:(NSSet *)values;

@end

//
//  User.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Albums, Company;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * idUser;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) Address *address;
@property (nonatomic, retain) Albums *albums;
@property (nonatomic, retain) Company *company;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAlbumsObject:(Albums *)value;
- (void)removeAlbumsObject:(Albums *)value;
- (void)addAlbums:(NSSet *)values;
- (void)removeAlbums:(NSSet *)values;

+ (User *)userFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromUser;
- (NSDictionary *)dictionaryFromFullUser;

@end
//
//  Albums.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photos, User;

@interface Albums : NSManagedObject

@property (nonatomic, retain) NSNumber * idAlbums;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) Photos *photos;
@property (nonatomic, retain) NSSet *user;

@end

@interface Albums (CoreDataGeneratedAccessors)

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

+ (Albums *)albumFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromAlbums;

@end

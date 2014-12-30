//
//  Photos.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Albums;

@interface Photos : NSManagedObject

@property (nonatomic, retain) NSNumber * albumId;
@property (nonatomic, retain) NSNumber * idPhotos;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Albums *albums;

@end

@interface Photos (CoreDataGeneratedAccessors)

- (void)addUserObject:(Albums *)value;
- (void)removeUserObject:(Albums *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

+ (Photos *)photosFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromPhotos;

@end

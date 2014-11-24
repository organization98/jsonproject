//
//  Albums.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/24/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photos, User;

@interface Albums : NSManagedObject

@property (nonatomic, retain) NSNumber * idAlbums;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Albums (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photos *)value;
- (void)removePhotosObject:(Photos *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end

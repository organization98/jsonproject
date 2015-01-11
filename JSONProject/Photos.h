//
//  Photos.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 1/11/15.
//  Copyright (c) 2015 Home. All rights reserved.
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

+ (Photos *)photosFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromPhotos;

@end

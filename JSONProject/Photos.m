//
//  Photos.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "CoreDataManager.h"
#import "User.h"
#import "Albums.h"
#import "Photos.h"


@implementation Photos

@dynamic albumId;
@dynamic idPhotos;
@dynamic thumbnailUrl;
@dynamic title;
@dynamic url;
@dynamic albums;


+ (Photos *)photosFromDictionary:(NSDictionary *)dictionary {
    NSString *url = [dictionary objectForKey:@"url"];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", url];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photos"
                                              inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *result = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    Photos *photos = nil;
    if ([result count]) {
        photos = [result objectAtIndex:0];
    } else {
        photos = [NSEntityDescription insertNewObjectForEntityForName:@"Photos"
                                                inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    }
    photos.albumId = [dictionary objectForKey:@"albumId"];
    photos.idPhotos = [dictionary objectForKey:@"id"];
    photos.title = [dictionary objectForKey:@"title"];
    photos.url = [dictionary objectForKey:@"url"];
    photos.thumbnailUrl = [dictionary objectForKey:@"thumbnailUrl"];
    
    [[[CoreDataManager sharedManager] managedObjectContext] save:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    return photos;
}

- (NSDictionary *)dictionaryFromPhotos {
    NSDictionary *photos = @{
                             @"albumId"         : self.albumId,
                             @"id"              : self.idPhotos,
                             @"title"           : self.title,
                             @"url"             : self.url,
                             @"thumbnailUrl"    : self.thumbnailUrl
                             };
    return photos;
}

@end

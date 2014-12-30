//
//  Albums.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "CoreDataManager.h"
#import "Albums.h"
#import "Photos.h"
#import "User.h"


@implementation Albums

@dynamic idAlbums;
@dynamic title;
@dynamic userId;
@dynamic photos;
@dynamic user;


+ (Albums *)albumFromDictionary:(NSDictionary *)dictionary {
    NSString *title = [dictionary objectForKey:@"title"];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Albums"
                                              inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *result = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    Albums *album = nil;
    if ([result count]) {
        album = [result objectAtIndex:0];
    } else {
        album = [NSEntityDescription insertNewObjectForEntityForName:@"Albums"
                                              inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    }
    album.userId = [dictionary objectForKey:@"userId"];
    album.idAlbums = [dictionary objectForKey:@"id"];
    album.title = [dictionary objectForKey:@"title"];
    
    [[[CoreDataManager sharedManager] managedObjectContext] save:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    return album;
}


- (NSDictionary *)dictionaryFromAlbums {
    NSDictionary *albums = @{
                             @"userId"  : self.userId,
                             @"id"      : self.idAlbums,
                             @"title"   : self.title
                             };
    return albums;
}

@end

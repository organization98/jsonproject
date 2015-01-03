//
//  AlbumManager.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Albums.h"

typedef  void (^NetworkBlock)(BOOL succes, id data, NSError* error);

@interface AlbumManager : NSObject

+ (AlbumManager *)sharedManager;
- (void)loadDataFromURL:(NSURL *)url completion:(NetworkBlock)block;
- (void)saveAlbum:(Albums *)album completion:(NetworkBlock)block;

@end

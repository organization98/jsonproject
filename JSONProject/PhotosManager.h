//
//  PhotosManager.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photos.h"

typedef  void (^NetworkBlock)(BOOL succes, id data, NSError* error);

@interface PhotosManager : NSObject

+ (PhotosManager *)sharedManager;
- (void)loadDataFromURL:(NSURL *)url completion:(NetworkBlock) block;
- (void)savePhoto:(Photos *)photo completion:(NetworkBlock)block;

@end

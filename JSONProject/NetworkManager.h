//
//  NetworkManager.h
//  BlockProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef  void (^NetworkBlock)(BOOL succes, id data, NSError* error);

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedManager;
- (void)loadDataFromURL:(NSURL *)url completion:(NetworkBlock) block;
- (void)saveUser:(User *)user completion:(NetworkBlock) block;

@end
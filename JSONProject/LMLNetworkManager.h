//
//  LMLNetworkManager.h
//  BlockProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMLUser.h"

typedef  void (^NetworkBlock)(BOOL succes, id data, NSError* error);

@interface LMLNetworkManager : NSObject

+ (LMLNetworkManager *)sharedManager;
- (void)loadDataFromURL:(NSURL *)url completion:(NetworkBlock) block;
- (void)saveUser:(LMLUser *)user completion:(NetworkBlock) block;

@end
//
//  LMLNetworkManager.m
//  BlockProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "LMLNetworkManager.h"
#import "AFNetworking.h"


@implementation LMLNetworkManager

+ (LMLNetworkManager*) sharedManager {
    static LMLNetworkManager* manager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^{
        manager = [LMLNetworkManager new];
    });
    return manager;
}

//Получение списка пользователей
- (void)loadDataFromURL:(NSURL *)url completion:(NetworkBlock)block {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url.absoluteString parameters:nil success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray* users = [self usersFromData:responseObject];
         block (YES, users, nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //Обработка ошибки
     }];
}

//Сохранение пользователя
- (void)saveUser:(LMLUser *)user completion:(NetworkBlock)block {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary* param = [user dictionaryFromUser];
    [manager POST:@"http://jsonplaceholder.typicode.com/users" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"USER SAVED\n%@", responseObject); //Обработка сохранения пользователя
        LMLUser *user = [LMLUser userFromDictionary:responseObject];
        block(YES, user, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Обработка ошибки
    }];
}

//Возвращает массив пользователей
- (NSArray*) usersFromData: (id) data {
    NSMutableArray* users = [NSMutableArray array];
    for (NSDictionary* dict in data){
        LMLUser* user = [LMLUser userFromDictionary:dict];
        [users addObject:user];
    }
    return users;
}

@end
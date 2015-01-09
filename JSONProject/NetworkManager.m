//
//  NetworkManager.m
//  BlockProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"


@implementation NetworkManager

+ (NetworkManager *)sharedManager {
    static NetworkManager *manager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^{
        manager = [NetworkManager new];
    });
    return manager;
}

//Получение списка пользователей NEW
- (void)loadDataForType:(int)type fromURL:(NSURL *)url completion:(NetworkBlock)block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url.absoluteString parameters:nil success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray *users = [self usersFromData:responseObject and:type];
         block (YES, users, nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //Обработка ошибки
     }];
}

//Получение списка пользователей
- (void)loadDataFromURL:(NSURL *)url completion:(NetworkBlock)block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url.absoluteString parameters:nil success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray *users = [self usersFromData:responseObject];
         block (YES, users, nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //Обработка ошибки
     }];
}

//Сохранение пользователя
- (void)saveUser:(User *)user completion:(NetworkBlock)block {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary* param = [user dictionaryFromUser];
    [manager POST:@"http://jsonplaceholder.typicode.com/users" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"USER SAVED\n%@", responseObject); //Обработка сохранения пользователя
        User *user = [User userFromDictionary:responseObject];
        block(YES, user, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Обработка ошибки
    }];
}

//Возвращает массив пользователей
- (NSArray *)usersFromData:(id)data {
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *dict in data){
        User *user = [User userFromDictionary:dict];
        [users addObject:user];
    }
    return users;
}


//Возвращает массив пользователей NEW
- (NSArray *)usersFromData:(id)data and:(int)type {
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *dict in data){
        if (type == 1) {
            User *user = [User userFromDictionary:dict];
            [users addObject:user];
        } else if (type == 2) {
            Albums *album = [Albums albumFromDictionary:dict];
            [users addObject:album];
        } else {
            Photos *photo = [Photos photosFromDictionary:dict];
            [users addObject:photo];
        }
    }
    return users;
}

@end
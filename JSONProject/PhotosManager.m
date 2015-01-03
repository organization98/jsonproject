//
//  PhotosManager.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "PhotosManager.h"
#import "AFNetworking.h"
#import "Photos.h"

@implementation PhotosManager

+ (PhotosManager *)sharedManager {
    static PhotosManager *manager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^{
        manager = [PhotosManager new];
    });
    return manager;
}

//Получение списка пользователей
- (void)loadDataFromURL:(NSURL *)url completion:(NetworkBlock)block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url.absoluteString parameters:nil success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray *users = [self photosFromData:responseObject];
         block (YES, users, nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //Обработка ошибки
     }];
}

//Сохранение пользователя
- (void)savePhoto:(Photos *)photo completion:(NetworkBlock)block {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary* param = [photo dictionaryFromPhotos];
    [manager POST:@"http://jsonplaceholder.typicode.com/photos" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"USER SAVED\n%@", responseObject); //Обработка сохранения пользователя
        Photos *photo = [Photos photosFromDictionary:responseObject];
        block(YES, photo, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Обработка ошибки
    }];
}

//Возвращает массив пользователей
- (NSArray *)photosFromData:(id)data {
    NSMutableArray *photos = [NSMutableArray array];
    for (NSDictionary *dict in data){
        Photos *photo = [Photos photosFromDictionary:dict];
        [photos addObject:photo];
    }
    return photos;
}

@end

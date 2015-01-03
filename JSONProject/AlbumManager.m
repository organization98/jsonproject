//
//  AlbumManager.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "AlbumManager.h"
#import "AFNetworking.h"


@implementation AlbumManager

+ (AlbumManager *)sharedManager {
    static AlbumManager *manager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once (& onceTaken, ^{
        manager = [AlbumManager new];
    });
    return manager;
}

//Получение списка альбомов
- (void)loadDataFromURL:(NSURL *)url completion:(NetworkBlock)block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url.absoluteString parameters:nil success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray *albums = [self albumsFromData:responseObject];
         block (YES, albums, nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //Обработка ошибки
     }];
}

//Сохранение альбома
- (void)saveAlbum:(Albums *)album completion:(NetworkBlock)block {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary* param = [album dictionaryFromAlbums];
    [manager POST:@"http://jsonplaceholder.typicode.com/albums" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"USER SAVED\n%@", responseObject); //Обработка сохранения пользователя
        Albums *album = [Albums albumFromDictionary:responseObject];
        block(YES, album, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Обработка ошибки
    }];
}

//Возвращает массив пользователей
- (NSArray *)albumsFromData:(id)data {
    NSMutableArray *albums = [NSMutableArray array];
    for (NSDictionary *dict in data){
        Albums *album = [Albums albumFromDictionary:dict];
        [albums addObject:album];
    }
    return albums;
}

@end

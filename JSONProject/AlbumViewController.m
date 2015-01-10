//
//  AlbumViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "AlbumViewController.h"
#import "ThumbnailCustomCell.h"
#import "CoreDataManager.h"
#import "UIImageView+AFNetworking.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.collectionView.directionalLockEnabled = YES;
    
    // добавляет массив dictionary из image и title
    self.arrayImages = @[
                         @{@"name" : @"Image 1",
                           @"imageURL" : [NSURL URLWithString:@"http://snowbrains.com/wp-content/uploads/2014/01/url-2.jpeg"]},
                         
                         @{@"name" : @"Image 2",
                           @"imageURL" : [NSURL URLWithString:@"http://www.qparks.com/files/images/6795/315489__web_Serfaus_Fiss_Ladis_Freeride__06-02-2013__lifestyle__fs_sb__Roland_Haschka_QParks__3.jpg"]},
                         
                         @{@"name" : @"Image 3",
                           @"imageURL" : [NSURL URLWithString:@"http://medias.lequipe.fr/adrenaline/img-photo-jpg/burton-presents-backcountry/11172/0:0,1496:842-800-0-/b51b7"]},
                         
                         @{@"name" : @"Image 4",
                           @"imageURL" : [NSURL URLWithString:@"http://www.thelegacyproject.co.za/wp-content/uploads/2014/08/profile-pic-21.jpg"]},
                         
                         @{@"name" : @"Image 5",
                           @"imageURL" : [NSURL URLWithString:@"http://riderhelp.ru/shared/files/201406/245_5232.jpg"]},
                         
                         @{@"name" : @"Image 6",
                           @"imageURL" : [NSURL URLWithString:@"http://www.hotellatorretta.com/images/content/565491_42768_3_S_0_600_0_21838909/ds-0040-ebene-22.jpg"]},
                         
                         @{@"name" : @"Image 7",
                           @"imageURL" : [NSURL URLWithString:@"http://snowbrains.com/wp-content/uploads/2014/01/url-2.jpeg"]},
                         
                         @{@"name" : @"Image 8",
                           @"imageURL" : [NSURL URLWithString:@"http://www.qparks.com/files/images/6795/315489__web_Serfaus_Fiss_Ladis_Freeride__06-02-2013__lifestyle__fs_sb__Roland_Haschka_QParks__3.jpg"]},
                         
                         @{@"name" : @"Image 9",
                           @"imageURL" : [NSURL URLWithString:@"http://medias.lequipe.fr/adrenaline/img-photo-jpg/burton-presents-backcountry/11172/0:0,1496:842-800-0-/b51b7"]},
                         
                         @{@"name" : @"Image 10",
                           @"imageURL" : [NSURL URLWithString:@"http://www.thelegacyproject.co.za/wp-content/uploads/2014/08/profile-pic-21.jpg"]}
                         ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayImages.count; // кол-во из массива arrayImages
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ThumbnailCustomCell cellID] forIndexPath:indexPath];
    [cell configForItem:[self.arrayImages objectAtIndex:indexPath.row]]; // настройки ячейки, реализация в классе CustomCollectionViewCell
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end

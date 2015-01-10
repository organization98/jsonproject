//
//  AlbumViewController.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *arrayImages;

@end

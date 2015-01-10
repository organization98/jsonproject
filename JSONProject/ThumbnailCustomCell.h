//
//  ThumbnailCustomCell.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 1/10/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbnailCustomCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;


+ (NSString *)cellID;
- (void)configForItem:(id)object;

@end

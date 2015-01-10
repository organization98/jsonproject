//
//  ThumbnailCustomCell.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 1/10/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "ThumbnailCustomCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ThumbnailCustomCell


+ (NSString *)cellID {
    return NSStringFromClass([self class]);
}


- (void)configForItem:(id)object {
    
    NSDictionary *dict = (NSDictionary *)object;
    NSURL *imageURL = [dict objectForKey:@"imageURL"];
    [self.thumbnailView setImageWithURL:imageURL];
    
    self.thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLable.text = [dict objectForKey:@"name"];
    
    /*
     UIViewContentModeScaleToFill,
     UIViewContentModeScaleAspectFit,
     UIViewContentModeScaleAspectFill,
     UIViewContentModeRedraw,
     UIViewContentModeCenter,
     UIViewContentModeTop,
     UIViewContentModeBottom,
     UIViewContentModeLeft,
     UIViewContentModeRight,
     UIViewContentModeTopLeft,
     UIViewContentModeTopRight,
     UIViewContentModeBottomLeft,
     UIViewContentModeBottomRight,
     */
}

@end

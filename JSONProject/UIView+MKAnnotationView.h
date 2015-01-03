//
//  UIView+MKAnnotationView.h
//  MapTest
//
//  Created by Dmitriy Demchenko on 12/14/14.
//  Copyright (c) 2014 Organization98. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKAnnotationView;

@interface UIView (MKAnnotationView)

- (MKAnnotationView *)superAnnotationView;

@end
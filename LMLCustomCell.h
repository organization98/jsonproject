//
//  LMLCustomCell.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMLCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *firstAndLastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *customImageView;



@end
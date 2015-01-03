//
//  CustomCell.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@interface CustomCell : UITableViewCell

@property (nonatomic, strong) User *curretUser;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageCustomView;

+ (CustomCell *)customCell;
+ (NSString *)cellID;
//- (void)configForItem:(id)object;
- (void)configForItem:(User *)user;

@end
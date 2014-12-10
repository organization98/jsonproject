//
//  CustomCell.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

+ (CustomCell *)customCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[CustomCell cellID]
                                                     owner:nil
                                                   options:nil];
    return nibArray[0];
}


+ (NSString*) cellID {
    return NSStringFromClass([CustomCell class]);
}


- (void)configForItem:(User *)user {
    
    self.curretUser = user;
    self.nameLabel.text = [NSString stringWithFormat:@"name: %@", self.curretUser.name];
    self.phoneLabel.text = [NSString stringWithFormat:@"phone: %@", self.curretUser.phone];
    
    // кастомизация ImageView
    self.imageCustomView.layer.borderColor = [UIColor grayColor].CGColor;
    self.imageCustomView.layer.borderWidth = 1;
    self.imageCustomView.clipsToBounds = YES;
    self.imageCustomView.layer.cornerRadius = 23; // закругление углов
    //    self.imageCustomView.image = [UIImage imageNamed:[dict objectForKey:@"photo"]];
    self.imageCustomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
 }

/*
- (void)configForItem:(id)object {
    
    NSDictionary *dict = (NSDictionary *)object;
    
    self.nameLabel.text = [NSString stringWithFormat:@"name: %@", [dict objectForKey:@"name"]];
    self.phoneLabel.text = [NSString stringWithFormat:@"phone: %@", [dict objectForKey:@"phone"]];
    
    // кастомизация ImageView
    self.imageCustomView.layer.borderColor = [UIColor grayColor].CGColor;
    self.imageCustomView.layer.borderWidth = 1;
    self.imageCustomView.clipsToBounds = YES;
    self.imageCustomView.layer.cornerRadius = 23; // закругление углов
    //    self.imageCustomView.image = [UIImage imageNamed:[dict objectForKey:@"photo"]];
    self.imageCustomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
*/

@end
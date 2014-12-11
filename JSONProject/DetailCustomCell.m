//
//  DetailCustomCell.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/09/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "DetailCustomCell.h"
#import "DetailViewController.h"

@implementation DetailCustomCell


- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


// methods added
- (void)configurateForUser:(User *)user {
    
//    self.curretUser = user;
    //    self.usernameLabel.text = self.curretUser.name;
    //    self.companyLabel.text = self.curretUser.company.name;
    //
    //    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"dd.MMMM.yyyy"];
    //
    //    self.ageLabel.text = self.curretUser.age.stringValue;
    //    self.birthdayLabel.text = [formatter stringFromDate: self.curretUser.birthday];
}


- (void)setTextFieldDelegate:(id)object {
    self.textFieldValue.delegate = object;
}


+ (DetailCustomCell *)userCustomCell {
    NSArray* nibArray = [[NSBundle mainBundle]loadNibNamed:[DetailCustomCell cellID]
                                                     owner:nil options:nil];
    return nibArray[0];
}


+ (NSString*) cellID {
    return NSStringFromClass([DetailCustomCell class]);
}


@end
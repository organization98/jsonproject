//
//  DetailCustomCell.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/09/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@interface DetailCustomCell : UITableViewCell <UITextFieldDelegate>


@property (nonatomic, strong) User *curretUser;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldValue;

- (void)setTextFieldDelegate:(id)object;
- (void)configurateForUser:(User *)user;
+ (DetailCustomCell *)userCustomCell;
+ (NSString *)cellID;


@end
//
//  DetailCustomCellTableViewCell.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/09/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCustomCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldValue;

@end

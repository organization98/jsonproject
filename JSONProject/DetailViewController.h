//
//  DetailViewController.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/03/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMLUser.h"


@interface DetailViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) LMLUser *detail;

@property (strong,nonatomic) NSDictionary *params;

@property (weak, nonatomic) IBOutlet UITableView *fullUserInfoView;

- (IBAction)buttonSaveItem:(UIBarButtonItem *)sender;

@end
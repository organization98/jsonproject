//
//  ViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "NetworkManager.h"
#import "User.h"


@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) NSManagedObjectContext *managerContext;

@property (strong, nonatomic) /*NSMutableArray*/NSArray *usersArray;
@property (strong, nonatomic) NSArray *searchArray;

- (IBAction)saveButton:(id)sender;

@end
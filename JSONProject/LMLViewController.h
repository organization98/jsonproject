//
//  ViewController.m
//  PhotoAlbumTest
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMLCustomCell.h"
#import "LMLNetworkManager.h"
#import "LMLUser.h"


@interface LMLViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) NSMutableArray *usersArray;

@property (strong, nonatomic) NSArray *searchArray;

- (IBAction)saveButton:(id)sender;


@end
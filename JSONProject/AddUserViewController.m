//
//  AddUserViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 12/18/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "AddUserViewController.h"
#import "User.h"

@interface AddUserViewController ()

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add new user";
    
    // создаем кновку SAVE и указываем @selector
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(buttonSaveUser:)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

// Добавление нового пользоваателя
- (void)buttonSaveUser:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end

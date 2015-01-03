//
//  DetailViewController.h
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/03/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@interface DetailViewController : UIViewController

@property (nonatomic, strong) User *curretUser; //detail
@property (strong,nonatomic) NSDictionary *params;

@end
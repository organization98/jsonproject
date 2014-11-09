//
//  DetailViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/03/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "DetailViewController.h"
#import "LMLUser.h"


@interface DetailViewController ()

@end


@implementation DetailViewController {
    NSMutableArray *sections;
    NSMutableArray *sectionNames;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = self.detail.name;
    
    self.params = [self.detail dictionaryFromFullUser];
    
    sections = [[NSMutableArray alloc] init];
    sectionNames = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in self.params) {
        [sections addObject:[self.params objectForKey:dictionary]];
        [sectionNames addObject:dictionary];
    }
    [self.fullUserInfoView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[sectionNames objectAtIndex:section] uppercaseString];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[sections objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:indentifier];
    }
    
    NSDictionary *parametes = [[NSDictionary alloc] initWithDictionary:[sections objectAtIndex:indexPath.section]];
    NSArray *keys = [parametes allKeys];
    NSString *label = [keys objectAtIndex:indexPath.row];
    NSString *text = [parametes objectForKey:label];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@:", label];
    cell.detailTextLabel.text = text;
    return cell;
}




@end
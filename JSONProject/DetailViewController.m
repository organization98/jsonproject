//
//  DetailViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/03/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "DetailViewController.h"
#import "LMLUser.h"
#import "DetailCustomCellTableViewCell.h"
#import "LMLNetworkManager.h"


@interface DetailViewController ()

@end


@implementation DetailViewController {
    NSMutableArray *sections;
    NSMutableArray *sectionNames;
    NSMutableDictionary *fields;
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
    
    fields = [[NSMutableDictionary alloc] init];
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
    
    static NSString *indentifier = @"customDetailCell";
    
    DetailCustomCellTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    }
    
    NSDictionary *parametes = [[NSDictionary alloc] initWithDictionary:[sections objectAtIndex:indexPath.section]];
    NSArray *keys = [parametes allKeys];
    NSString *label = [keys objectAtIndex:indexPath.row];
    NSString *text = [parametes objectForKey:label];
    
    cell.labelTitle.text = [NSString stringWithFormat:@"%@:", label];
    cell.textFieldValue.text = text;
    
    [fields setObject:cell forKey:label];
    
    return cell;
}




- (IBAction)buttonSaveItem:(UIBarButtonItem *)sender {
    
   
    for (NSString *key in fields) {
        
        DetailCustomCellTableViewCell *cell = [fields objectForKey:key];
        
        NSLog(@"label: %@ value: %@", cell.labelTitle.text, cell.textFieldValue.text);
        
    }
     
    
    
    
}
@end
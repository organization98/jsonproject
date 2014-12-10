//
//  ViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataManager.h"
#import "CustomCell.h"
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSString *defaultTitle;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    defaultTitle = @"Users";
    self.navigationItem.title = defaultTitle;
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddUser:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveUser:)
                                                 name:@"saveUser" object:nil];
    
    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        User *item = [self.usersArray objectAtIndex:indexPath.row];
        [segue.destinationViewController setCurretUser:item]; // передача данных в DetailViewController
    }
}


// Добавление нового пользоваателя
- (void)buttonAddUser:(id)sender {
    
    // создаем объкет из User
    User *userObj = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                  inManagedObjectContext:self.managerContext];
    
    DetailViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailUser"];
    
    // передаем в EditUserController объект userObj
    [editView setCurretUser:userObj];
    
    [self.navigationController pushViewController:editView animated:YES];
}


- (void)saveUser:(NSNotification *)notification {
    
    [[CoreDataManager sharedManager] saveContext]; // метод сохранения изменений для EDIT и ADD
    
    [self reloadTable];
}


#pragma mark - Table Rows generate

//Получить данные из БД и заполнить массив
- (void)loadData {
    
    self.managerContext = [[CoreDataManager sharedManager] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:self.managerContext];
    [request setEntity:entity];
    
    self.usersArray = [self.managerContext executeFetchRequest:request error:nil];
}


- (void)reloadTable {
    [self loadData];
    [self.tableView reloadData];
}


// получаем кол-во ячеек из usersArray
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersArray.count;
}


// заполнение CustomCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:[CustomCell cellID] forIndexPath:indexPath];
    
//    User* user = [self.usersArray objectAtIndex:indexPath.row];
//    
//    cell.nameLabel.text = [NSString stringWithFormat:@"name: %@", user.name];
//    cell.phoneLabel.text = [NSString stringWithFormat:@"phone: %@", user.phone];
//    
//    // кастомизация ImageView
//    cell.imageCustomView.layer.borderColor = [UIColor grayColor].CGColor;
//    cell.imageCustomView.layer.borderWidth = 1;
//    
//    cell.imageCustomView.clipsToBounds = YES;
//    cell.imageCustomView.layer.cornerRadius = 23; // закругление углов
//    
////    cell.imageCustomView.image = [UIImage imageNamed:[dict objectForKey:@"photo"]];
//    cell.imageCustomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [cell configForItem:[self.usersArray objectAtIndex:indexPath.row]]; // настройки ячейки, реализация в классе CustomCell
    
    return cell;
}


#pragma mark - Delete User

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [context deleteObject:[self.usersArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if(![context save:&error]){
            NSLog(@"Can't delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        [self reloadTable];
    }
}


#pragma mark - Search Bar methods

// CancelButton
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.searchBar.showsCancelButton = NO;
    
    self.searchBar.text = nil;
    
    [searchBar resignFirstResponder];
    
    self.navigationItem.title = defaultTitle;
    [self.view endEditing:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES]; //
    
    [self reloadTable];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.searchBar.showsCancelButton = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES]; //
    
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if([searchText length] <= 0 ) {
        [self reloadTable];
        return;
    }
    
    // поиск в CoreData и вывод в tableView
    self.managerContext = [[CoreDataManager sharedManager] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[ch] %@", searchText];
    [request setPredicate:predicate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:self.managerContext];
    [request setEntity:entity];
    self.usersArray = [self.managerContext executeFetchRequest:request error:nil];
    
    [self.tableView reloadData];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    self.navigationItem.title = @"Search";
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.searchBar.showsCancelButton = YES;
}


// отписваемся от notification
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
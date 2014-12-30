//
//  ViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "AlbumManager.h"
#import "PhotosManager.h"
#import "CoreDataManager.h"
#import "CustomCell.h"
#import "DetailViewController.h"
#import "AddUserViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *filterControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSArray *usersArray;

@end

@implementation ViewController {
    NSString *defaultTitle;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    defaultTitle = @"Users";
    self.navigationItem.title = defaultTitle;
    
    // ссоздаем кнопку AddUser, устанавливаем @selector
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveUser:)
                                                 name:@"saveUser" object:nil];
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search";
    self.searchBar.returnKeyType = UIReturnKeySearch;
    
    // SegmentedControl, добавлен в Main.storyboard, устанавливаем @selector для SegmentedControl для выбора фильтрации списка юзеров
    [self.filterControl addTarget:self
                           action:@selector(indexDidChangeForSegmentedControl:)
                 forControlEvents:UIControlEventValueChanged];
    
    self.managedObjectContext = [CoreDataManager sharedManager].managedObjectContext;
    
    [self fetchedResultsController];
    
    [self loadUsers];
//    [self loadAlbums];
//    [self loadPhotos];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // отписваемся от notification
}


#pragma mark - Load data

//Получить данные по NSURL, сохранить в CoreData
- (void)loadUsers {
    [[NetworkManager sharedManager] loadDataFromURL:[NSURL URLWithString: @"http://jsonplaceholder.typicode.com/users/"] completion:^(BOOL succes, id data, NSError *error) {
        [self.tableView reloadData];
    }];
}


- (void)loadAlbums {
    [[AlbumManager sharedManager] loadDataFromURL:[NSURL URLWithString: @"http://jsonplaceholder.typicode.com/albums/"] completion:^(BOOL succes, id data, NSError *error) {
        //        [self.tableView reloadData];
    }];
}


- (void)loadPhotos {
    [[PhotosManager sharedManager] loadDataFromURL:[NSURL URLWithString: @"http://jsonplaceholder.typicode.com/photos/"] completion:^(BOOL succes, id data, NSError *error) {
//        [self.tableView reloadData];
    }];
}


- (void)reloadTable {
    [self loadUsers];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

// получаем кол-во ячеек из usersArray
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}


// заполнение CustomCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:[CustomCell cellID] forIndexPath:indexPath];
    [cell configForItem:[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row]];
    return cell;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name]; // Header
}
*/


#pragma mark - Actions

// Добавление нового пользоваателя
- (void)insertNewObject:(id)sender {
    
    // создаем объкет из User
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                               inManagedObjectContext:self.managedObjectContext];
    
    AddUserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"addUser"];
    
    // передаем в EditUserController объект userObj
    //    [controller setCurretUser:user];
    
    [self.navigationController pushViewController:controller animated:YES];
}


// Редактирование выбранного нового пользоваателя
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        User *curretnUser = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        [segue.destinationViewController setCurretUser:curretnUser]; // передача данных в DetailViewController
    }
}


// Удаление выбранного пользователя

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [context deleteObject:[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if(![context save:&error]){
            NSLog(@"Can't delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        [self.tableView reloadData];
    }
}


- (void)saveUser:(NSNotification *)notification {
    [[CoreDataManager sharedManager] saveContext]; // метод сохранения изменений для EDIT и ADD
    [self reloadTable];
}


#pragma mark - SearchBar methods

// CancelButton
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = nil;
    [searchBar resignFirstResponder];
    self.navigationItem.title = defaultTitle;
    [self.view endEditing:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView reloadData];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if([searchText length] <= 0 ) {
//        [self reloadTable];
        [self.tableView reloadData];
        return;
    }
    
    // поиск в CoreData и вывод в tableView
    self.managedObjectContext = [[CoreDataManager sharedManager] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[ch] %@", searchText];
    [request setPredicate:predicate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
//    self.usersArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    self.usersArray = [self.fetchedResultsController fetchedObjects];
    
    [self.usersArray filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.navigationItem.title = @"Search";
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.searchBar.showsCancelButton = YES;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
//    self.managedObjectContext = [CoreDataManager sharedManager].managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchLimit:100];         // Let's say limit fetch to 100
    [fetchRequest setFetchBatchSize:20];      // After 20 are faulted
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    return _fetchedResultsController;
}


// NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

#pragma mark - Users filter view

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl {
    
    switch (aSegmentedControl.selectedSegmentIndex) {
        case 0:
//            aZzA = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            break;
        case 1:
//            aZzA = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
            break;
            
        default:
            break;
    }
}


@end
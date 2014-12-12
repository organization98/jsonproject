//
//  ViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "CoreDataManager.h"
#import "CustomCell.h"
#import "DetailViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
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
        User *curretnUser = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        [segue.destinationViewController setCurretUser:curretnUser]; // передача данных в DetailViewController
    }
}


// Добавление нового пользоваателя
- (void)buttonAddUser:(id)sender {
    
    // создаем объкет из User
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                  inManagedObjectContext:self.managedObjectContext];
    
    DetailViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailUser"];
    
    // передаем в EditUserController объект userObj
    [editView setCurretUser:user];
    
    [self.navigationController pushViewController:editView animated:YES];
}


- (void)saveUser:(NSNotification *)notification {
    
    [[CoreDataManager sharedManager] saveContext]; // метод сохранения изменений для EDIT и ADD
    
    [self reloadTable];
}


#pragma mark - Table Rows generate

//Получить данные из БД и заполнить массив
- (void)loadData {
    
    [[NetworkManager sharedManager] loadDataFromURL:[NSURL URLWithString: @"http://jsonplaceholder.typicode.com/users"] completion:^(BOOL succes, id data, NSError *error) {
    
        self.managedObjectContext = [CoreDataManager sharedManager].managedObjectContext;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User"
                                                             inManagedObjectContext:self.managedObjectContext];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                         ascending:NO];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entityDescription;
        fetchRequest.sortDescriptors = @[sortDescriptor];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        fetchedResultsController.delegate = self;
        self.fetchedResultsController = fetchedResultsController;
        [self.fetchedResultsController performFetch:nil];
        
        [self.tableView reloadData];
    }];
}


- (void)reloadTable {
    [self loadData];
    [self.tableView reloadData];
}


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


#pragma mark - Delete User

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
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES]; //
    
    [self reloadTable];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.searchBar.showsCancelButton = NO;
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES]; //
    
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if([searchText length] <= 0 ) {
        [self reloadTable];
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
    self.usersArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    [self.tableView reloadData];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    self.navigationItem.title = @"Search";
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.searchBar.showsCancelButton = YES;
}


// отписваемся от notification
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
            
        default:
            break;
    }
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


@end
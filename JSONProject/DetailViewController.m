//
//  DetailViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/03/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailCustomCell.h"

@interface DetailViewController ()

@end

@implementation DetailViewController {
    NSMutableArray *sections;
    NSMutableArray *sectionNames;
    NSMutableDictionary *fields;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = self.curretUser.name;
    
    self.params = [self.curretUser dictionaryFromFullUser];
    
    sections = [[NSMutableArray alloc] init];
    sectionNames = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in self.params) {
        [sections addObject:[self.params objectForKey:dictionary]];
        [sectionNames addObject:dictionary];
    }
    
    /*
    sections = [[NSMutableArray alloc] init];
    sectionNames = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in self.curretUser) {
        [sections addObject:[self.curretUser objectForKey:dictionary]];
        [sectionNames addObject:dictionary];
    }
    */
    
    [self.detailTableView reloadData];
    
    fields = [[NSMutableDictionary alloc] init]; // заполняем Dictionary для сохранения изменений
}

/*
- (void)viewWillAppear:(BOOL)animated {
    
    // подписывемся на 2 нотификациии
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil]; // подписка на notification для UIKeyboardWillShowNotification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil]; // подписка на notification для UIKeyboardWillHideNotification
}
*/

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // отписка от всех notification
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    DetailCustomCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[DetailCustomCell cellID]];
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:[DetailCustomCell cellID] forIndexPath:indexPath];
    }
    
    NSDictionary *parametes = [[NSDictionary alloc] initWithDictionary:[sections objectAtIndex:indexPath.section]];
    NSArray *keys = [parametes allKeys];
    NSString *label = [keys objectAtIndex:indexPath.row];
    NSString *text = [parametes objectForKey:label];
    
    cell.labelTitle.text = [NSString stringWithFormat:@"%@:", label];
    cell.textFieldValue.text = text;
//    cell.textFieldValue.delegate = self;
    
    [fields setObject:cell forKey:label];
    
    [cell setTextFieldDelegate:self]; // слежение за поведением всех TextField
    
    return cell;
}

/*
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // убирает клавиатуру при нажатии на RETURN
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    DetailCustomCell *cell = (DetailCustomCell *)[[textField superview] superview];
    // получаем массив indexPath-ов
    NSArray *indexPath = [self.detailTableView indexPathsForRowsInRect: cell.frame];
    [self.detailTableView scrollToRowAtIndexPath:indexPath[0] atScrollPosition: UITableViewScrollPositionTop animated:YES];
    //self.fullUserInfoView scroll;
}


#pragma mark - Keyboard methods

- (void)keyboardWillShow: (NSNotification *)notification {
    
    // получаем из dictionary фрейм клавиатуры
    CGRect keyboardFrame = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect tableFrame = self.detailTableView.frame; // получаем фрейм View
    tableFrame.origin.y = 0;
    tableFrame.size.height = CGRectGetMaxY(self.view.frame) - keyboardFrame.size.height;
    self.detailTableView.frame = tableFrame;
    
//    NSIndexPath *index = self.fullUserInfoView.indexPathForSelectedRow;
//    cellRect = [self.fullUserInfoView rectForRowAtIndexPath:index];
//    NSLog(@"x = %f, y = %f, height = %f, width = %f", cellRect.origin.x, cellRect.origin.y, cellRect.size.height, cellRect.size.width);
//    
////    CGRect scrollFrame = self.scrollView.frame; // получаем фрейм скролла
//    
//    //    CGRect searchTextFrame = self.searchTextField.frame;
//    //    [self.searchTextField setFrame:searchTextFrame];
//    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, cellRect.size.height + keyboardFrame.size.height); //присвоение нового фрейма
//    
//    [self.scrollView setContentOffset:CGPointMake(0, keyboardFrame.size.height) animated:YES]; // изменение позиции основного фрейма
    
    
//    [self.scrollView setScrollEnabled:NO]; // scroll view не скроллился пока клавиатура активна
}


- (void)keyboardWillHide: (NSNotification *)notification {
    
    CGRect scrollFrame = self.detailTableView.frame;
    
    self.detailTableView.contentSize = CGSizeMake(self.detailTableView.contentSize.width, scrollFrame.size.height);
    
    [self.detailTableView setContentOffset:CGPointZero animated:YES]; // возврат фрейма в исходное положение
    
    
    
//    CGRect scrollFrame = self.scrollView.frame;
//    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, scrollFrame.size.height);
//    
//    [self.scrollView setContentOffset:CGPointZero animated:YES]; // возврат фрейма в исходное положение
}
*/

#pragma mark - Save button

- (IBAction)buttonSaveItem:(UIBarButtonItem *)sender {
    
    for (NSString *key in fields) {
        DetailCustomCell *cell = [fields objectForKey:key];
    }
    // генерируем событие
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveUser" object:nil];
    
    // вернуться на главный контроллер
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
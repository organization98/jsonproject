//
//  DetailViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/03/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "DetailViewController.h"
#import "User.h"
#import "DetailCustomCell.h"
#import "NetworkManager.h"


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
    
    [self.fullUserInfoView reloadData];
    
    fields = [[NSMutableDictionary alloc] init]; // заполняем Dictionary для сохранения изменений
}


- (void)viewWillAppear:(BOOL)animated {
    
    // подписывемся на 2 нотификациии
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil]; // подписка на notification для UIKeyboardWillShowNotification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil]; // подписка на notification для UIKeyboardWillHideNotification
}


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
    
    static NSString *identificator = @"customDetailCell";
    
    DetailCustomCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identificator];
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:identificator forIndexPath:indexPath];
    }
    
    NSDictionary *parametes = [[NSDictionary alloc] initWithDictionary:[sections objectAtIndex:indexPath.section]];
    NSArray *keys = [parametes allKeys];
    NSString *label = [keys objectAtIndex:indexPath.row];
    NSString *text = [parametes objectForKey:label];
    
    cell.labelTitle.text = [NSString stringWithFormat:@"%@:", label];
    cell.textFieldValue.text = text;
    cell.textFieldValue.delegate = self;
    
    [fields setObject:cell forKey:label];
    
    [cell setTextFieldDelegate:self]; // слежение за поведение всех TextField
    
    return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // убирает клавиатуру при нажатии на RETURN
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    DetailCustomCell *cell = (DetailCustomCell *)[[textField superview] superview];
    // получаем массив indexPath-ов
    NSArray *indexPath = [self.fullUserInfoView indexPathsForRowsInRect: cell.frame];
    [self.fullUserInfoView scrollToRowAtIndexPath:indexPath[0] atScrollPosition: UITableViewScrollPositionTop animated:YES];
    //self.fullUserInfoView scroll;
}


#pragma mark - Keyboard methods

- (void)keyboardWillShow: (NSNotification *)notification {
    
    // получаем из dictionary фрейм клавиатуры
    CGRect keyboardFrame = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect tableFrame = self.fullUserInfoView.frame; // получаем фрейм View
    tableFrame.origin.y = 0;
    tableFrame.size.height = CGRectGetMaxY(self.view.frame) - keyboardFrame.size.height;
    self.fullUserInfoView.frame = tableFrame;
    
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
    
    // scrollView не скроллился пока клавиатура активна
    //    [self.scrollView setScrollEnabled:NO];
}


- (void)keyboardWillHide: (NSNotification *)notification {
    
    CGRect scrollFrame = self.scrollView.frame;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, scrollFrame.size.height);
    
    [self.scrollView setContentOffset:/*CGPointMake(0, 0)*/CGPointZero animated:YES]; // возврат фрейма в исходное положение
}


#pragma mark - Save button

- (IBAction)buttonSaveItem:(UIBarButtonItem *)sender {
    
    for (NSString *key in fields) {
        DetailCustomCell *cell = [fields objectForKey:key];
    }
}


@end
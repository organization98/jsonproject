//
//  LMLViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 10/30/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import "LMLViewController.h"
#import "DetailViewController.h"


@interface LMLViewController ()

@end

@implementation LMLViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"Users"; // установка title для Navigation Controller
    
    NSURL *url = [NSURL URLWithString: @"http://jsonplaceholder.typicode.com/users"];
    
    [[LMLNetworkManager sharedManager] loadDataFromURL:url completion:^(BOOL succes, id data, NSError *error) {
        self.usersArray = [NSMutableArray arrayWithArray:data];
        
        self.searchArray = [NSArray arrayWithArray:data];
        
        [self.mainTableView reloadData];
    }];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // отписка от notification
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self /*кто подписывается*/ selector:@selector(keyboardWillShow:) /*вызывается этот метод*/ name:UIKeyboardWillShowNotification object:nil]; // oбъявление NSNotificationCenter
    
    [[NSNotificationCenter defaultCenter] addObserver:self /*кто подписывается*/ selector:@selector(keyboardWillHide:) /*вызывается этот метод*/ name:UIKeyboardWillHideNotification object:nil];
}


// заполнение CustomCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LMLCustomCell* cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];
    LMLUser* user = [self./*usersArray*/searchArray objectAtIndex:indexPath.row];
    
    cell.firstAndLastNameLabel.text = [NSString stringWithFormat:@"name: %@", user.name];
    cell.phoneNumberLabel.text = [NSString stringWithFormat:@"phone: %@", user.phone];
    
    // кастомизация ImageView
    cell.customImageView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.customImageView.layer.borderWidth = 1;
    cell.customImageView.layer.cornerRadius = 5; // закругление углов
    cell.customImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.mainTableView indexPathForSelectedRow];
    if (indexPath) {
        LMLUser *item = [self./*usersArray*/searchArray objectAtIndex:indexPath.row];
        [segue.destinationViewController setDetail:item]; // передача данных в DetailViewController
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self./*usersArray*/searchArray.count;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // убирает клавиатуру при нажатии на RETURN
    [self filterMyUsers];
    return YES;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTextField resignFirstResponder]; // если начинаем скроллить, - клавиатура убирается
}


#pragma Mark - IBAction

- (IBAction)saveButton:(id)sender {
    
    LMLUser* user = [[LMLUser alloc]init];
    user.name = @"Kate White";
    user.username = @"Katy W";
    user.email = @"magazine@mail.dp.ua";
    user.phone = @"056-792-00-00";
    user.website = @"magazine.dp.ua";
    [[LMLNetworkManager sharedManager] saveUser:user completion:^(BOOL succes, id data, NSError *error) {
        [self.usersArray addObject:data];
        [self.mainTableView reloadData];
    }];
}


// method added
- (void)filterMyUsers {
    if (self.searchTextField.text.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[ch] %@", self.searchTextField.text];
        self.searchArray = [self.usersArray filteredArrayUsingPredicate:predicate]; // формирование массива
        [self.mainTableView reloadData];
    }
}


- (void)keyboardWillShow: (NSNotification *)notification {
    
    // @property (readonly, copy) NSDictionary *userInfo;
    NSLog(@"%@", notification.userInfo); // положение клавиатуры в пространстве
    
    // размер клавиатуры
    CGRect keyboardFrame = [notification.userInfo [UIKeyboardFrameEndUserInfoKey]/*ключ*/ CGRectValue]; // получаем из dictionary фрейм клавиатуры
    
    CGRect scrollFrame = self.scrollView.frame; // получаем фрейм скролла
    
    //    CGRect searchTextFrame = self.searchTextField.frame;
    //    [self.searchTextField setFrame:searchTextFrame];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, scrollFrame.size.height + keyboardFrame.size.height); //присвоение нового фрейма
    
    [self.scrollView setContentOffset:CGPointMake(0, keyboardFrame.size.height) animated:YES]; // изменение позиции основного фрейма
    
    // scrollView не скроллился пока клавиатура активна
    //    [self.scrollView setScrollEnabled:NO];
}


- (void)keyboardWillHide: (NSNotification *)notification {
    
    CGRect scrollFrame = self.scrollView.frame;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, scrollFrame.size.height);
    
    [self.scrollView setContentOffset:/*CGPointMake(0, 0)*/CGPointZero animated:YES]; // возврат фрейма в исходное положение
}


@end
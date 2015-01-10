//
//  DetailViewController.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/03/14.
//  Copyright (c) 2014 Dmitriy Demchenko. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "DetailViewController.h"
#import "DetailCustomCell.h"
#import "MapViewController.h"
#import "AlbumViewController.h"
#import "Address.h"

@interface DetailViewController () <UITableViewDataSource,
                                    UITextFieldDelegate,
                                    UIActionSheetDelegate,
                                    MFMailComposeViewControllerDelegate,
                                    MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsCollection;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView; //*fullUserInfoView;

@end


@implementation DetailViewController {
    NSMutableArray *sections;
    NSMutableArray *sectionNames;
    NSMutableDictionary *fields;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = self.curretUser.name;
    
    
    // Buttons
    
    // создаем кновку SAVE и указываем @selector
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(buttonSaveItem:)];
    
    // создаем кновку INFO и указываем @selector
    UIBarButtonItem *additionalInfoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openBarButtonAction:)];
    
    // размещаем массив кнопок на navigationItem
    self.navigationItem.rightBarButtonItems = @[additionalInfoButton, saveButton];
    
    //
    
    
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

#pragma mark - Actions

- (void)buttonSaveItem:(UIBarButtonItem *)sender {
    
    for (NSString *key in fields) {
        DetailCustomCell *cell = [fields objectForKey:key];
    }
    // генерируем событие
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveUser" object:nil];
    
    // вернуться на главный контроллер
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)openBarButtonAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Open website in Safari", @"Send e-mail", @"Send SMS", [NSString stringWithFormat:@"%@ on map", self.curretUser.name], @"Album gallery", nil];
    [actionSheet showInView:self.view]; // оттображение на текущем View
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex; {
    switch (buttonIndex) {
        case 0: // Safari
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.curretUser.website]]];
            break;
        case 1: // Mail
            if ([MFMailComposeViewController canSendMail]) {
                [self sendMail];
            } else {
                [self alert:@"This device cannot send e-mail"];
            }
            break;
        case 2: // SMS
            [self sendSMS]; // Удалить!
            if ([MFMessageComposeViewController canSendText]) {
                [self sendSMS];
            } else {
                [self alert:@"This device cannot send SMS"];
            }
            break;
        case 3: // Map
            [self performSegueWithIdentifier:@"ShowMap" sender:self];
            break;
        case 4: // Album Gallery
            [self performSegueWithIdentifier:@"ShowAlbumGallery" sender:self];
            break;
        default:
            break;
    }
}


- (MFMailComposeViewController *)sendMail {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setToRecipients:[NSArray arrayWithObject:self.curretUser.email]];
    [mailController setSubject:@"Test e-mail"];
    [mailController setMessageBody:[self messageBody] isHTML:NO];
    [self presentViewController:mailController animated:YES completion:NULL];
    return mailController;
}


- (MFMessageComposeViewController *)sendSMS {
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    messageController.subject = @"Test message";
    messageController.recipients = [NSArray arrayWithObject:self.curretUser.phone];
    messageController.body = [self messageBody];
    [self presentViewController:messageController animated:YES completion:NULL];
    return messageController;
}


- (NSString *)messageBody {
    return [NSString stringWithFormat:@"Dear, %@", self.curretUser.name];
}


#pragma mark - AlerView

- (UIAlertView *)alert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    [alert show];
    return alert;
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent || result == MFMailComposeResultSaved || result == MFMailComposeResultCancelled) {
        switch (result) {
            case MFMailComposeResultSent:
                [self alert:@"You sent the email."];
                break;
            case MFMailComposeResultSaved:
                [self alert:@"You saved a draft of this email"];
                break;
            case MFMailComposeResultCancelled:
                [self alert:@"You cancelled sending this email."];
                break;
            case MFMailComposeResultFailed:
                [self alert:@"Mail failed:  An error occurred when trying to compose this email"];
                break;
            default:
                [self alert:@"An error occurred when trying to compose this email"];
                break;
        }
    } else if (error != nil) {
        [self alert:[error localizedDescription]]; //show error
    }
    [self dismissViewControllerAnimated:YES completion:NULL]; //dismiss view
}


#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    //test result
    switch (result) {
        case MessageComposeResultCancelled:
            [self alert:@"Result canceled"];
            break;
            //message was sent
        case MessageComposeResultSent:
            [self alert:@"Result sent"];
            break;
        case MessageComposeResultFailed:
            [self alert:@"Result Failed"];
            break;
        default:
            break;
    }
    
    //dismiss view
    [self dismissViewControllerAnimated:YES completion:NULL]; //dismiss view
}
//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *mapController = segue.destinationViewController;
//    mapController = ;
    AlbumViewController *albumController = segue.destinationViewController;
//    albumController.url = _detail.link;
}


@end
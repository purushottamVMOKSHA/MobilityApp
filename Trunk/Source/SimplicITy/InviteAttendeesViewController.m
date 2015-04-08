//
//  InviteAttendeesViewController.m
//  SimplicITy
//
//  Created by Vmoksha on 06/04/15.
//  Copyright (c) 2015 Vmoksha. All rights reserved.
//

#import "InviteAttendeesViewController.h"
#import "UserInfo.h"
#import "RoomManager.h"
#import "CalendarEvent.h"

@interface InviteAttendeesViewController ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InviteAttendeesViewController
{
    __weak IBOutlet UIButton *sendInviteButton;
    NSArray *dataOfFirstSection;
    NSArray *dataOfThirdSection;
    
    NSString *dateForBooking;
    NSString *startDateString, *endDateString;
    NSDateFormatter *dateFormatter;
    
    NSString *userName;
    NSString *venue;
    
    RoomManager *roomManager;
    CalendarEvent *newEvent;
    
    UITextField *activeField;
    
    NSMutableArray *reqiuredAttentees;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Invite Attendees";
    
    dataOfFirstSection = @[@"Date",@"Start",@"End",@"Organizer",@"Venue"];
    dataOfThirdSection = @[@"",@"Marc",@"Bin",@"Antony",@"Sundar"];

    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE dd MMMM yyyy";
    dateForBooking = [dateFormatter stringFromDate:self.startDate];
    
    dateFormatter.dateFormat = @"hh.mm a";
    startDateString = [dateFormatter stringFromDate:self.startDate];
    endDateString = [dateFormatter stringFromDate:self.endDate];
    
    userName = [UserInfo sharedUserInfo].fullName;
    venue = self.selectedRoom.nameOfRoom;
    
    sendInviteButton.layer.cornerRadius = 5;
    sendInviteButton.titleLabel.font = [self customFont:16 ofName:MuseoSans_700];

    roomManager = [[RoomManager alloc] init];
    
    newEvent = [[CalendarEvent alloc] init];
    
    newEvent.startDate = self.startDate;
    newEvent.endDate = self.endDate;
    newEvent.location = self.selectedRoom.nameOfRoom;
    newEvent.resources = @[self.selectedRoom.emailIDOfRoom];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                              forKeyPath:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                              forKeyPath:UIKeyboardWillHideNotification];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.tableView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)addAttentee:(UIButton *)sender
{
    if (reqiuredAttentees == nil)
    {
        reqiuredAttentees = [[NSMutableArray alloc] init];
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:2];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    UITextField *txtField = (UITextField*)[cell viewWithTag:100];
    
    if (txtField.text.length > 0)
    {
        [reqiuredAttentees addObject:txtField.text];
        [self.tableView reloadData];
        txtField.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma  mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [dataOfFirstSection count];
    }else if (section == 1)
    {
        return 1;
    }else
    {
        //first cell in this section is text field to enter the emailIDs
        return ([reqiuredAttentees count] + 1);
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

        UILabel *leftLable = (UILabel*)[cell viewWithTag:100];
        UILabel *rightLable = (UILabel*)[cell viewWithTag:200];
        leftLable.text = dataOfFirstSection[indexPath.row];
        switch (indexPath.row)
        {
            case 0:
                rightLable.text = dateForBooking;
                break;
            case 1:
                rightLable.text = startDateString;
                break;
            case 2:
                rightLable.text = endDateString;
                break;
            case 3:
                rightLable.text = userName;
                break;
            case 4:
                rightLable.text = venue;
                break;
            default:
                break;
        }
        leftLable.font = [self customFont:16 ofName:MuseoSans_700];
        rightLable.font = [self customFont:16 ofName:MuseoSans_700];
    }else if (indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];

        UITextField *txtField = (UITextField*)[cell viewWithTag:100];
        txtField.delegate = self;
        txtField.placeholder = @"Subject";
        UIButton *btn = (UIButton *)[cell viewWithTag:200];
        btn.hidden = YES;
    }else
    {
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
            UITextField *txtField = (UITextField*)[cell viewWithTag:100];
            txtField.delegate = self;
            txtField.placeholder = @"Enter Email";
            txtField.keyboardType = UIKeyboardTypeEmailAddress;
            UIButton *btn = (UIButton *)[cell viewWithTag:200];
            btn.hidden = NO;
            [btn addTarget:self action:@selector(addAttentee:) forControlEvents:(UIControlEventTouchUpInside)];
            
        }else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
            UILabel *rightLable = (UILabel*)[cell viewWithTag:100];
            rightLable.text = reqiuredAttentees[indexPath.row - 1];
            rightLable.font = [self customFont:16 ofName:MuseoSans_700];
            
            UIImageView *imageView = (UIImageView*)[cell viewWithTag:200];
            
            if (indexPath.row == 1)
            {
                imageView.image = [UIImage imageNamed:@"Sel1"];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView =  [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 150, 30))];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:(CGRectMake(18, 0, 150, 30))];
    
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    
    if (section == 0)
    {
        headerLabel.text = @"Meeting Details";
    }else if (section == 1)
    {
        headerLabel.text = @"Subject";
    }else if (section == 2)
    {
        headerLabel.text = @"Add attendees";
    }
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (IBAction)sendInvites:(UIButton *)sender
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  TicketDetailViewController.m
//  SimplicITy
//
//  Created by Varghese Simon on 12/16/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "TicketDetailViewController.h"
#import "DashBoardViewController.h"

@interface TicketDetailViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrOfLable;
    UIBarButtonItem *backButton;
    
    NSDateFormatter *dateFormatter;
}

@end

@implementation TicketDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrOfLable = @[@"Requester",@"Impact",@"Services",@"Agent",@"Status"];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a, dd MMM, yyyy"];
//    self.navigationController.navigationItem.hidesBackButton = YES;
    
//    [self.navigationItem setHidesBackButton:YES animated:YES];


    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    [back setTitle:@"< Back" forState:UIControlStateNormal];
//    back.frame = CGRectMake(0, 0, 60, 40);
//    [back setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [back  addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
//    self.navigationItem.leftBarButtonItem = backButton;

    
    
}

//-(void)backBtnAction
//{
//    
//    DashBoardViewController *raiseTicketVC = [[DashBoardViewController alloc] init];
//    [self.navigationController popToViewController:raiseTicketVC animated:YES];
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;

    }else if (section == 1)
    {
        return 1;
    }
    else
    {
        return 1;
    }

}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    if (section == 0) {
//        return @"";
//        
//    }else if (section == 1)
//    {
//        return @"Services";
//    }
//    else{
//        return @"Details";
//    }
//   
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  tableView.bounds.size.width, 30)];
    
        UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake (17,4,320,30)];
        labelHeader.font = [self customFont:16 ofName:MuseoSans_700];
        labelHeader.textColor = [UIColor blackColor];
        [headerView addSubview:labelHeader];
    
    
    if (section == 0)
    {
        
    }else if (section == 1)
    {
        if ([self.orderItemDifferForList isEqualToString:@"orderList"])
        {
            labelHeader.text = @"Item";
        }else
        {
            labelHeader.text = @"Service";
        }
        
    }
    else
    {
        labelHeader.text = @"Details";
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = nil;
    
    if (indexPath.section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellDetails" forIndexPath:indexPath];
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }

    UILabel *titleLable = (UILabel *)[cell viewWithTag:100];
    
    titleLable.font=[self customFont:16 ofName:MuseoSans_700];
    
    
    UILabel *linColour = (UILabel *)[cell viewWithTag:101];
    UILabel *circelColour = (UILabel *)[cell viewWithTag:102];
    UILabel *rightTable = (UILabel *)[cell viewWithTag:103];
    rightTable.font=[self customFont:16 ofName:MuseoSans_300];

//    UILabel *discriptionLable = (UILabel *)[cell1 viewWithTag:104];

    rightTable.hidden = NO;
    circelColour.layer.cornerRadius = 10;
    titleLable.textColor = [UIColor blackColor];
    
    if (indexPath.section == 1) {
        titleLable.text = self.requestModel.requestServiceName;
        rightTable.text = @"";
        titleLable.font=[self customFont:16 ofName:MuseoSans_300];
        titleLable.textColor = [UIColor lightGrayColor];
    }
    else if (indexPath.section == 2)
    {
        UITextView *titleTextView = (UITextView *)[cell viewWithTag:100];
        titleTextView.text = self.requestModel.requestDetails;
        titleTextView.textAlignment = NSTextAlignmentJustified;
        rightTable.hidden = YES;
        titleTextView.textColor = [UIColor lightGrayColor];
        titleTextView.font = [self customFont:16 ofName:MuseoSans_300];
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
            {
                titleLable.text = @"Requester";
                rightTable.text = @"Jim Kohler";
                
            }
                
                break;
                
            case 1:
            {
                titleLable.text = @"Impact";
                rightTable.text = [self giveImpactForCOlor:self.requestModel.requestImpact];
                linColour.backgroundColor = [self colorForImpact:self.requestModel.requestImpact];
                circelColour.backgroundColor = [self colorForImpact:self.requestModel.requestImpact];
                
            }
                break;
            case 2:
            {
                titleLable.text = @"Agent";
//                rightTable.text = self.tickModel.agentName;
                rightTable.text = @"";
                
            }
                break;
            case 3:
            {
                titleLable.text = @"Status";
//                rightTable.text = self.tickModel.currentStatus;
                rightTable.text = @"";
            }
                break;
            case 4:
            {
                
                titleLable.text = @"Date";
//                rightTable.text = self.tickModel.date;
                rightTable.text = [dateFormatter stringFromDate:self.requestModel.requestDate];
            }
                break;
            default:
                break;
        }
    }

        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        return 100;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (NSString *)giveImpactForCOlor:(NSInteger)colorCode
{
    switch (colorCode)
    {
        case 0:
            return @"Low";
            break;
            
        case 1:
            return @"Medium";
            break;
            
        case 2:
            return @"High";
            break;
            
        case 3:
            return @"Critical";
            break;
            
        default:
            break;
    }
    
    return nil;
}


- (UIColor *)colorForImpact:(NSInteger)imapact
{
    switch (imapact)
    {
        case 0:
            return [UIColor greenColor];
            break;
            
        case 1:
            return [UIColor yellowColor];
            break;
            
        case 2:
            return [UIColor orangeColor];
            break;
            
        case 3:
            return [UIColor redColor];
            break;
            
        default:
            break;
    }
    
    return nil;
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

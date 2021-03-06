//
//  LocationViewController.m
//  SimplicITy
//
//  Created by Vmoksha on 11/12/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrOfLocationData;
    UILabel *titleLable;
    NSInteger selectedRow;

    __weak IBOutlet UIBarButtonItem *locationCancleButton;

    __weak IBOutlet UIBarButtonItem *locationDoneButton;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrOfLocationData = @[@"Belgium",@"India",@"US",@"Japan",@"Bulgaria",@"France",@"Germany"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSInteger selectedindex = [[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedLocation"];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedindex inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
    
}

- (IBAction)CalcelBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)doneBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *selectedLocation = arrOfLocationData[[self.tableView indexPathForSelectedRow].row];
    
    [[NSUserDefaults standardUserDefaults] setInteger:[self.tableView indexPathForSelectedRow].row forKey:@"SelectedLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.delegate selectedLocationIs:selectedLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrOfLocationData count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  
    titleLable = (UILabel *)[cell viewWithTag:100];
    
    titleLable.font=[self customFont:16 ofName:MuseoSans_700];
    
    titleLable.text = arrOfLocationData[indexPath.row];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [self barColorForIndex:selectedRow];
    [cell setSelectedBackgroundView:bgColorView];
    

    titleLable.highlightedTextColor = [UIColor whiteColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
#pragma mark UITableViewDelegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    

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

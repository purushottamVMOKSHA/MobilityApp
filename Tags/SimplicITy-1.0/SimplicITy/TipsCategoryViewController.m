//
//  TipsCategoryViewController.m
//  SimplicITy
//
//  Created by Varghese Simon on 12/4/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "TipsCategoryViewController.h"
#import "TipsSubCategoriesViewController.h"
@interface TipsCategoryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TipsCategoryViewController
{
    NSArray *categoriesArray;
    NSDictionary *subCategory;
    UIBarButtonItem *backButton;
    
    
   // __weak IBOutlet UILabel *TipsCategory;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back_Arrow"] forState:UIControlStateNormal];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    back.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    back.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    back.frame = CGRectMake(0, 0,80, 40);
    [back setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [back  addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButton;

    
    
    categoriesArray = @[@"Lync", @"AD Password", @"ITMS",@"Travel",@"Meeting Room",@"Wireless Password"];
    
    subCategory = @{@"Lync":@[@"Instant Messaging", @"Voice Over IP", @"Voice conferencing"],
                    @"AD Password": @[@"Web Conferencing",@"Video Conferencing"],
                    @"ITMS":@[@"Financial Accounting (FI)",@"Controlling (CO)",@"Investment Management (IM)"],
                    @"Travel":@[@"Configuration Management",@"Change Management",@"Release Management",@"Incident Management"],
                    @"Meeting Room":@[@"Workspace Management",@"Mobile Security",@"Mobile Device Management"],
                    @"Wireless Password":@[@"Mobile Application Management",@"Mobile Content Management",@"Mobile Email Management"]
                    
                    };
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)backBtnAction
{
    [self.tabBarController setSelectedIndex:0];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    label.text = categoriesArray[indexPath.row];
    
   
    label.font=[self customFont:16 ofName:MuseoSans_700];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TipsCatToSubcatSegue"])
    {
        TipsSubCategoriesViewController *tipsSubVC = (TipsSubCategoriesViewController *)segue.destinationViewController;
        tipsSubVC.parentCategory = categoriesArray[[self.tableView indexPathForSelectedRow].row];
        tipsSubVC.subCategoriesData = subCategory[tipsSubVC.parentCategory];
    }
}

@end

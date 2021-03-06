//
//  SettingViewController.m
//  SimplicITy
//
//  Created by Vmoksha on 10/12/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "SettingViewController.h"
#import "LanguageViewController.h"
#import "LocationViewController.h"
#import "ThemesViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,languagesSettingdelegate,LocationSettingdelegate,ThemeSettingDelegate >
{
   NSArray  *arrOfTableViewData, *arrOfImages ;
    NSInteger selectedRow;
    UIBarButtonItem *backButton;
    
    NSArray *arrOfLocationData, *arrOfLanguageData;
    NSInteger selectedLocation, selectedLanaguage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Settings";
    
    arrOfTableViewData = @[@"Language",@"Location"];
    arrOfImages = @[@"language.png",@"lacation.png"];
    
    arrOfLocationData = @[@"Belgium",@"India",@"US",@"Japan",@"Bulgaria",@"France",@"Germany"];
    arrOfLanguageData = @[@"English",@"Dutch",@"German",@"French",@"Portuguese",@"Spanish",@"Japanese"];

    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"back_Arrow"] forState:UIControlStateNormal];
    [back setTitle:@"Home" forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:17];
    back.imageEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 0);
    back.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    back.frame = CGRectMake(0, 0,80, 30);
    [back setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [back  addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    selectedLocation = [[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedLocation"];
    selectedLanaguage = [[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedLanguage"];
    
    [self.tableView reloadData];
    self.navigationController.navigationBarHidden = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
      UINavigationController *navController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"language_segue"])
    {
        LanguageViewController *lang = navController.viewControllers[0];
        lang.delegate =self;
    }else if ([segue.identifier isEqualToString:@"location_segue"])
    {
        LocationViewController *locationVC = navController.viewControllers[0];
        locationVC.delegate = self;
    }else
    {
        ThemesViewController *themesVC = navController.viewControllers[0];
        themesVC.delegate = self;
    }
    
}


#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return [arrOfTableViewData count];
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
    imageView.image = [UIImage imageNamed:arrOfImages[indexPath.row]];
    
    UILabel *titleLable = (UILabel *)[cell viewWithTag:200];
    titleLable.text = arrOfTableViewData[indexPath.row];
    
    UILabel *languageLabel = (UILabel *)[cell viewWithTag:201];
    
    titleLable.font=[self customFont:16 ofName:MuseoSans_700];
    languageLabel.font=[self customFont:16 ofName:MuseoSans_700];
    
   
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            languageLabel.text = arrOfLanguageData[selectedLanaguage];
            
        }else
        {
            languageLabel.text = arrOfLocationData[selectedLocation];
            
        }
    }else
    {
        titleLable.text = @"Theme";
        imageView.image = [UIImage imageNamed:@"themes"];
        languageLabel.text = [self stingForColorTheme];
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [self barColorForIndex:selectedRow];
    [cell setSelectedBackgroundView:bgColorView];


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

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"language_segue" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"location_segue" sender:self];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"themes_segue" sender:self];
    }
 
}


#pragma mark SettingDelegates

-(void)selectedLanguageis:(NSString *)language
{
    UITableViewCell *languageCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UILabel *languageLabel = (UILabel *)[languageCell viewWithTag:201];
    languageLabel.text = language;
}

-(void)selectedLocationIs:(NSString *)location
{
    UITableViewCell *languageCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UILabel *languageLabel = (UILabel *)[languageCell viewWithTag:201];
    languageLabel.text = location;

}

-(void)selectedThemeIs:(NSString *)theme
{
    UITableViewCell *themesCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UILabel *themeLable = (UILabel *)[themesCell viewWithTag:201];
    themeLable.text = theme;
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"BackgroundTheme"];
    [self setTabImageForColorIndex:index onTabBar:tabBar];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [self colorForIndex:index]} forState:(UIControlStateNormal)];
}

- (void)setTabImageForColorIndex:(NSInteger)colorIndex onTabBar:(UITabBar *)tabBar;
{
    NSInteger imageIndex = colorIndex+1; //Image name say Commercial-01.png, staring index is 1.
    
    NSString *imageName0 = [NSString stringWithFormat:@"Dwelling-0%i.png", imageIndex];
    NSString *imageName1 = [NSString stringWithFormat:@"Commercial-0%i.png", imageIndex];
    NSString *imageName2 = [NSString stringWithFormat:@"Message-0%i.png", imageIndex];
    NSString *imageName3 = [NSString stringWithFormat:@"TipsIcon-0%i.png", imageIndex];
    NSString *imageName4 = [NSString stringWithFormat:@"Spanner-0%i.png", imageIndex];
    
    UITabBarItem *tabBarItem = tabBar.items[0];
    tabBarItem.image = [[UIImage imageNamed:imageName0] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem = tabBar.items[1];
    tabBarItem.image = [[UIImage imageNamed:imageName1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem = tabBar.items[2];
    tabBarItem.image = [[UIImage imageNamed:imageName2] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem = tabBar.items[3];
    tabBarItem.image = [[UIImage imageNamed:imageName3] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem = tabBar.items[4];
    tabBarItem.image = [[UIImage imageNamed:imageName4] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIColor *)colorForIndex:(NSInteger)colorIndex
{
    switch (colorIndex)
    {
        case 0:
            return [UIColor colorWithRed:.1 green:.16 blue:.2 alpha:1];
            break;
            
        case 1:
            return [UIColor colorWithRed:.4 green:.11 blue:.2 alpha:1];
            break;
            
        case 2:
            return [UIColor colorWithRed:.15 green:.18 blue:.09 alpha:1];
            break;
            
        case 3:
            return [UIColor colorWithRed:.35 green:.2 blue:.13 alpha:1];
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

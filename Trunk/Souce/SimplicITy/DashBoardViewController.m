//
//  DashBoardViewController.m
//  SimplicITy
//
//  Created by Varghese Simon on 12/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDeg 0.5
#define kAnimationTranslateX 1.0
#define kAnimationTranslateY 1.0



//Imported Classes- DashBoardViewController,MessagesViewController,RaiseATicketViewController,Postman,LocationModel,DBManager,UserInfo,BadgeNoManager,DashBoardModel,HexaColors,DashBoardCollectionViewCell
#import "DashBoardViewController.h"
#import "MessagesViewController.h"
#import "RaiseATicketViewController.h"
#import "TicketsListViewController.h"
#import "Postman.h"
#import "LocationModel.h"
#import "DBManager.h"
#import "UserInfo.h"
#import "DashBoardCollectionViewCell.h"
#import "BadgeNoManager.h"
#import "DashBoardModel.h"
#import "HexColors.h"
//Addded MCLocaliztion Framework Class
#import <MCLocalization/MCLocalization.h>
//Added MBProgressHud Framework Class
#import <MBProgressHUD/MBProgressHUD.h>

#define  CALL_IT_DESK_FROM_IPAD @"Calling facility is not available in this device"

//Added Postman,DBManager,UIActionSheet,UICollectionView,UIGestureRecognizer Delegate Method
@interface DashBoardViewController () <postmanDelegate,DBManagerDelegate,UIActionSheetDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
{
    BOOL navBtnIsOn;
    
    //Above Dashboard- User Profile- Show and Hide User Prifile Button
    UIButton *titleButton;
    UIImageView *downArrowImageView;
    UIView *titleView;
    UIImageView *titleImageView;
    NSMutableArray *locationdataArr ;
    LocationModel *selectedLocation;
    DBManager *dbManager,*dItemdbManager;
    UserInfo *userInfo;
    NSString *callingNotavl;
    NSString *Alert;
    
    //Postman Class Object
    Postman *postMan;
    BadgeNoManager *badge;
    NSString *syncdatamessage;
    NSString *yesString;
    NSString *noString;
    NSString *appNotInstallString;
    NSString *canNotOpen;
    UIAlertView *openAppAlert;
    CGPoint movingPoint;
    
    //Dashboard Collection View Cell -NSMutable Collection Array Object
    NSMutableArray *collectionArr;
    BOOL isEditableMode;
    UILongPressGestureRecognizer *longpressForJingling, *longpressGestureForMoving;

    UIBarButtonItem *backButton;
    UIButton *back;
    UILabel *newLabel;

}

@property (weak, nonatomic) IBOutlet UIButton *navtitleBtnoutlet;
//Above Dashboard-Profile View Height Constraint Property
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileViewHeightConstraint;
//Above Dashboard-Profile View Top Constraint Property
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileViewTopConstraint;

//Above Dashboard-Profile View Property
@property (weak, nonatomic) IBOutlet UIView *profileViewOutlet;

@property (weak, nonatomic) IBOutlet UILabel *dashBoardOrder;
@property (weak, nonatomic) IBOutlet UILabel *dashBoardMessage;
@property (weak, nonatomic) IBOutlet UILabel *dashBoardCallHelpDesk;
@property (weak, nonatomic) IBOutlet UILabel *dashBoardTips;
@property (weak, nonatomic) IBOutlet UILabel *dashBoardSetting;
@property (weak, nonatomic) IBOutlet UILabel *dashBoardTicket;
@property (weak, nonatomic) IBOutlet UILabel *dashBoardPersonName;
@property (weak, nonatomic) IBOutlet UILabel *dashMyTicketsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dashMyOrdersLabel;
@property (weak, nonatomic) IBOutlet UILabel *dashWebClipLabel;

//Above Dashboard-Profile View-Perosn Address Label Property
@property (weak, nonatomic) IBOutlet UILabel *dashBoardPersonAddress;
//Above Dashboard-Profile View-Email Label Property
@property (weak, nonatomic) IBOutlet UILabel *emailID;
//Above Dashboard-Profile View-User Name Label Property
@property (weak, nonatomic) IBOutlet UILabel *nameOfUserLabel;
//Above Dashboard-Profile View-Person Code Label Property
@property (weak, nonatomic) IBOutlet UILabel *dashBoardPersonCode;


//Dashboard-Aplpha View Property
@property (weak, nonatomic) IBOutlet UIView *alphaViewOutlet;
//Dashbaord-Container View Property
@property (weak, nonatomic) IBOutlet UIView *containerViewOutlet;
//Dashboard-Table View Property
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
//Dashboard-Container View-Service Desk Label Property
@property (weak, nonatomic) IBOutlet UILabel *serviceDesksLbl;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popOverHeightConst;
@property (weak, nonatomic) IBOutlet UIImageView *raiseTicketImageOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *myticketsImageOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *raiseOrderImageOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *tipsImageOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *myOrderImageOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImageOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *settingImageOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *badgeIcon;
@property (weak, nonatomic) IBOutlet UILabel *badgeLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upgradeLblVertConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upgradeLblConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tilesContainerConstranttop;

//Dashboard-Collection View Property
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;


@end

@implementation DashBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
  

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    BOOL isFirstTime = [defaults boolForKey:@"FirstInstallation"];
    if (isFirstTime) {
        [self DashBoardItemLocal];
        [defaults setBool:NO forKey:@"FirstInstallation"];
    } else {
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    [self localize];
    self.navtitleBtnoutlet.selected = NO;
    self.profileViewTopConstraint.constant = -107;
    self.tilesContainerConstranttop.constant = self.view.frame.size.height/8;
    if (![AFNetworkReachabilityManager sharedManager].reachable)
    {
        UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:STRING_FOR_LANGUAGE(@"Language.Alert") message:STRING_FOR_LANGUAGE(@"Sync.Data") delegate:nil cancelButtonTitle:OK_FOR_ALERT otherButtonTitles: nil];
        [noNetworkAlert show];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateBadgeCount) name:@"NewsBadgeCount" object:nil];
    
    //Above Dashboard- User Profile- Show/Hide User Profile NavigationBar Custom Button
    titleButton = [[UIButton alloc] init];
    //Above Dashboard- User Profile- Show/Hide User Profile NavigationBar Custom Button image
    [titleButton setImage:[UIImage imageNamed:@"DashBoardNavBarPersonImage"] forState:(UIControlStateNormal)];
    //Above Dashboard- User Profile- Show/Hide User Profile NavigationBar Custom Button Action
    [titleButton addTarget:self action:@selector(navTitleBtnPressed:) forControlEvents:(UIControlEventTouchUpInside)];
     //Above Dashboard- User Profile- Show/Hide User Profile NavigationBar Title Color
    [titleButton setTitleColor:([UIColor whiteColor]) forState:(UIControlStateNormal)];
    titleButton.titleLabel.textColor = [UIColor whiteColor];
     //Above Dashboard- User Profile- Show/Hide User Profile NavigationBar Title Name
    [titleButton setTitle:@"Test" forState:(UIControlStateNormal)];
    //Above Dashboard- User Profile- Show/Hide User Profile NavigationBar Title Name Font
    titleButton.titleLabel.font = [self customFont:20 ofName:MuseoSans_700];
    //Above Dashboard- User Profile- Show/Hide User Profile NavigationBar Custom Button Frame
    titleButton.frame = CGRectMake(0, 5, 0, 0);
    [titleButton sizeToFit];
    
//    CGFloat widthOfView = titleButton.frame.size.width + titleImageView.frame.origin.x +30;
    CGFloat widthOfView = titleButton.frame.size.width ;
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthOfView, 40)];
    [titleView addSubview:titleButton];
//    [titleView addSubview:titleImageView];
    downArrowImageView = [[UIImageView alloc] initWithImage:([UIImage imageNamed:@"DashBoardDropDownBarImage"])];
    downArrowImageView.frame = CGRectMake(0, 0, 36, 3);
    downArrowImageView.center = CGPointMake(titleView.center.x, titleView.center.y + 18);
    [titleView addSubview:downArrowImageView];
    downArrowImageView.hidden = NO;
    self.navigationItem.titleView = titleView;
    
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        self.dashBoardMessage.font=[self customFont:14 ofName:MuseoSans_300];
        self.dashBoardCallHelpDesk.font=[self customFont:14 ofName:MuseoSans_300];
        self.dashBoardOrder.font=[self customFont:14 ofName:MuseoSans_300];
        self.dashBoardSetting.font=[self customFont:14 ofName:MuseoSans_300];
        self.dashBoardTicket.font=[self customFont:14 ofName:MuseoSans_300];
        self.dashBoardTips.font=[self customFont:14 ofName:MuseoSans_300];
        self.dashMyTicketsLabel.font=[self customFont:14 ofName:MuseoSans_300];
        self.dashMyOrdersLabel.font=[self customFont:14 ofName:MuseoSans_300];
        self.dashWebClipLabel.font=[self customFont:14 ofName:MuseoSans_300];
        
        self.dashBoardPersonName.font=[self customFont:16 ofName:MuseoSans_300];
        self.dashBoardPersonAddress.font=[self customFont:16 ofName:MuseoSans_300];
        self.dashBoardPersonCode.font=[self customFont:14 ofName:MuseoSans_300];
    }
    else
    {
        self.dashBoardMessage.font=[self customFont:20 ofName:MuseoSans_300];
        self.dashBoardCallHelpDesk.font=[self customFont:20 ofName:MuseoSans_300];
        self.dashBoardOrder.font=[self customFont:20 ofName:MuseoSans_300];
        self.dashBoardSetting.font=[self customFont:20 ofName:MuseoSans_300];
        self.dashBoardTicket.font=[self customFont:20 ofName:MuseoSans_300];
        self.dashBoardTips.font=[self customFont:20 ofName:MuseoSans_300];
        self.dashMyTicketsLabel.font=[self customFont:20 ofName:MuseoSans_300];
        self.dashMyOrdersLabel.font=[self customFont:20 ofName:MuseoSans_300];
        self.dashWebClipLabel.font=[self customFont:20 ofName:MuseoSans_300];
        
        self.nameOfUserLabel.font=[self customFont:20 ofName:MuseoSans_300];
        self.dashBoardPersonAddress.font=[self customFont:20 ofName:MuseoSans_300];
        self.dashBoardPersonCode.font=[self customFont:18 ofName:MuseoSans_300];
    }
    
    if ([UIScreen mainScreen].bounds.size.height < 667)
    {
        self.upgradeLblVertConst.constant = 25;
    }
    self.serviceDesksLbl.font = [self customFont:18 ofName:MuseoSans_700];
    userInfo = [UserInfo sharedUserInfo];
    selectedLocation = [[LocationModel alloc] init];
    [self setupLocation];
    self.badgeIcon.image = [[UIImage imageNamed:@"BadgeIcon"] resizableImageWithCapInsets:(UIEdgeInsetsMake(0, 10, 0, 10))];
}

-(void)localize
{
        syncdatamessage =  INTERNET_IS_REQUIRED_TO_SYNC_DATA;
        self.dashBoardMessage.text = [MCLocalization stringForKey:@"News"];
        self.dashBoardOrder.text = [MCLocalization stringForKey:@"Book.Room"];
        self.dashMyOrdersLabel.text = [MCLocalization stringForKey:@"Password.Expiry"];
    //    self.dashBoardSetting.text = [MCLocalization stringForKey:@"Upgrade.Device"];
        self.dashBoardTicket.text = [MCLocalization stringForKey:@"Yammer"];
        self.dashBoardTips.text = [MCLocalization stringForKey:@"Upgrade.Device"];
        self.dashMyTicketsLabel.text = [MCLocalization stringForKey:@"Skype"];
    
//    self.dashBoardTicket.text = [MCLocalization stringForKey:@"IT.SOS"];
//    self.dashBoardTips.text = [MCLocalization stringForKey:@"Tips"];
//    self.dashMyTicketsLabel.text = [MCLocalization stringForKey:@"My.tickets"];
    
        self.dashWebClipLabel.text = [MCLocalization stringForKey:@"Apps"];
        self.dashBoardCallHelpDesk.text = [MCLocalization stringForKey:@"Call.Desk"];
       callingNotavl = STRING_FOR_LANGUAGE(@"Calling.Facility");
       Alert = STRING_FOR_LANGUAGE(@"Language.Alert");
    
    yesString =STRING_FOR_LANGUAGE(@"Yes") ;
    noString = STRING_FOR_LANGUAGE(@"No") ;
    appNotInstallString = STRING_FOR_LANGUAGE(@"App.Not.Install") ;
    canNotOpen = STRING_FOR_LANGUAGE(@"Can.open.not") ;
    

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideAndDisablerightNavigationItem];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.profileViewTopConstraint.constant = -107;
    self.tilesContainerConstranttop.constant = self.view.frame.size.height/8;

    navBtnIsOn = NO;
    [self cancelPopUp:self];
   
    [self.collectionView removeGestureRecognizer:longpressGestureForMoving];
    [self.collectionView removeGestureRecognizer:longpressForJingling];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isEditableMode = NO;
    [self dashBoardItem];
     [self hideAndDisablerightNavigationItem];
    longpressForJingling = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPress:)];
    longpressForJingling.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:longpressForJingling];

    self.navigationController.navigationBarHidden = NO;
    self.profileViewOutlet.backgroundColor = [self subViewsColours];
    [self updateProfileView];
    postMan = [[Postman alloc] init];
    postMan.delegate = self;
    
    if ([AFNetworkReachabilityManager sharedManager].reachable)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"office"])
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *parameter =  @"{\"request\":{\"Name\":\"\"}}";
            [postMan post:SEARCH_OFFICE_API withParameters:parameter];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"country"])
        {
            [self tryToGetITServicePhoneNum];
        }
    }
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:BACKGROUND_THEME_VALUE])
    {
        case 0:
            self.containerViewOutlet.backgroundColor = [UIColor colorWithRed:.7 green:.92 blue:.96 alpha:1];
            break;
        case 1:
            self.containerViewOutlet.backgroundColor = [UIColor colorWithRed:.86 green:.91 blue:.79 alpha:1];
            break;
        case 2:
            self.containerViewOutlet.backgroundColor = [UIColor colorWithRed:.97 green:.84 blue:.76 alpha:1];
            break;
        case 3:
            self.containerViewOutlet.backgroundColor = [UIColor colorWithRed:.93 green:.71 blue:.79 alpha:1];
            break;
            
        default:
            break;
    }
    [self upDateBadgeCount];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) hideAndDisablerightNavigationItem
{
  
}

-(void) showAndEnablerightNavigationItem
{
  
}
- (IBAction)closeButtonAction:(id)sender {

    [self.collectionView removeGestureRecognizer:longpressGestureForMoving];
    isEditableMode = NO;
    [self.collectionView reloadData];
    [self.collectionView addGestureRecognizer:longpressForJingling];
    [self hideAndDisablerightNavigationItem];

}

-(void)upDateBadgeCount
{
    if (badge == nil)
    {
        badge = [[BadgeNoManager alloc] init];
    }
    
    NSInteger badgeNum = [badge totalNoBadges];
    if (badgeNum == 0)
    {
        self.badgeLable.hidden = YES;
        self.badgeIcon.hidden = YES;
    }else
    {
        self.badgeLable.hidden = NO;
        self.badgeIcon.hidden = NO;
        self.badgeLable.text = [NSString stringWithFormat:@"%li",(long)badgeNum];
    }
}

- (void)setupLocation
{
    if ([userInfo getServerConfig] != nil)
    {
        NSString *selectedLocationCode = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_LOCATION_CODE];
        
        if (![selectedLocationCode isEqualToString:userInfo.location])
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_OFFICE_NAME];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELECTED_OFFICE_MAILID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:userInfo.location forKey:SELECTED_LOCATION_CODE];
        
        [self getDataForCountryCode:userInfo.location];
        
        [[NSUserDefaults standardUserDefaults] setObject:selectedLocation.countryName forKey:SELECTED_LOCATION_NAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"IND" forKey:SELECTED_LOCATION_CODE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self getDataForCountryCode:@"IND"];
        
        [[NSUserDefaults standardUserDefaults] setObject:selectedLocation.countryName forKey:SELECTED_LOCATION_NAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)updateProfileView
{
    if ([userInfo getServerConfig] != nil)
    {
        NSString *cropID = userInfo.cropID;
        NSString *firstName = userInfo.firstName;
        NSString *lastName = userInfo.lastName;
        NSString *location = userInfo.location;
        NSString *emailIDValue = userInfo.emailIDValue;
        
        NSString *nameOfPerson;
        
        self.dashBoardPersonCode.text = cropID;
        
        if (firstName)
        {
            [titleButton setTitle:firstName forState:(UIControlStateNormal)];
            [titleButton sizeToFit];
            
//            CGFloat widthOfView = titleButton.frame.size.width + titleImageView.frame.origin.x +30;
//            CGFloat widthOfView = titleButton.frame.size.width;
//
//            titleView.frame = CGRectMake(0, 0, widthOfView, 40);
//            downArrowImageView.center = CGPointMake(titleView.center.x , titleView.center.y + 18);
        }
        
        if (firstName || lastName)
        {
            if (firstName)
            {
                nameOfPerson = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@",lastName]];
                
            }else if (lastName)
            {
                nameOfPerson = lastName;
            }
            
            self.nameOfUserLabel.text = nameOfPerson;
        }
        
        [self getDataForCountryCode:location];
        
        self.dashBoardPersonAddress.text = selectedLocation.countryName?:location;
        self.emailID.text = emailIDValue;
        
//        if (selectedLocation.countryName)
//        {
//            [self setupLocation];
//        }
    }
}

- (void)tryToGetITServicePhoneNum
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"Countries"];
    NSString *parameter =  @"{\"request\":{\"Name\":\"\"}}";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postMan post:URLString withParameters:parameter];
}

- (void)postman:(Postman *)postman gotSuccess:(NSData *)response forURL:(NSString *)urlString
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    if ([urlString isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,@"Countries"]])
    {
        [self parseResponseData:response];
        [self saveLocationdata:response forUrl:urlString];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"country"];
        
        //    if ([[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_LOCATION_NAME]  == nil)
        //    {
        [self setupLocation];
        //    }
        [self updateProfileView];
        
    }else if ([urlString isEqualToString:SEARCH_OFFICE_API])
    {
        [self saveOfficeAddress:response forUrl:SEARCH_OFFICE_API];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"office"];

    }

}

- (void)postman:(Postman *)postman gotFailure:(NSError *)error forURL:(NSString *)urlString
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)parseResponseData:(NSData *)response
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
    NSArray *arr = json[@"aaData"][@"GenericSearchViewModels"];
    locationdataArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary *aDict in arr)
    {
        if ([aDict[@"Status"]boolValue])
        {
            LocationModel *locationdata = [[LocationModel alloc] init];
            locationdata.code = aDict[@"Code"];
            locationdata.countryCode = aDict[@"CountryCode"];
            locationdata.countryName = aDict[@"Name"];
            NSString *JSONString = aDict[@"ServiceDeskNumber"];
            
            locationdata.serviceDeskNumber = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:kNilOptions
                                                                               error:nil];
            [locationdataArr addObject:locationdata];
        }
    }
    
    [self.tableViewOutlet reloadData];
    [self adjustHeightOfPopOverView];
}

- (void)saveLocationdata:(NSData *)response forUrl:(NSString *)APILink
{
    if (dbManager == nil)
    {
        dbManager = [[DBManager alloc] initWithFileName:@"APIBackup.db"];
        dbManager.delegate=self;
    }
    
    NSString *createQuery = @"create table if not exists location (countryCode text PRIMARY KEY, serviceDeskNumber text,countryName text, code text)";
    [dbManager createTableForQuery:createQuery];
    
    NSMutableString *stringFromData = [[NSMutableString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSRange rangeofString;
    rangeofString.location = 0;
    rangeofString.length = stringFromData.length;
    [stringFromData replaceOccurrencesOfString:@"'" withString:@"''" options:(NSCaseInsensitiveSearch) range:rangeofString];
    for (LocationModel *alocation in locationdataArr)
    {
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:alocation.serviceDeskNumber
                                                           options:kNilOptions
                                                             error:nil];
        NSString *serviceDeskNoJSON = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO  location (countryCode,serviceDeskNumber,countryName,code) values ('%@', '%@','%@', '%@')", alocation.countryCode, serviceDeskNoJSON, alocation.countryName, alocation.code];
        
        //                NSString *insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO  location (countryCode,serviceDeskNumber,countryName,code) values ('%@', '%@','%@', '%@')", alocation.countryCode, alocation.serviceDeskNumber, alocation.countryName, alocation.code];
        
        [dbManager saveDataToDBForQuery:insertSQL];
    }
}

- (void)saveOfficeAddress:(NSData *)response  forUrl:(NSString *)APILink
{
    if (dbManager == nil)
    {
        dbManager = [[DBManager alloc] initWithFileName:@"APIBackup.db"];
        dbManager.delegate = self;
    }
    
    NSString *createQuery = @"create table if not exists officeLocations (API text PRIMARY KEY, data text)";
    [dbManager createTableForQuery:createQuery];
    
    NSMutableString *stringFromData = [[NSMutableString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSRange rangeofString;
    rangeofString.location = 0;
    rangeofString.length = stringFromData.length;
    [stringFromData replaceOccurrencesOfString:@"'" withString:@"''" options:(NSCaseInsensitiveSearch) range:rangeofString];
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO  officeLocations (API,data) values ('%@', '%@')", APILink,stringFromData];
    
    [dbManager saveDataToDBForQuery:insertSQL];
}

- (BOOL)getDataForCountryCode:(NSString *)countryCode
{
    countryCode = [countryCode uppercaseString];
    
    if (dbManager == nil)
    {
        dbManager = [[DBManager alloc] initWithFileName:@"APIBackup.db"];
        dbManager.delegate=self;
    }
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM location WHERE countryCode = '%@'", countryCode];
    
    //    NSString *queryString = @"SELECT * FROM location WHERE countryCode = '%@'";
    
    if (![dbManager getDataForQuery:queryString])
    {
        if (![AFNetworkReachabilityManager sharedManager].reachable)
        {
            UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:WARNING_TEXT message:INTERNET_IS_REQUIRED_TO_SYNC_DATA delegate:nil cancelButtonTitle:OK_FOR_ALERT otherButtonTitles: nil];
            [noNetworkAlert show];
            
            return NO;
        }else
        {
            return NO;
        }
    }
    return YES;
}

- (void)DBManager:(DBManager *)manager gotSqliteStatment:(sqlite3_stmt *)statment
{
    if ([manager isEqual:dItemdbManager]) {
        collectionArr =[[NSMutableArray alloc]init];
        while (sqlite3_step(statment) == SQLITE_ROW)
        {
            DashBoardModel *dModel = [[DashBoardModel alloc] init];
            dModel.title = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 0)];
            dModel.imageName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 2)];
             dModel.seguaName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 3)];
             dModel.imageCode = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 4)];
            dModel.code = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 5)];
            dModel.colourCode = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 6)];
            [collectionArr addObject:dModel];
        }
        [self.collectionView reloadData];
}
    locationdataArr = [[NSMutableArray alloc] init];
    if (sqlite3_step(statment) == SQLITE_ROW)
    {
        selectedLocation.countryCode = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 0)];
        
        NSString *JSONString = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 1)];
        selectedLocation.serviceDeskNumber = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:kNilOptions
                                                                               error:nil];
        //        selectedLocation.serviceDeskNumber = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 1)];
        
        selectedLocation.countryName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 2)];
        selectedLocation.code = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 3)];
        
        [locationdataArr addObject:selectedLocation];
    }
    
    [self.tableViewOutlet reloadData];
    [self adjustHeightOfPopOverView];
    
}

- (void)navTitleBtnPressed:(id)sender
{
    NSInteger constrainValue;
    NSInteger constrainValueTiles;
    if (!navBtnIsOn)
    {
        constrainValue = 1;
        constrainValueTiles = self.view.frame.size.height/5;
        navBtnIsOn = YES;
    }else
    {
         constrainValue = -107;
        constrainValueTiles = self.view.frame.size.height/8;

        navBtnIsOn = NO;
    }
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.profileViewTopConstraint.constant = constrainValue;
                         self.tilesContainerConstranttop.constant = constrainValueTiles;
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}


- (IBAction)messageButtonPressed:(UIButton *)sender
{


}


// yammer Button
- (IBAction)raiseATicketPressed:(UIButton *)sender
{
    NSLog(@"yammer press");
    [self redirectingYammerApp];
    
    //    [self.tabBarController setSelectedIndex:1];
}


// one Drive button
- (IBAction)tipsButtonPressed:(UIButton *)sender
{

//   NSLog(@"one drive press");
//    [self redirectingoneDriveApp];


}



// skype Button
- (IBAction)myTicketsBtnPressed:(id)sender
{
    //  [self.tabBarController setSelectedIndex:1];
    
    [self redirectingSkype];
 NSLog(@"skype press");

}

- (IBAction)myOrderBtnPresed:(id)sender
{
    
}
- (IBAction)upgradeBtnPressed:(id)sender
{


}

- (IBAction)initiateCallForITHelpDesk:(UIButton *)sender
{
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        NSString *countryCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLocationCode"];
        
        if (![self getDataForCountryCode:countryCode])
        {
            if ([AFNetworkReachabilityManager sharedManager].reachable)
            {
                [self tryToGetITServicePhoneNum];
            }
            
            return;
        }
        
        NSLog(@"country %@",selectedLocation.serviceDeskNumber);
        
        if (selectedLocation.serviceDeskNumber.count > 1 )
        {
            self.alphaViewOutlet.hidden = NO;
            self.containerViewOutlet.hidden = NO;
            
            [UIView animateWithDuration:.3 animations:^{
                self.alphaViewOutlet.alpha= .5;
                self.containerViewOutlet.alpha = 1;
            } completion:^(BOOL finished)
             {
                 
             }];
        }else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self phoneNumValidation]]];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert message:callingNotavl delegate:self cancelButtonTitle:OK_FOR_ALERT otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark UITableViewDataSource methods
//Dashboard- Container View- Table View Delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//Dashboard- Container View- Table View Delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [selectedLocation.serviceDeskNumber count];
}
//Dashboard- Container View- Table View Delegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
//Dashboard- Container View- Table View Delegate method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UILabel *name = (UILabel*)[cell viewWithTag:100];
    name.font = [self customFont:14 ofName:MuseoSans_300];
    
    //phoneNum.text = self.serviceDeskDeteils;
    
    NSDictionary *dict = selectedLocation.serviceDeskNumber[indexPath.row];
    
    name.text = dict[@"Name"];
    
    return cell;
}

#pragma mark UITableViewDelegate methods
//Dashboard- Container View- Table View Delegate method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [UIView animateWithDuration:.3 animations:^{
        self.alphaViewOutlet.alpha= 0;
        self.containerViewOutlet.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.alphaViewOutlet.hidden = YES;
        self.containerViewOutlet.hidden = YES;
    }];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self phoneNumValidation]]];
    
    NSLog(@"%@", [self phoneNumValidation]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString*)phoneNumValidation
{
    NSIndexPath *indexpath = [self.tableViewOutlet indexPathForSelectedRow];
    
    NSDictionary *dict = selectedLocation.serviceDeskNumber[indexpath.row];
    
    NSString *phoneNoFromDict = dict[@"Number"];
    NSMutableString *phoneNoToCall = [NSMutableString
                                      stringWithCapacity:phoneNoFromDict.length];
    NSScanner *scanner = [NSScanner scannerWithString:phoneNoFromDict];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"+0123456789"];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer])
        {
            [phoneNoToCall appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    //    NSLog(@"%@", phoneNoToCall); // "123123123"
    phoneNoToCall = [[@"tel://" stringByAppendingString:phoneNoToCall] mutableCopy];
    return phoneNoToCall;
}

- (void)adjustHeightOfPopOverView
{
    if ([selectedLocation.serviceDeskNumber count] > 1)
    {
        CGFloat heightOfTableView = [self.tableViewOutlet contentSize].height;
        heightOfTableView = MIN(300, heightOfTableView);
        
        CGFloat heightOfPopOverView = 30 + heightOfTableView + 30;
        
        self.popOverHeightConst.constant = heightOfPopOverView;
        [self.view layoutIfNeeded];
    }
}

- (IBAction)cancelPopUp:(UIControl *)sender
{
    [UIView animateWithDuration:.3 animations:^{
        self.alphaViewOutlet.alpha= 0;
        self.containerViewOutlet.alpha = 0;
    } completion:^(BOOL finished) {
        self.alphaViewOutlet.hidden = YES;
        self.containerViewOutlet.hidden = YES;
    }];
}

//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//-(BOOL)shouldAutorotate {
//    return NO;
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"dashToOrder_segue"])
    {
        RaiseATicketViewController *raiseTicket = segue.destinationViewController;
        raiseTicket.orderDiffer = FLOW_FOR_ORDER;
        
    }if ([segue.identifier isEqualToString:@"DashToMyOrdersSegue"])
    {
        TicketsListViewController *orderList = segue.destinationViewController;
        orderList.orderItemDifferForList = @"orderList";
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)redirectingYammerApp
{
   
    BOOL didOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"yammer://"]];
    
    if (!didOpen)
    {
                    openAppAlert = [[UIAlertView alloc] initWithTitle:canNotOpen message:appNotInstallString delegate:self cancelButtonTitle:noString otherButtonTitles:yesString, nil];
        
        [openAppAlert show];
    }
   
    

}
-(void)redirectingSkype
{
    
    BOOL didOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"Lync://"]];
    
    if (!didOpen)
    {
    openAppAlert = [[UIAlertView alloc] initWithTitle:canNotOpen message:appNotInstallString delegate:self cancelButtonTitle:noString otherButtonTitles:yesString, nil];
        [openAppAlert show];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([openAppAlert isEqual:alertView])
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserInfo sharedUserInfo].appStoreURL]];
            
        }
    }
}


// Dynamic dashBoard
#pragma mark UICollectionViewDataSource methods


-(void)LongPress:(UILongPressGestureRecognizer *)panRecognizer
{
/*Zingling
    [self showAndEnablerightNavigationItem];
    isEditableMode = YES;
    [self.collectionView reloadData];
    [_collectionView removeGestureRecognizer:panRecognizer];
    longpressGestureForMoving = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressforMoving:)];
    longpressGestureForMoving.minimumPressDuration = 0.2;
    [self.collectionView addGestureRecognizer:longpressGestureForMoving];
  */


    
    movingPoint = [panRecognizer locationInView:self.collectionView];
    switch(panRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:movingPoint];
            if(selectedIndexPath == nil)
                break;
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:movingPoint];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
            break;
        }
        default:
        {
            [self.collectionView cancelInteractiveMovement];
            break;
        }
    }

   

}


-(void)LongPressforMoving:(UILongPressGestureRecognizer *)longPressRecognizer
{
    movingPoint = [longPressRecognizer locationInView:self.collectionView];
    switch(longPressRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:movingPoint];
            if(selectedIndexPath == nil)
                break;
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:movingPoint];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
            break;
        }
        default:
        {
            [self.collectionView cancelInteractiveMovement];
            break;
        }
    }
}

#pragma Dashboard Collection View delegate methods

//Dashboard Collection View delegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return collectionArr.count;
}

//Dashboard Collection View delegate methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    DashBoardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    DashBoardModel *dModel =collectionArr[indexPath.item];
    UILabel *titlelabel = (UILabel *)[cell viewWithTag:102];
    UILabel *barglabel = (UILabel *)[cell viewWithTag:500];
    UIImageView *titleimage = (UIImageView *)[cell viewWithTag:101];
    UIImageView *bargimage = (UIImageView *)[cell viewWithTag:400];
    UIView *backgroundView = (UIView *)[cell viewWithTag:555];
    NSLog(@"%lu",(unsigned long)dModel.imageName.length);
    backgroundView.backgroundColor = [UIColor colorWithHexString:dModel.colourCode];
    
    if ([dModel.code isEqualToString:@"DNEWS"]||[dModel.code isEqualToString:@"DBOOKAROOM"]||[dModel.code isEqualToString:@"DPASSEXP"]||[dModel.code isEqualToString:@"DCALLSERVICE"]||[dModel.code isEqualToString:@"DUPGRADEDEVICE"])
    {
         titleimage.image =[UIImage imageNamed:dModel.imageName];
   // titlelabel.text = dModel.title;
       titlelabel.text =   STRING_FOR_LANGUAGE(dModel.title);
    }
    else
    {
     titleimage.image = [self getimageForDocCode:dModel.imageCode];
     titlelabel.text = dModel.title;
    }
    if (isEditableMode)
    {
        cell.deletButton.hidden = NO;
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [anim setToValue:[NSNumber numberWithFloat:0.0f]];
        [anim setFromValue:[NSNumber numberWithDouble:M_PI/64]];
        [anim setDuration:0.1];
        [anim setRepeatCount:NSUIntegerMax];
        [anim setAutoreverses:YES];
        cell.layer.shouldRasterize = YES;
        [cell.layer addAnimation:anim forKey:@"SpringboardShake"];
        cell.deletButton.tag = indexPath.item;
        [cell.deletButton addTarget:self action:@selector(deleteTiles:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.deletButton.hidden = YES;
        cell.layer.shouldRasterize = NO;

    }
    
    if ([dModel.code isEqualToString:@"DNEWS"])
    {
        if (badge == nil)
        {
            badge = [[BadgeNoManager alloc] init];
        }
        
        NSInteger badgeNum = [badge totalNoBadges];
        if (badgeNum == 0)
        {
           barglabel.hidden = YES;
           bargimage.hidden = YES;
        }
        else
        {
            barglabel.hidden = NO;
            bargimage.hidden = NO;
            barglabel.text = [NSString stringWithFormat:@"%li",(long)badgeNum];
        }
    }
     else
     {
        bargimage.hidden = YES;
        barglabel.hidden = YES;
    }
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        titlelabel.font=[self customFont:14 ofName:MuseoSans_300];
    }
    else
    {
        
        titlelabel.font=[self customFont:22 ofName:MuseoSans_300];
    }
    return cell;
}

//Dashboard Collection View delegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.view.frame.size.width-30)/3 ;
    CGFloat height = width+20 ;
   if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
{
    return CGSizeMake(width, height);
}
   else
{
        
        return CGSizeMake(176, 215);
    }
}

//Dashboard Collection View delegate methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIGestureRecognizer *gesture in self.collectionView.gestureRecognizers)
    {
        if ([gesture isEqual:longpressGestureForMoving])
        {
            return;
        }
    }
    DashBoardModel *amodel = collectionArr[indexPath.item];
    [self collectionViewCellSelectionMethod:amodel];
}

//Dashboard Collection View delegate methods
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    NSMutableArray *object = [collectionArr objectAtIndex:sourceIndexPath.item];
    [collectionArr removeObjectAtIndex:sourceIndexPath.item];
    [collectionArr insertObject:object atIndex:destinationIndexPath.item];
    [self deletDashboardItem];
    [self saveDashboardItem];
}

- (UIImage *)getimageForDocCode:(NSString *)docCode
{
    NSString *pathToDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [pathToDoc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.png", docCode]];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    if (imageData)
    {
        UIImage *tempImage = [UIImage imageWithData:imageData];
        imageData = nil;
        UIImage *webClipImage = [UIImage imageWithCGImage:tempImage.CGImage scale:2 orientation:tempImage.imageOrientation] ;
        tempImage = nil;
        return webClipImage;
    }
    
    return nil;
}

-(void)deleteTiles:(UIButton *)button
{
    NSLog(@"button tag : %d",(int)button.tag);
  
    [self showAlertForConformationRemovingTiles:CONFORMATION_REMOVE_ICON andIndexNumber:(int)button.tag];

}

-(void)showAlertForConformationRemovingTiles:(NSString *)messageString andIndexNumber:(int)indexNumber
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:ALERT_FOR_ALERT
                                  message:messageString
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:OK_FOR_ALERT
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self removingItemFromDashBoardConformation:indexNumber];
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:ALERT_FOR_CANCLE
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)removingItemFromDashBoardConformation:(int)indexNumber
{
    [collectionArr removeObjectAtIndex:indexNumber];
    [self.collectionView reloadData];
}


-(void)insertDatainDashBoardTable
{
    if (dItemdbManager == nil)
    {
        dItemdbManager = [[DBManager alloc] initWithFileName:@"APIBackup.db"];
        dItemdbManager.delegate=self;
    }
    NSString *createQuery = @"create table if not exists DashboardItem (Title text, Url text, ImageName text,seguaName text,imageCode text,code text,colourCode text)";
    [dItemdbManager createTableForQuery:createQuery];
    
    for (int i = 0;i<collectionArr.count;i++)
    {
        DashBoardModel *amodel = collectionArr[i];
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO  DashboardItem (Title,Url,ImageName,seguaName,imageCode,code,colourCode) values ('%@', '%@', '%@' , '%@' , '%@' ,'%@' ,'%@')", amodel.title,amodel.urlLink,amodel.imageName,amodel.seguaName,amodel.imageCode,amodel.code,amodel.colourCode];
        [dItemdbManager saveDataToDBForQuery:insertSQL];
    }
}

-(void)dashBoardItem
{
    if (dItemdbManager == nil)
    {
        dItemdbManager = [[DBManager alloc] initWithFileName:@"APIBackup.db"];
        dItemdbManager.delegate=self;
    }
    NSString *queryString = @"SELECT * FROM DashboardItem";
    [dItemdbManager getDataForQuery:queryString];
}
-(void)deletDashboardItem
{
    NSString *query = @"delete from DashboardItem";
    [dItemdbManager deleteRowForQuery:query];
}
-(void)saveDashboardItem
{
    [self insertDatainDashBoardTable];
}

//Dashboard Collection View Cell Selection Method
-(void)collectionViewCellSelectionMethod:(DashBoardModel *)dModel
{
    if ([dModel.seguaName isEqualToString:@"homeTonewsSegua"])
    {
        [self performSegueWithIdentifier:@"homeTonewsSegua" sender:self];
    }
    else if ([dModel.seguaName isEqualToString:@"homeToPasswordExp"])
    {
        [self performSegueWithIdentifier:@"homeToPasswordExp" sender:self];
    }
    else if ([dModel.seguaName isEqualToString:@"callServiceDesk"])
    {
        
    }
    else if ([dModel.seguaName isEqualToString:@"hometoOkToUpdate"])
    {
        [self performSegueWithIdentifier:@"hometoOkToUpdate" sender:self];
    }
    else if ([dModel.seguaName isEqualToString:@"hometoBookaRoom"])
    {
        [self performSegueWithIdentifier:@"hometoBookaRoom" sender:self];
    }
    else if ([dModel.code isEqualToString:@"DCALLSERVICE"])
    {
        [self callingFunctionforCallServiceDesk];
    }
    else
    {
    
        [self methodForOpeningURLApps:dModel];
    }
}
-(void)callingFunctionforCallServiceDesk
{
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        NSString *countryCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLocationCode"];
        
        if (![self getDataForCountryCode:countryCode])
        {
            if ([AFNetworkReachabilityManager sharedManager].reachable)
            {
                [self tryToGetITServicePhoneNum];
            }
            
            return;
        }
        NSLog(@"country %@",selectedLocation.serviceDeskNumber);
        if (selectedLocation.serviceDeskNumber.count > 1 )
        {
            self.alphaViewOutlet.hidden = NO;
            self.containerViewOutlet.hidden = NO;
            
            [UIView animateWithDuration:.3 animations:^{
                self.alphaViewOutlet.alpha= .5;
                self.containerViewOutlet.alpha = 1;
            } completion:^(BOOL finished)
             {
                 
             }];
        }else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self phoneNumValidation]]];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert message:callingNotavl delegate:self cancelButtonTitle:OK_FOR_ALERT otherButtonTitles:nil];
        [alert show];
    }
}
-(void)methodForOpeningURLApps:(DashBoardModel *)dModel
{
    BOOL didOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dModel.urlLink]];
    if (!didOpen)
    {
        if (openAppAlert == nil)
        {
            openAppAlert = [[UIAlertView alloc] initWithTitle:STRING_FOR_LANGUAGE(@"Can.open.not") message:STRING_FOR_LANGUAGE(@"App.Not.Install") delegate:self cancelButtonTitle:STRING_FOR_LANGUAGE(@"No") otherButtonTitles:STRING_FOR_LANGUAGE(@"Yes"), nil];
        }
        [openAppAlert show];
    }
}


-(NSString *)tilesColoreCode:(NSIndexPath *)indexpath
{
    NSInteger indexNumber = indexpath.row;
    NSString *colorCode =@"#FFFFFF";
    switch (indexNumber) {
        case 0:
             colorCode = @"#F79A14";
            break;
        case 1:
            colorCode = @"#1394DB";
            break;
        case 2:
           colorCode = @"#EB0E27";
            break;
        case 3:
            colorCode = @"#1D93F6";
            break;
        case 4:
            colorCode = @"#B28036";
            break;
        case 5:
            colorCode = @"#5E5A5A";
            break;
        case 6:
            colorCode = @"#48AF41";
            break;
        case 7:
            colorCode = @"#5684E6";
            break;
        case 8:
            colorCode = @"#705185";
            break;
            
        default:
            break;
    }
    return colorCode;
}

//Dashboard Collection View Model Data Locally
-(void)DashBoardItemLocal
{
    collectionArr =[[NSMutableArray alloc]init];
    DashBoardModel *dModel = [[DashBoardModel alloc]init];
    dModel.title = @"News";
    dModel.seguaName = @"homeTonewsSegua";
    dModel.imageName = @"MessageIcon";
    dModel.code = @"DNEWS";
    dModel.colourCode = @"#F79A14";
    [collectionArr addObject:dModel];
    
    dModel = [[DashBoardModel alloc]init];
    dModel.title = @"Book.Room";
    dModel.imageName = @"BookARoomDashIcon";
    dModel.seguaName = @"hometoBookaRoom";
    dModel.code = @"DBOOKAROOM";
    dModel.colourCode = @"#1D93F6";
    [collectionArr addObject:dModel];
    
    dModel = [[DashBoardModel alloc]init];
    dModel.title = @"Password.Expiry";
    dModel.seguaName = @"homeToPasswordExp";
    dModel.imageName = @"PasswordToolDashIcon";
    dModel.code = @"DPASSEXP";
     dModel.colourCode = @"#B28036";
    [collectionArr addObject:dModel];
    
    dModel = [[DashBoardModel alloc]init];
    dModel.title = @"Call.Desk";
    dModel.imageName = @"PhoneIcon";
    dModel.code = @"DCALLSERVICE";
    dModel.colourCode = @"#48AF41";
    [collectionArr addObject:dModel];
    
    dModel = [[DashBoardModel alloc]init];
    dModel.title = @"Upgrade.Device";
    dModel.seguaName = @"hometoOkToUpdate";
    dModel.imageName = @"SettingsDashIcon";
    dModel.code = @"DUPGRADEDEVICE";
    dModel.colourCode = @"#5E5A5A";
    [collectionArr addObject:dModel];
    
    [self insertDatainDashBoardTable];
}







@end

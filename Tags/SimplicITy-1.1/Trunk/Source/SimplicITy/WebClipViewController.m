//
//  WebClipViewController.m
//  SimplicITy
//
//  Created by Varghese Simon on 12/4/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "WebClipViewController.h"
#import "webClipModel.h"
#import "DBManager.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface WebClipViewController () <UICollectionViewDataSource, UICollectionViewDelegate,postmanDelegate,DBManagerDelegate>
{
    NSArray *tableViewData, *arrayOfImages;
    
    UIBarButtonItem *backButton;
    Postman *postMan;
    NSMutableArray *webClipArr;
    
    NSString *databasePath;
    sqlite3 *database;
    
    DBManager *dbManager;
    NSString *URLString;


}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewOutlet;

@end

@implementation WebClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tableViewData = @[@"Reset Lync Password",@"Reset SAP Password"];
    arrayOfImages = @[@"LyncWebClipIcon", @"SAPWebClipIcon"];
    
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
    
    URLString = WEB_CLIPS_BASE_API;
    
    postMan = [[Postman alloc] init];
    postMan.delegate = self;
    
    if ([AFNetworkReachabilityManager sharedManager].isReachable)
    {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"webclip"])
        {
            [self tryUpdatewebClip];

        }else
        {
            [self  getData];
        }
    
    }
    else
    {
        [self  getData];
    }
}

-(void)tryUpdatewebClip
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [postMan get:URLString];

}

- (void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark 
#pragma mark postmanDelegate

-(void)postman:(Postman *)postman gotSuccess:(NSData *)response forURL:(NSString *)urlString
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    if ([urlString isEqualToString:WEB_CLIPS_BASE_API])
    {
        [self parseResponsedata:response andgetImages:YES];
        
        [self saveWebClipsData:response forURL:urlString];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"webclip"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }else
    {
        [self createImages:response forUrl:urlString];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"document"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)postman:(Postman *)postman gotFailure:(NSError *)error forURL:(NSString *)urlString
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}

- (void)parseResponsedata:(NSData *)response andgetImages:(BOOL)download
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
    NSArray *arr = json[@"aaData"][@"WebClips"];
    
    webClipArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary *aDict in arr)
    {
        
        if ([aDict[@"Status"] boolValue])
        {
            webClipModel *webClip = [[webClipModel alloc]init];
            webClip.title = aDict[@"Title"];
            webClip.urlLink = aDict[@"HREF"];
            
            webClip.imageCode = aDict[@"DocumentCode"];
            webClip.image = nil;
            
            [webClipArr addObject:webClip];
            
            if (download || [[NSUserDefaults standardUserDefaults] boolForKey:@"document"])
            {
             
             
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                    NSString *imageUrl = [NSString stringWithFormat:WEB_CLIPS_DOC_API,webClip.imageCode];
                    [postMan get:imageUrl];

              
            }
        }
        
        }
    [self.collectionViewOutlet reloadData];

}

- (void)createImages:(NSData *)response forUrl:(NSString *)url
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
    
    if (![json[@"aaData"][@"Success"] boolValue])
    {
        return;
    }
    NSString *imageAsBlob = json[@"aaData"][@"Base64Model"][@"Image"];
//    NSLog(@"%@",imageAsBlob);
    NSString *pathToDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSData *imageDataForFromBase64 = [[NSData alloc] initWithBase64EncodedString:imageAsBlob options:kNilOptions];
    UIImage *image = [UIImage imageWithData:imageDataForFromBase64];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *pathToImage;
    
//    NSMutableString *webClipFileName = [[NSMutableString alloc] init];
//    webClipFileName = @""
    NSRange rangeOfFileName;
    rangeOfFileName.length = url.length;
    rangeOfFileName.location = 0;
    
    NSMutableString *stringToRemove = [WEB_CLIPS_DOC_API mutableCopy];
    NSRange rangeOfBaseURL;
    rangeOfBaseURL.length = stringToRemove.length;
    rangeOfBaseURL.location = 0;
    [stringToRemove replaceOccurrencesOfString:@"%@" withString:@"" options:NSCaseInsensitiveSearch range:rangeOfBaseURL];
    
    NSLog(@"Base URL = %@", stringToRemove);
    NSMutableString *mutableURL = [url mutableCopy];
    [mutableURL replaceOccurrencesOfString:stringToRemove
                                withString:@""
                                   options:NSCaseInsensitiveSearch
                                     range:rangeOfFileName];
    
    pathToImage = [NSString stringWithFormat:@"%@/%@@2x.png", pathToDoc, mutableURL];
    NSLog(@"%@", pathToImage);
    [imageData writeToFile:pathToImage atomically:YES];
    
    [self.collectionViewOutlet reloadData];
}

- (void)saveWebClipsData:(NSData *)response forURL:(NSString *)APILink
{
    if (dbManager == nil)
    {
        dbManager = [[DBManager alloc] initWithFileName:@"APIBackup.db"];
        dbManager.delegate=self;
    }
    
    NSString *createQuery = @"create table if not exists webClips (API text PRIMARY KEY, data text)";
    [dbManager createTableForQuery:createQuery];
    
    NSMutableString *stringFromData = [[NSMutableString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSRange rangeofString;
    rangeofString.location = 0;
    rangeofString.length = stringFromData.length;
    [stringFromData replaceOccurrencesOfString:@"'" withString:@"''" options:(NSCaseInsensitiveSearch) range:rangeofString];
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO  webClips (API,data) values ('%@', '%@')", APILink,stringFromData];
    
    [dbManager saveDataToDBForQuery:insertSQL];
    
}

- (void)getData
{
    if (dbManager == nil)
    {
        dbManager = [[DBManager alloc] initWithFileName:@"APIBackup.db"];
        dbManager.delegate=self;
    }
    
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM webClips WHERE API = '%@'", URLString];
    if (![dbManager getDataForQuery:queryString])
    {
        if (![AFNetworkReachabilityManager sharedManager].reachable)
        {
            UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:@"Warning !" message:@"The device is not connected to internet. Please connect the device to sync data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [noNetworkAlert show];
        }
        
        [self tryUpdatewebClip];
    }
}


-(void)DBManager:(DBManager *)manager gotSqliteStatment:(sqlite3_stmt *)statment
{
    if (sqlite3_step(statment) == SQLITE_ROW)
    {
        NSString *string = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 1)];
        
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        [self parseResponsedata:data andgetImages:NO];
    }
}

#pragma mark UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [webClipArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *titlelable = (UILabel *)[cell viewWithTag:100];
    
    webClipModel *webClip = webClipArr[indexPath.row];

    titlelable.text = webClip.title;
    
    titlelable.font=[self customFont:14 ofName:MuseoSans_700];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:101];
    imageView.image = [self getimageForDocCode:webClip.imageCode];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    webClipModel *webClip = webClipArr[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webClip.urlLink]];
}

- (UIImage *)getimageForDocCode:(NSString *)docCode
{
    NSString *pathToDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [pathToDoc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.png", docCode]];
    
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    if (imageData)
    {
        UIImage *tempImage = [UIImage imageWithData:imageData];
        UIImage *webClipImage = [UIImage imageWithCGImage:tempImage.CGImage scale:2 orientation:tempImage.imageOrientation] ;
        
        return webClipImage;
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

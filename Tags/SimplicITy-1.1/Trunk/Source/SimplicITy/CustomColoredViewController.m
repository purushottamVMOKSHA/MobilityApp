//
//  CustomColoredViewController.m
//  SimplicITy
//
//  Created by Varghese Simon on 12/11/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "CustomColoredViewController.h"

@interface CustomColoredViewController ()





@end

@implementation CustomColoredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"BackgroundTheme"])
    {
        case 0:
            self.view.backgroundColor = [UIColor colorWithRed:.7 green:.92 blue:.96 alpha:1];
            break;
        case 1:
            self.view.backgroundColor = [UIColor colorWithRed:.97 green:.84 blue:.76 alpha:1];
            break;
        case 2:
            self.view.backgroundColor = [UIColor colorWithRed:.93 green:.71 blue:.79 alpha:1];
            break;
        case 3:
            self.view.backgroundColor = [UIColor colorWithRed:.86 green:.91 blue:.79 alpha:1];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIDeviceOrientationDidChangeNotification
                                                 object:nil];
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            //load the portrait view
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            //load the landscape view
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}

- (NSString *)stingForColorTheme
{
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"BackgroundTheme"]) {
        case 0:
            return @"Blue Ocean";
            break;
        case 1:
            return @"Orange Hue";
            break;
        case 2:
            return @"Pink Rose";
            break;
        case 3:
            return @"Green Glow";
            break;
        default:
            break;
    }
    return nil;
}

- (UIColor *)barColorForIndex:(NSInteger)index
{
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"BackgroundTheme"]) {
        case 0:
            return [UIColor colorWithRed:.13 green:.31 blue:.46 alpha:1];
            break;
        case 1:
            return [UIColor colorWithRed:.9 green:.45 blue:.23 alpha:1];
            break;
        case 2:
            return [UIColor colorWithRed:.76 green:.06 blue:.29 alpha:1];
            break;
        case 3:
            return [UIColor colorWithRed:.55 green:.7 blue:.31 alpha:1];
            break;
        default:
            break;
    }
    return nil;
}

-(UIColor *)subViewsColours
{
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"BackgroundTheme"])
    {
        case 0:
            return [UIColor colorWithRed:.60 green:.78 blue:.84 alpha:1];
            break;
        case 1:
            return [UIColor colorWithRed:.92 green:.69 blue:.53 alpha:1];
            break;
        case 2:
            return [UIColor colorWithRed:.84 green:.49 blue:.58 alpha:1];
            break;
        case 3:
            return [UIColor colorWithRed:.74 green:.82 blue:.57 alpha:1];
            break;
        default:
            break;
    }
    
    return nil;
}

-(UIColor *)seperatorColours
{
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"BackgroundTheme"]) {
        case 0:
            return [UIColor colorWithRed:.13 green:.31 blue:.46 alpha:1];
            break;
        case 1:
            return [UIColor colorWithRed:.9 green:.45 blue:.23 alpha:1];
            break;
        case 2:
            return [UIColor colorWithRed:.76 green:.06 blue:.29 alpha:1];
            break;
        case 3:
            return [UIColor colorWithRed:.55 green:.7 blue:.31 alpha:1];
            break;
        default:
            break;
    }
    return nil;
    
}

- (UIFont *)customFont:(NSInteger)size ofName:(CustomFontNames)fontName
{
    UIFont *customFont;
    switch (fontName)
    {
        case MuseoSans_100:
            customFont = [UIFont fontWithName:@"MuseoSans-100" size:size];
            break;
        case MuseoSans_300:
            customFont = [UIFont fontWithName:@"MuseoSans-300" size:size];
            break;
        case MuseoSans_700:
            customFont = [UIFont fontWithName:@"MuseoSans-700" size:size];
            break;
        default:
            break;
    }
    return customFont;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

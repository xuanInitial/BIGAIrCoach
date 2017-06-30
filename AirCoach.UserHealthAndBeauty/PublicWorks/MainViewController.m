//
//  MainViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController



- (BOOL)shouldAutorotate
{
    LRLog(@"让不让我旋转?");
    return NO;
}

//不让手机横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
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

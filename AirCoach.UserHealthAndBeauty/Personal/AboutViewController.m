//
//  AboutViewController.m
//  AirCoach.acUser
//
//  Created by xuan on 15/11/24.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "AboutViewController.h"


typedef id  new;
 new object ();

@interface AboutViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AboutViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏_底图.png"] forBarMetrics:UIBarMetricsDefault];
    
    [TalkingData trackPageBegin:@"设置页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [TalkingData trackPageEnd:@"设置页面"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.titleLabel.text = @"关于";
    self.titleLabel.textColor = ZhuYao;
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    
  self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0f];
    
    
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

//
//  ChooseDetailsViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/30.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "ChooseDetailsViewController.h"

@interface ChooseDetailsViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ChooseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    // Do any additional setup after loading the view.
    self.title = @"选购详情";
    
    [self createUI];
}



- (void)createUI{
    
    UIImageView  *image = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH-200)/2, 100, 200, 200)];
    image.image = [UIImage imageNamed:@"组-50@2x"];
    
    [self.view addSubview:image];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-200)/2, 300, 200, 30)];
    headLabel.text = @"光合康复师线下服务";
    headLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:headLabel];
    
    UILabel *wenziLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-300)/2, 350, 300, 200)];
    wenziLabel.text = @"光合教练专业产后护理为你健康保驾护航我的世界你不懂我们就是苦逼的程序员你来打我啊";
    wenziLabel.numberOfLines = 0;
    wenziLabel .textAlignment = UITextAlignmentCenter;
    [self.view addSubview:wenziLabel];
    
    
    UIButton *iPhoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    iPhoneButton.frame = CGRectMake((SCREENWIDTH-260)/2, SCREENHEIGHT - 80, 260, 50);
    [iPhoneButton setTitle:@"咨询客服" forState:UIControlStateNormal];
    [iPhoneButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iPhoneButton];
    
    
}

- (void)btnClick:(UIButton *)sender{
    LRLog(@"点击了咨询按钮");

    
    
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    NSArray *toRecipients = @[@"aircoach-beta@atreehole.com"];
    // 注意：如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为@","
    [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];

    NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

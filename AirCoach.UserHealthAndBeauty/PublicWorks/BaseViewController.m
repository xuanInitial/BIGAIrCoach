//
//  BaseViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigation];
    self.hidesBottomBarWhenPushed = YES;
}


-(void)setNavigation{
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titleLabel;
    
    UIImage *NormImage = [[UIImage imageNamed:@"Y返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:NormImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    
    
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)addSubviewWithState:(NSString*)state{
    
}
-(void)setTitle:(NSString *)title{
    
    _titleLabel.text=title;
}
-(void)setTitleColor:(UIColor*)color{
    _titleLabel.textColor=color;
}
-(void)setLeftBtnColor:(UIColor *)color{
    
    self.navigationController.navigationBar.tintColor=color;
}
-(void)leftItemClick:(UIBarButtonItem *)sender{
    
  
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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

//
//  IntegralButton.h
//  9.17 new
//
//  Created by xuan on 15/9/17.
//  Copyright (c) 2015年 AVPlayer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IntegralScaleSetting : NSObject
@property(nonatomic,strong)NSString     *strCommon;//按钮可用时的文本
@property(nonatomic,strong)NSString     *strPrefix;//倒计时前缀
@property(nonatomic,strong)NSString     *strSuffix;//倒计时后缀
@property(nonatomic,assign)int          indexStart;//开始从几倒计时
@property(nonatomic,strong)UIColor      *colorDisable;//倒计时的背景颜色
@property(nonatomic,strong)UIColor      *colorCommon;//按钮可用时的背景颜色
@property(nonatomic,strong)UIColor      *colorTitle;//文本颜色

@end

@interface IntegralButton : UIButton

- (void)startWithSetting:(IntegralButton*)setting;
@end

/*
 
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 IntegralButton* btn = [[IntegralButton alloc] initWithFrame:CGRectMake(100, 200, 100, 44)];
 btn.layer.cornerRadius = 5;
 btn.layer.masksToBounds = YES;
 
 [self.view addSubview:btn];
 
 [self btnAction:btn];
 
 [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
 }
 
 - (void)btnAction:(id)sender {
 NSLog(@"click");
 IntegralButton* btn = (IntegralButton*)sender;
 IntegralScaleSetting* setting = [[IntegralScaleSetting alloc] init];
 setting.strPrefix = @"";
 setting.strSuffix = @"秒";
 setting.strCommon = nil;
 setting.indexStart = 10;
 [btn startWithSetting:setting];
 }
 
 
 
 */


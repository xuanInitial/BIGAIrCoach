//
//  BaseViewController.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "MainViewController.h"

@interface BaseViewController : MainViewController
@property(nonatomic,strong)UILabel *titleLabel;

-(void)setTitleColor:(UIColor*)color;
-(void)setLeftBtnColor:(UIColor*)color;

-(void)addSubviewWithState:(NSString*)state;

-(void)leftItemClick:(UIBarButtonItem *)sender;
@end

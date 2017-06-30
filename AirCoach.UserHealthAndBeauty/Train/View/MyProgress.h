//
//  MyProgress.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/1.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProgress : UIView
//底部进度条
@property(nonatomic,strong)UIView *backView;
//顶部进度条
@property(nonatomic,strong)UIView *fontView;
+(instancetype)ViewWihthColor:(UIColor*)backColor trackColor:(UIColor*)frontColor trackHeight:(CGFloat)height viewFrame:(CGRect)frame cornerRadius:(CGFloat)radius;

@end

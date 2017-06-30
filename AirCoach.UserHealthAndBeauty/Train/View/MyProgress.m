//
//  MyProgress.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/1.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "MyProgress.h"

@interface MyProgress()

@end

@implementation MyProgress

+(instancetype)ViewWihthColor:(UIColor *)backColor trackColor:(UIColor *)frontColor trackHeight:(CGFloat)height viewFrame:(CGRect)frame cornerRadius:(CGFloat)radius
{
    MyProgress *progressView = [[MyProgress alloc]initWithFrame:frame];
    progressView.backView.backgroundColor = backColor;
    progressView.fontView.backgroundColor = frontColor;
    progressView.backView.frame = CGRectMake(0, 0, progressView.frame.size.width, height);
    progressView.fontView.frame = CGRectMake(0, 0, progressView.frame.size.width, height);
    progressView.backView.layer.cornerRadius = radius;
    progressView.backView.layer.masksToBounds = YES;
    progressView.fontView.layer.cornerRadius = radius;
    progressView.fontView.layer.masksToBounds = YES;
    return progressView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
       
        [self setprogressView];
    }
    return self;
}
-(void)setprogressView
{
    _backView = [UIView new];
    _fontView = [UIView new];
    [self addSubview:_backView];
    [self addSubview:_fontView];
}


@end

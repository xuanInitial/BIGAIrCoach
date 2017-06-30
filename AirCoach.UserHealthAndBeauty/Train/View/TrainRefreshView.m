//
//  TrainRefreshView.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/1.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "TrainRefreshView.h"
#import "Header.h"
#import "UIView+XMGExtension.h"
@interface TrainRefreshView()

@property(nonatomic,strong)UILabel *welcomeLab;//欢迎词
@property(nonatomic,strong)UILabel *CocoachLab;//塑形师忙着呢
@property(nonatomic,strong)UILabel *PlanLab;//给你忙着呢

@property(nonatomic,strong)UIView *whiteView;//中间白条

@property(nonatomic,strong)UIButton *refeshBtn;//刷新按钮

@property(nonatomic,strong)UIButton *knowBtn;//了解app按钮

@end


@implementation TrainRefreshView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}
-(void)setup
{
    _welcomeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, 29)];
    _welcomeLab.text = @"欢迎加入光合塑形";
    _welcomeLab.textAlignment = 1;
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:29];
    _welcomeLab.textColor = [UIColor whiteColor];
    _welcomeLab.font = font;
    [self addSubview:_welcomeLab];
    
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH - 30) / 2, 47, 30, 2)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteView];
    
    _CocoachLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _whiteView.y + 20,SCREENWIDTH, 15)];
    _CocoachLab.text = @"塑形师正在根据得到的身体数据";
    _CocoachLab.textAlignment = 1;
    _CocoachLab.font = [UIFont systemFontOfSize:15];
    _CocoachLab.textColor = [UIColor whiteColor];
    [self addSubview:_CocoachLab];
    
    _PlanLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _CocoachLab.y + 25,SCREENWIDTH, 15)];
    _PlanLab.text = @"为您定制训练方案，请稍等";
    _PlanLab.textAlignment = 1;
    _PlanLab.font = [UIFont systemFontOfSize:15];
    _PlanLab.textColor = [UIColor whiteColor];
    [self addSubview:_PlanLab];
    
    _refeshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refeshBtn.frame = CGRectMake((SCREENWIDTH - 235) / 2, self.height * 0.6, 235, 44);
    _refeshBtn.backgroundColor = [UIColor whiteColor];
    [_refeshBtn setTitleColor:ZhuYao forState:UIControlStateNormal];
    _refeshBtn.font = [UIFont systemFontOfSize:16];
    _refeshBtn.layer.cornerRadius = 4;
    _refeshBtn.layer.masksToBounds = YES;
    [_refeshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [_refeshBtn addTarget:self action:@selector(btnRefresh) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_refeshBtn];
    
    _knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _knowBtn.frame = CGRectMake((SCREENWIDTH - 235) / 2, _refeshBtn.y + 44 + 22, 235, 44);
    _knowBtn.backgroundColor = [UIColor whiteColor];
    [_knowBtn setTitleColor:ZhuYao forState:UIControlStateNormal];
    _knowBtn.font = [UIFont systemFontOfSize:16];
    _knowBtn.layer.cornerRadius = 4;
    _knowBtn.layer.masksToBounds = YES;
    [_knowBtn setTitle:@"使用提示" forState:UIControlStateNormal];
    [_knowBtn addTarget:self action:@selector(btnKnow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_knowBtn];
    
    
}
-(void)btnKnow
{
    if (_trainDelegate &&[_trainDelegate respondsToSelector:@selector(refreshTrain)])
    {
        [self.trainDelegate jumpNoticPage];
    }
}
-(void)btnRefresh
{
    if (_trainDelegate &&[_trainDelegate respondsToSelector:@selector(refreshTrain)])
    {
       [self.trainDelegate refreshTrain];
    }
}
-(void)hideTrainRefreshView
{
    self.hidden = YES;
}
-(void)disPlayTrainRefreshView
{
    self.hidden = NO;
}
-(void)setTrainDelegate:(id<trainrefreshDelegate>)trainDelegate
{
    _trainDelegate = trainDelegate;
}
@end

//
//  HardScrollView.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/10/10.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "HardScrollView.h"




@implementation HardScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (SCREENHEIGHT > SCREENWIDTH)
    {
        _MyW = SCREENWIDTH;
        _MyH = SCREENHEIGHT;
    }else
    {
        _MyW = SCREENHEIGHT;
        _MyH = SCREENWIDTH;
    }
    if (self)
    {
        self.contentSize = CGSizeMake(2 * (_MyW - 30), 0);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        [self updateAllSonLables];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(diableBtn) name:@"diableBTn" object:nil];
    return self;
}
-(void)diableBtn
{
    _firstbtn.enabled = NO;
    _Sencondtbtn.enabled = NO;
    _Thirdbtn.enabled = NO;
}
-(void)updateAllSonLables
{
    
    _firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _MyW - 30, 198)];
    _SecondView = [[UIView alloc]initWithFrame:CGRectMake(_MyW - 30, 0, _MyW - 30, 198)];
    
    _NextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _NextBtn.frame = CGRectMake(0,(_firstView.height) / 2 - 65 , _MyW - 30, 100);
    
    [_NextBtn setTitle:@"训练有问题？告诉您的护理师 >" forState:UIControlStateNormal];
    _NextBtn.font = [UIFont systemFontOfSize:15];
    [_NextBtn setTitleColor:LableColor forState:UIControlStateNormal];
    [_NextBtn addTarget:self action:@selector(nextView) forControlEvents:UIControlEventTouchUpInside];
    
    [_firstView addSubview:_NextBtn];
    
    for (int i = 0; i < 4; i++)
    {
       UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        secondBtn.frame = CGRectMake(45, i * 44 + 15 * i, _MyW - 120, 44);
       // secondBtn.centerX = _SecondView.centerX;
        secondBtn.font = [UIFont systemFontOfSize:14];
        switch (i) {
            case 0:
            {
                [secondBtn setTitle:@"您在训练中遇到了什么问题？" forState:UIControlStateNormal];
                [secondBtn setTitleColor:LableColor forState:UIControlStateNormal];
                secondBtn.height = 14;
                secondBtn.userInteractionEnabled = NO;
                break;
            }
            case 1:
            {
                _firstbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _firstbtn.frame = CGRectMake(45, i * 14 + 14 * i, _MyW - 120, 44);
                [_firstbtn setTitle:@"好难，训练强度有点大" forState:UIControlStateNormal];
                _firstbtn.font = [UIFont systemFontOfSize:14];
                [_firstbtn setBackgroundImage:[UIImage imageNamed:@"问答按钮"] forState:UIControlStateNormal];
                [_firstbtn setBackgroundImage:[UIImage imageNamed:@"不可点击说话"] forState:UIControlStateDisabled];
                _firstbtn.tag = 1;
                break;
            }
            case 2:
            {
                _Sencondtbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _Sencondtbtn.frame = CGRectMake(45, 44 + 28 + 14, _MyW - 120, 44);
                [_Sencondtbtn setTitle:@"没感觉，训练强度不够" forState:UIControlStateNormal];
                 [_Sencondtbtn setBackgroundImage:[UIImage imageNamed:@"问答按钮"] forState:UIControlStateNormal];
                [_Sencondtbtn setBackgroundImage:[UIImage imageNamed:@"不可点击说话"] forState:UIControlStateDisabled];
                _Sencondtbtn.tag = 2;
                _Sencondtbtn.font = [UIFont systemFontOfSize:14];
                break;
            }
            case 3:
            {
                _Thirdbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _Thirdbtn.frame = CGRectMake(45, 44 * 2  + 28  + 14 * 2, _MyW - 120, 44);
                [_Thirdbtn setTitle:@"其他" forState:UIControlStateNormal];
                 [_Thirdbtn setBackgroundImage:[UIImage imageNamed:@"问答按钮"] forState:UIControlStateNormal];
                [_Thirdbtn setBackgroundImage:[UIImage imageNamed:@"不可点击说话"] forState:UIControlStateDisabled];
                _Thirdbtn.font = [UIFont systemFontOfSize:14];
                _Thirdbtn.tag = 3;
                break;
            }

                
            default:
                break;
        }
        
        
        
        [_firstbtn addTarget:self action:@selector(touchMytag:) forControlEvents:UIControlEventTouchUpInside];
        [_Sencondtbtn addTarget:self action:@selector(touchMytag:) forControlEvents:UIControlEventTouchUpInside];
        [_Thirdbtn addTarget:self action:@selector(touchMytag:) forControlEvents:UIControlEventTouchUpInside];
        [_SecondView addSubview:secondBtn];
        [_SecondView addSubview:_firstbtn];
        [_SecondView addSubview:_Sencondtbtn];
        [_SecondView addSubview:_Thirdbtn];
    }
    
    [self addSubview:_firstView];
    [self addSubview:_SecondView];
    
    
    
}
-(void)setAcfeel:(id<Acfeeldelegate>)Acfeel
{
    _Acfeel = Acfeel;
}
-(void)touchMytag:(UIButton*)sender
{
    NSInteger i = sender.tag;
    if (_Acfeel && [_Acfeel respondsToSelector:@selector(touchFeelbutton:)])
    {
        [_Acfeel touchFeelbutton:i];
    }
}
-(void)nextView
{
   [UIView animateWithDuration:0.3 animations:^{
       self.contentOffset = CGPointMake(_MyW - 30, 0);
   }];

}
@end

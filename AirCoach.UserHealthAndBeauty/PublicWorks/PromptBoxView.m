//
//  提示框view PromptBoxView.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/7/15.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "PromptBoxView.h"

@implementation PromptBoxView


-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title{
    
    
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        //_changdu = [UIScreen mainScreen].bounds.size.width - 140;
        
        _changdu = 280;
        [self createUIWithTitle:title andFloat: _changdu];
    }
    return self;
}


-(void)createUIWithTitle:(NSString *)title  andFloat:(CGFloat)changdu{
    
    
    self.zheZhaoView = [[UIView alloc] init];
    self.zheZhaoView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    self.zheZhaoView.backgroundColor = [UIColor clearColor];
    self.zheZhaoView.userInteractionEnabled = YES;
    [self addSubview:self.zheZhaoView];
    
    self.promptView = [[UIView alloc]init];
    
    self.promptView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

    self.promptView.layer.masksToBounds = YES;
    self.promptView.layer.cornerRadius = 6;
    [self.zheZhaoView addSubview:self.promptView];
    
        
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithRed:86/255.0f green:86/255.0f blue:86/255.0f alpha:1.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = title;
    [self.titleLabel setTextColor:[UIColor whiteColor]];
   // CGFloat titleHeight = [self getHeightWithTitle:title andFont:15];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.frame = CGRectMake(0, 0, changdu, 54);
    
    self.titleLabel.numberOfLines = 0;
    [self.promptView addSubview:self.titleLabel];
    
     self.promptView.frame = CGRectMake((SCREENWIDTH - 280) / 2, (SCREENHEIGHT-54)/2,
                                         changdu,54);
   // self.promptView.center = self.center;
    [self shakeToShow:self.promptView];
    
    
     [self performSelector:@selector(dismissView) withObject:self afterDelay:1];
    
    
}

//动态计算高度
-(CGFloat)getHeightWithTitle:(NSString *)title andFont:(NSInteger)fontsize
{
    CGFloat height = [title boundingRectWithSize:CGSizeMake(_changdu, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size.height;
    return height;
}

//显示提示框的动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}


- (void)dismissView{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.promptView.alpha = 0;
    } completion:^(BOOL finished) {
        
       [self removeFromSuperview];
        self.promptView = nil;
    }];
    
}

@end

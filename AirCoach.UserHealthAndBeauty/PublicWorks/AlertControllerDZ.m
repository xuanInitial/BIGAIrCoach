//
//  AlertControllerDZ.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/22.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "AlertControllerDZ.h"
#import "AppDelegate.h"

@implementation AlertControllerDZ



-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andDetail:(NSString *)detail  andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle andFloat:(CGFloat)changdu BtnNum:(NSString*)Num location:(NSTextAlignment)mylocation
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        _changdu = 290;
        //_changdu = [UIScreen mainScreen].bounds.size.width - changdu;
        [self createUIWithTitle:title andDetail:detail  andCancelTitle:cancelTitel andOtherTitle:otherTitle andFloat: _changdu BtnNum:(NSString*)Num location:(NSTextAlignment)mylocation];
    }
    return self;
}

-(void)createUIWithTitle:(NSString *)title andDetail:(NSString *)detail  andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle andFloat:(CGFloat)changdu BtnNum:(NSString*)Num location:(NSTextAlignment)mylocation
{
    
    
    self.zheZhaoView = [[UIView alloc] init];
    self.zheZhaoView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    self.zheZhaoView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7] ;
    self.zheZhaoView.userInteractionEnabled = YES;
    [self addSubview:self.zheZhaoView];
    
    
    self.backGroundView = [[UIView alloc]init];
    self.backGroundView.center = self.center;
  
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.alpha = 1.0;
    self.backGroundView.layer.masksToBounds = YES;
    self.backGroundView.layer.cornerRadius = 5;
    [self.zheZhaoView addSubview:self.backGroundView];
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithRed:86/255.0f green:86/255.0f blue:86/255.0f alpha:1.0];
    self.titleLabel.textAlignment = mylocation;
    self.titleLabel.text = title;
    CGFloat titleHeight = [self getHeightWithTitle:title andFont:20];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.titleLabel.frame = CGRectMake(20, 28, changdu-20*2, titleHeight);
    self.titleLabel.numberOfLines = 0;
    [self.backGroundView addSubview:self.titleLabel];
    
    
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.textColor = [UIColor colorWithRed:48/255.0f green:48/255.0f blue:48/255.0f alpha:1.0];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = detail;
    CGFloat detailHeight = [self getHeightWithTitle:detail andFont:16];
    self.detailLabel.font = [UIFont systemFontOfSize:15];
    
    if (self.titleLabel.text == nil)
    {
        self.detailLabel.frame = CGRectMake(23 , 26, changdu - 23 * 2, detailHeight);
      //  NSLog(@"label的宽度为%lf",self.detailLabel.width);
    }
    else {
        self.detailLabel.frame = CGRectMake(19,16+self.titleLabel.frame.origin.y + titleHeight, changdu-19*2, detailHeight);
        
    }

    
    self.detailLabel.tag = 306;
    self.detailLabel.userInteractionEnabled = YES;
   
    
    if (self.detailLabel.text != nil) {
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detail];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:7];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detail length])];
        self.detailLabel.attributedText = attributedString;
        
        [self.detailLabel sizeToFit];
    }
   
     [self.backGroundView addSubview:self.detailLabel];
    
    
    
    
    if (self.detailLabel.text == nil) {
        self.horLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.titleLabel.frame.origin.y + titleHeight + 28 , changdu, 1)];
    }else {
        self.horLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.detailLabel.frame.origin.y + detailHeight + 26 , changdu, 1)];
    }
    self.horLabel.backgroundColor = [UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0];
    [self.backGroundView addSubview:self.horLabel];
    
    
    self.verLabel = [[UILabel alloc]init];
    
     if (self.detailLabel.text == nil) {
         self.verLabel.frame = CGRectMake(changdu/2, self.titleLabel.frame.origin.y + titleHeight + 28, 1, 58);
     }else {
         self.verLabel.frame = CGRectMake(changdu/2, self.detailLabel.frame.origin.y + detailHeight + 27, 1, 58);
     }
    
    self.verLabel.backgroundColor = [UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0];
    
    
    if ([Num isEqualToString:@"Two"])
    {
        self.canleButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.canleButton.frame = CGRectMake(0, self.horLabel.frame.origin.y + 1, changdu/2, 50);
        [self.canleButton setTitle:cancelTitel forState:UIControlStateNormal];
        self.canleButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.canleButton setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
        
        self.canleButton.tag = 308;
        [self.canleButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview: self.canleButton];
        
        [self.backGroundView addSubview:self.verLabel];
    }
    
    self.otherButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    if ([Num isEqualToString:@"Two"])
    {
      self.otherButton.frame = CGRectMake(changdu/2, self.horLabel.frame.origin.y + 1, changdu/2, 50);
    }
    else
    {
       self.otherButton.frame = CGRectMake(0, self.horLabel.frame.origin.y + 1, changdu, 50);
    }
    [self.otherButton setTitle:otherTitle forState:UIControlStateNormal];
    self.otherButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.otherButton setTitleColor:[UIColor colorWithRed:241/255.0 green:80/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
    self.otherButton.tag = 309;
    [self.otherButton addTarget:self action:@selector(clickToUseDelegate:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:self.otherButton];
    
    
   
    if (self.titleLabel.text == nil) {
        self.backGroundView.bounds = CGRectMake(0, 0, changdu,26 + detailHeight + 26 + 50);
    }else if (self.detailLabel.text == nil){
        self.backGroundView.bounds = CGRectMake(0, 0, changdu,28 + titleHeight + 28 + 50);
    }else {
        self.backGroundView.bounds = CGRectMake(0, 0, changdu,28 + titleHeight + 16 + 7 + detailHeight + 26 + 50);
    }
    
    UITapGestureRecognizer *tapDetailLab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDoSomething:)];
    [self.detailLabel addGestureRecognizer:tapDetailLab];
    UITapGestureRecognizer *tapBodyLab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDoSomething:)];
    [self.bodyLabel addGestureRecognizer:tapBodyLab];
    
    [self shakeToShow:self.backGroundView];
    
}

//动态计算高度
-(CGFloat)getHeightWithTitle:(NSString *)title andFont:(NSInteger)fontsize
{
    CGFloat height = [title boundingRectWithSize:CGSizeMake(_changdu-38, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size.height;
    return height;
}

//显示提示框的动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

//点击(取消,确定)按钮调用方法
-(void)clickToUseDelegate:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickButtonWithTag:)])
    {
        [self.delegate clickButtonWithTag:button];
    }
    [self dismiss];
}

-(void)toDoSomething:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(clickLabelWithTag:)])
    {
        [self.delegate clickLabelWithTag:tap.self.view];
    }
    
    [self dismiss];
}

- (void)dismiss {
    
    [self removeFromSuperview];
}

@end

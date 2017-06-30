//
//  AlertControllerDZ.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/22.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XMGExtension.h"
@protocol AlertControllerDZDelegate <NSObject>

@optional

-(void)clickLabelWithTag:(UIView *)label;

-(void)clickButtonWithTag:(UIButton *)button;

@end

@interface AlertControllerDZ : UIView
@property (nonatomic,strong)UIView *backGroundView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UILabel *bodyLabel;
@property (nonatomic,strong)UIButton *canleButton;
@property (nonatomic,strong)UIButton *otherButton;
@property (nonatomic,strong)UILabel *horLabel;
@property (nonatomic,strong)UILabel *verLabel;
@property (nonatomic,strong)UIView *zheZhaoView;
@property (nonatomic)CGFloat changdu;

@property (nonatomic,assign)id<AlertControllerDZDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andDetail:(NSString *)detail  andCancelTitle:(NSString *)cancelTitel andOtherTitle:(NSString *)otherTitle andFloat:(CGFloat)changdu BtnNum:(NSString*)Num location:(NSTextAlignment)mylocation;
@end

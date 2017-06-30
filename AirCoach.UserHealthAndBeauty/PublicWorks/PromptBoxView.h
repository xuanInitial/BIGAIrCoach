//
//  提示框view PromptBoxView.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/7/15.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XMGExtension.h"
@interface PromptBoxView : UIView

@property (nonatomic, strong) UIView *promptView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *zheZhaoView;

@property (nonatomic)CGFloat changdu;
-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title;


@end

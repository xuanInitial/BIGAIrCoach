//
//  ResetView.m
//  AirCoach.acUser
//
//  Created by wei on 16/5/13.
//  Copyright © 2016年 AirCoach2.0. All rights reserved.
//

#import "ResetView.h"
#import "Masonry.h"
#import "Header.h"
//#import "MyAttributedStringBuilder.h"
#import "UIView+XMGExtension.h"

#import <SDWebImage/UIImageView+WebCache.h>
@implementation ResetView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self!=nil)
    {
        self.userInteractionEnabled = YES;
        
        _telText = [UITextField new];
        [self addSubview:_telText];
        [_telText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).equalTo(@15);
            make.right.equalTo(self.mas_right).equalTo(@(-15));
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@54);
        }];
        _telText.placeholder = @"请输入手机号";
        _telText.tag = 1003;
        _telText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _telText.font = [UIFont systemFontOfSize:15];
        //分割线
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).equalTo(@15);
            make.right.equalTo(self.mas_right).equalTo(@(-15));
            make.top.equalTo(_telText.mas_bottom);
            make.height.equalTo(@1);
        }];
        lineView.backgroundColor = specolor;
        
        _passWordText = [UITextField new];
        [self addSubview:_passWordText];
        [_passWordText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).equalTo(@15);
            make.right.equalTo(self.mas_right).equalTo(@(-120));
            make.top.equalTo(lineView.mas_top);
            make.height.equalTo(@54);
        }];
        _passWordText.placeholder = @"请输入验证码";
        _passWordText.tag = 1004;
        _passWordText.font = [UIFont systemFontOfSize:15];
        //获取验证码
        _test = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_test];
        [_test mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).equalTo(@(-15));
            make.centerY.equalTo(_passWordText.mas_centerY);
            make.height.equalTo(@33);
            make.width.equalTo(@89);
        }];
        _test.font = [UIFont systemFontOfSize:15];
        _test.enabled = NO;
        [_test setBackgroundImage:[UIImage imageNamed:@"验证码按钮-可点击-"] forState:UIControlStateNormal];
        [_test setBackgroundImage:[UIImage imageNamed:@"验证码按钮-不可点击"] forState:UIControlStateDisabled];
        _test.tag = 1005;
        
        
        
        
        
    }
    return self;
}



@end

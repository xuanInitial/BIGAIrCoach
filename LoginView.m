//
//  LoginView.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/29.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "LoginView.h"
#import "Masonry.h"
@implementation LoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self!=nil)
    {
        self.userInteractionEnabled = YES;
        
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        
        _telText = [UITextField new];
        [self addSubview:_telText];
        [_telText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).equalTo(@12);
            make.right.equalTo(self.mas_right).equalTo(@(-12));
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@54);
        }];
        _telText.placeholder = @"请输入手机号";
        _telText.tag = 1001;
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 10.0)
        {
           _telText.textContentType = UITextContentTypeTelephoneNumber;
        }
        else
        {
            _telText.keyboardType = UIKeyboardTypeNumberPad;
        }
        
       
       // _telText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _telText.font = [UIFont systemFontOfSize:15];
        
        
        
        
        
        //分割线
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).equalTo(@12);
            make.right.equalTo(self.mas_right).equalTo(@(-12));
            make.top.equalTo(_telText.mas_bottom);
            make.height.equalTo(@1);
        }];
        lineView.backgroundColor = specolor;
        

        _passWordText = [UITextField new];
        [self addSubview:_passWordText];
        [_passWordText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).equalTo(@12);
            make.right.equalTo(self.mas_right).equalTo(@(-80));
            make.top.equalTo(lineView.mas_top);
            make.height.equalTo(@54);
        }];
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 10.0)
        {
           _passWordText.textContentType = UITextContentTypeCreditCardNumber;
        }else
        {
           _passWordText.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        
        _passWordText.font = [UIFont systemFontOfSize:15];
        _passWordText.placeholder = @"请输入验证码";
        _passWordText.tag = 1002;
//        //可见图片
//        _visable = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self addSubview:_visable];
//        [_visable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).equalTo(@(-2));
//            make.centerY.equalTo(_passWordText.mas_centerY);
//            make.height.equalTo(@45);
//            make.width.equalTo(@45);
//        }];
//        _visable.selected = NO;
//        [_visable setBackgroundImage:[UIImage imageNamed:@"隐藏"] forState:UIControlStateNormal];
//        [_visable setBackgroundImage:[UIImage imageNamed:@"显示"] forState:UIControlStateSelected];
//        _visable.tag = 1000;
        
        
        //获取验证码
        _YanZhengMaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_YanZhengMaButton];
        [_YanZhengMaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).equalTo(@(-12));
            make.centerY.equalTo(_telText.mas_centerY);
            make.height.equalTo(@33);
            make.width.equalTo(@89);
        }];
        _YanZhengMaButton.font = [UIFont systemFontOfSize:15];
        _YanZhengMaButton.enabled = YES;
        [_YanZhengMaButton setBackgroundImage:[UIImage imageNamed:@"验证码按钮-可点击-"] forState:UIControlStateNormal];
        [_YanZhengMaButton setBackgroundImage:[UIImage imageNamed:@"验证码按钮-不可点击"] forState:UIControlStateDisabled];
        _YanZhengMaButton.tag = 1005;
        
        
        
        
        
    }
    return self;
}



@end

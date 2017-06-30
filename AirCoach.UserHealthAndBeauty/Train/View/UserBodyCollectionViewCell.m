//
//  UserBodyCollectionViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/27.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "UserBodyCollectionViewCell.h"

@implementation UserBodyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configCellUI
{
    
    __weak typeof(self) weakSelf = self;
   //标题
    UILabel *itemlable = [UILabel new];
    [self addSubview:itemlable];
    
    [itemlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.equalTo(@20);
        make.top.equalTo(weakSelf.mas_top);
    }];
    itemlable.text = @"身体数据";
    itemlable.textColor = [UIColor grayColor];
    itemlable.textAlignment = 1;
    
    //背景图
    UIImageView *backImage = [UIImageView new];
    [self addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.equalTo(@170);
        make.top.equalTo(itemlable.mas_bottom);
    }];
    backImage.image = [UIImage imageNamed:@"训练图1.jpg"];
    
    //已完成标签
    UILabel *Donelable = [UILabel new];
    [backImage addSubview:Donelable];
    [Donelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImage.mas_left).offset(SCREENWIDTH / 2 - 60);
        make.height.equalTo(@16);
        make.centerY.equalTo(backImage.mas_centerY);
        make.width.equalTo(@60);
    }];
    Donelable.text = @"已完成";
    Donelable.textColor = [UIColor whiteColor];
    Donelable.font = [UIFont systemFontOfSize:16];
    
    //完成次数
    _Cishu = [UILabel new];
    [backImage addSubview:_Cishu];
    [_Cishu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Donelable.mas_right).offset(10);
        make.height.equalTo(@20);
        make.centerY.equalTo(backImage.mas_centerY);
        make.width.lessThanOrEqualTo(@80);
    }];
    _Cishu.textColor = [UIColor blackColor];
    _Cishu.font = [UIFont systemFontOfSize:20];
    _Cishu.text = @"1/4";
    //文案
    UILabel *Wordlable = [UILabel new];
    [backImage addSubview:Wordlable];
    [Wordlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.equalTo(@18);
        make.top.equalTo(_Cishu.mas_bottom).offset(40);
    }];
    Wordlable.text = @"记录身体数据 获得康复师意见";
    Wordlable.textColor = [UIColor blackColor];
    Wordlable.textAlignment = 1;
    Wordlable.font = [UIFont systemFontOfSize:18];
    //下方文案
    UILabel *BottomWordlable = [UILabel new];
    [self addSubview:BottomWordlable];
    [BottomWordlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.height.equalTo(@45);
        make.top.equalTo(backImage.mas_bottom).offset(20);
        make.width.equalTo(@(weakSelf.width - 75));
    }];
    BottomWordlable.text = @"建议每周最少填写一次,以便康复师更精确的点评您的身体数据";
    BottomWordlable.textColor = [UIColor blackColor];
    BottomWordlable.textAlignment = 1;
    BottomWordlable.numberOfLines = 0;
    BottomWordlable.font = [UIFont systemFontOfSize:16];
    
    //按钮
    _WriteBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_WriteBt];
    [_WriteBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@35);
        make.top.equalTo(backImage.mas_bottom).offset(20);
    }];
    _WriteBt.backgroundColor = [UIColor orangeColor];
    [_WriteBt setTitle:@"去填写" forState:UIControlStateNormal];
    [_WriteBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _WriteBt.font = [UIFont systemFontOfSize:20];
    
}
@end

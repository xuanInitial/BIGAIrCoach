//
//  PlanDetailDayTableViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/7/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "PlanDetailDayTableViewCell.h"

@implementation PlanDetailDayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _Donday = [UILabel new];
        [self.contentView addSubview:_Donday];
        [_Donday mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-3);
            make.width.greaterThanOrEqualTo(@80);
            make.height.equalTo(@18);
        }];
        _Donday.text = @"计划完成 3/3";
        _Donday.textColor = Subcolor;
        _Donday.font = [UIFont systemFontOfSize:12];
        
        
        _PlanTime = [UILabel new];
        [self.contentView addSubview:_PlanTime];
        [_PlanTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.greaterThanOrEqualTo(@70);
            make.height.equalTo(@12);
        }];
        _PlanTime.text = @"2016-07-21";
        _PlanTime.textColor = LableColor;
        _PlanTime.font = [UIFont systemFontOfSize:12];
        
//        //底部黑线
//        _LineView = [UIView new];
//        [self.contentView addSubview:_LineView];
//        [_LineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView.mas_right).offset(-15);
//            make.left.equalTo(self.contentView.mas_left).offset(15);
//            make.bottom.equalTo(self.contentView.mas_bottom);
//            make.height.equalTo(@1);
//        }];
//        _LineView.backgroundColor = xiLine;
        
        //头部黑线
        _TopLineView = [UIView new];
        [self.contentView addSubview:_TopLineView];
        [_TopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top);
            make.height.equalTo(@1);
        }];
        _TopLineView.backgroundColor = xiLine;
        _TopLineView.tag = 1002;
        
    }
    return self;
}

-(void)setPlanProgress:(planProgress *)PlanProgress
{
    _PlanProgress = PlanProgress;
    _Donday.text = [NSString stringWithFormat:@"计划完成 %ld/%ld",(long)PlanProgress.times + 1,(long)PlanProgress.Mytotal];
    if (PlanProgress.updated_at != nil)
    {
        NSString *str = [PlanProgress.updated_at substringToIndex:10];
        _PlanTime.text = str;
    }
    MyAttributedStringBuilder *wangcheng = [[MyAttributedStringBuilder alloc] initWithString:_Donday.text];
    NSInteger leng = _Donday.text.length;
    [[wangcheng range:NSMakeRange(5,leng - 5)] setFont:[UIFont systemFontOfSize:21]];
    _Donday.attributedText = wangcheng.commit;
}




@end

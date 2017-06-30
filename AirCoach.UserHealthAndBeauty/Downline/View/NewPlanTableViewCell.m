//
//  NewPlanTableViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/15.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "NewPlanTableViewCell.h"

@implementation NewPlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];

        UILabel *NewPlan = [[UILabel alloc]initWithFrame:CGRectMake(15, 27, SCREENWIDTH, 16)];
        NewPlan.text = @"本阶段其他计划请等待教练制定";
        NewPlan.textColor = Subcolor;
        NewPlan.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        [backView addSubview:NewPlan];
        
        
        //cell中的黑线
        UIView *xiLineView = [UIView new];
        [backView addSubview:xiLineView];
        [xiLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left);
            make.right.equalTo(backView.mas_right);
            make.bottom.equalTo(backView.mas_bottom);
            make.height.equalTo(@1);
        }];
        xiLineView.backgroundColor = specolor;
        
        
        
    }
    return self;
}
@end

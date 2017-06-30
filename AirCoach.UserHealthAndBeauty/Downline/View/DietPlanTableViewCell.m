//
//  DietPlanTableViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/15.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "DietPlanTableViewCell.h"

@implementation DietPlanTableViewCell

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
        UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(27, 0, SCREENWIDTH - 42, 75)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        _dietBackground = [UIImageView new];
        [backView addSubview:_dietBackground];
        [_dietBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).offset(23);
            make.left.equalTo(backView.mas_left).offset(11);
            make.width.equalTo(@29);
            make.height.equalTo(@29);
         }];
        _dietBackground.image = [UIImage imageNamed:@"icon-饮食计划"];
        

        //时间标签
        _dietTime = [[UILabel alloc]initWithFrame:CGRectMake(51, 20, 120, 12)];
        _dietTime.font = [UIFont systemFontOfSize:12];
        _dietTime.textColor = LableColor;
        [backView addSubview:_dietTime];
        
        //计划名称
        UILabel *planName = [[UILabel alloc]initWithFrame:CGRectMake(51, _dietTime.y + _dietTime.height + 12, backView.width - 80 - 6, 14)];
        planName.text = @"护理师变更了您的饮食计划";
        
        planName.textColor = Reportcolor;
        //字体加粗
        planName.font = [UIFont systemFontOfSize:14];
        [backView addSubview:planName];
        
        //箭头
        UIImageView *jiantou = [UIImageView new];
        [backView addSubview:jiantou];
        [jiantou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).offset(30);
            make.right.equalTo(backView.mas_right).offset(-11);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
        jiantou.image = [UIImage imageNamed:@"阶段箭头"];
        
        //cell中的黑线
        UIView *xiLineView = [UIView new];
        [backView addSubview:xiLineView];
        [xiLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(9);
            make.right.equalTo(backView.mas_right).offset(-9);
            make.bottom.equalTo(backView.mas_bottom);
            make.height.equalTo(@1);
        }];
        xiLineView.backgroundColor = specolor;
        
        //竖线
        UIView *shuView = [UIView new];
        [self addSubview:shuView];
        [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.top.equalTo(self.mas_top);
            make.width.equalTo(@1);
            make.height.equalTo(@124);
        }];
        shuView.backgroundColor = Heidiancolor;
        
  
    }
    return self;
}
-(void)setPlanModel:(UserPlanModel *)planModel
{
    _planModel = planModel;
    //[_dietBackground sd_setImageWithURL:[NSURL URLWithString:planModel.backgroud] placeholderImage:[UIImage imageNamed:@"食物.jpg"]];
    _dietTime.text = planModel.start;
}
@end

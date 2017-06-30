//
//  PlanTableViewCell.m
//  Orderdemo
//
//  Created by wei on 16/5/25.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "PlanTableViewCell.h"

@implementation PlanTableViewCell

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
        UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 68)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        _CellbackView = backView;
        
        //计划名称
        _planName = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREENWIDTH - 30, 16)];
        _planName.text = @"哑铃平举扩胸反复训练";
        _planName.textColor = Subcolor;
        _planName.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    
        [backView addSubview:_planName];
        
        //时间标签
        _dietTime = [[UILabel alloc]initWithFrame:CGRectMake(15, 42, 118, 12)];
        _dietTime.font = [UIFont systemFontOfSize:12];
        _dietTime.textColor = LableColor;
        [backView addSubview:_dietTime];
        
        
        _DoneDay = [UILabel new];
        [backView addSubview:_DoneDay];
        [_DoneDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dietTime.mas_right).offset(11);
            make.top.equalTo(_planName.mas_bottom).offset(11);
            make.width.greaterThanOrEqualTo(@120);
            make.height.equalTo(@12);
        }];
        
        _DoneDay.font = [UIFont systemFontOfSize:12];
        _DoneDay.textColor = LableColor;
        
    
        //cell中的黑线
        UIView *xiLineView = [UIView new];
        [backView addSubview:xiLineView];
        [xiLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(15);
            make.right.equalTo(backView.mas_right).offset(-15);
            make.bottom.equalTo(backView.mas_bottom);
            make.height.equalTo(@1);
        }];
        xiLineView.backgroundColor = specolor;
        _bottomLine = xiLineView;
       
        //当前计划指示标志
        _triple = [UIImageView new];
        [self addSubview:_triple];
        [_triple mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left);
            make.centerY.equalTo(backView.mas_centerY);
            make.width.equalTo(@4);
            make.height.equalTo(@46);
        }];
        _triple.image = [UIImage imageNamed:@"当前计划标志"];
        _triple.hidden = YES;
    }
    return self;

}
-(void)setPlanModel:(UserPlanModel *)planModel
{
    _planModel = planModel;
    //训练计划时间
    if (planModel.start.length != 0 && planModel.end.length != 0)
    {
        
        _dietTime.text = [NSString stringWithFormat:@"%@日~%@日",[self DateChange:planModel.start],[self DateChange:planModel.end]];
    }
    else
    {
        _dietTime.text = planModel.start;
    }
    //计划名称
    _planName.text = planModel.name;
    //完成天数
    _DoneDay.text = [NSString stringWithFormat:@"已完成%ld/%ld",(long)planModel.complete,(long)planModel.total];
    //计划背景图
    //[_dietBackground sd_setImageWithURL:[NSURL URLWithString:_planModel.backgroud] placeholderImage:[UIImage imageNamed:@"未显示状态"]];
    //进度条控制
    if (planModel.is_cur == YES)
    {
        _triple.hidden = NO;
        _planName.textColor = SegementColor;
    }
    else
    {
       _triple.hidden = YES;
        _planName.textColor = Subcolor;
    }

    
    
}
//处理时间格式
-(NSString*)DateChange:(NSString*)startAndEndTime
{
    NSString *changeDate = nil;
    if (startAndEndTime.length == 0)
    {
        
    }
    else
    {
        changeDate = [startAndEndTime substringFromIndex:5];
        changeDate = [changeDate stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    }
    return changeDate;
}

@end

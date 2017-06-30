//
//  MyPlanCollectionViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/30.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "MyPlanCollectionViewCell.h"

@implementation MyPlanCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([WYTDevicesTool iPhone6_iPhone6s]) {
        _PlanItem.constant = 44;
        _backimageHeight.constant = 180;
        _jianbianHeight.constant = 180;
        _planNameTop.constant = 117;
    }
    if ([WYTDevicesTool iPhone6Plus_iPhone6sPlus])
    {
        _PlanItem.constant = 44;
        _backimageHeight.constant = 197;
        _jianbianHeight.constant = 197;
        _planNameTop.constant = 117;
    }

}
-(void)setTrainModel:(TrainModel *)trainModel
{
    _trainModel = trainModel;
    
    _planName.text = _trainModel.name;
    
    if (_planName.text.length != 0)
    {
        _proposal.hidden = NO;
        _minAndAction.hidden = NO;
        _proposal.text = [NSString stringWithFormat:@"建议:%@",_trainModel.discription.note];
        _minAndAction.text = [NSString stringWithFormat:@"%ld个动作  约%ld分钟",(long)_trainModel.action_count,_trainModel.length / 60];
        [_planImage sd_setImageWithURL:[NSURL URLWithString:_trainModel.backgroud] placeholderImage:[UIImage imageNamed:@"饮食计划"]];
        _actionDay.text = [NSString stringWithFormat:@"%ld/%ld次",(long)_trainModel.complete,(long)_trainModel.total];
        MyAttributedStringBuilder *wangcheng = [[MyAttributedStringBuilder alloc] initWithString:_actionDay.text];
        NSInteger leng = _actionDay.text.length;
        if([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
        {
          [[wangcheng range:NSMakeRange(0,leng - 1)] setFont:[UIFont systemFontOfSize:20]];
        }
        else
        {
            [[wangcheng range:NSMakeRange(0,leng - 1)] setFont:[UIFont systemFontOfSize:20]];
        }
        
        [[wangcheng range:NSMakeRange(0,leng - 1)] setTextColor:planTextColor];
        _actionDay.attributedText = wangcheng.commit;
    }
    else
    {
        //没有推计划
        _proposal.hidden = YES;
        _minAndAction.hidden = YES;
        _actionDay.text = @"0/0天";
        _planImage.image = [UIImage imageNamed:@"暂无计划-背景图"];
    }
    
    _planImage.contentMode = UIViewContentModeScaleAspectFill;
    _planImage.clipsToBounds = YES;
    
   
    
    
}
@end

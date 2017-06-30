//
//  CourseHeadV.m
//  AirCoach.acUser
//
//  Created by xuan on 15/11/27.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "CourseHeadV.h"

@implementation CourseHeadV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)awakeFromNib {
    // Initialization code
    
    
    
    self.courseBgImg.contentMode = UIViewContentModeScaleAspectFill;
  
    self.courseBgImg.clipsToBounds = YES;
    self.shiyingrenqunLabel.textAlignment = UITextAlignmentLeft;
    
    self.shiyingrenqunLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.shiyingrenqunLabel.layer.shadowOffset = CGSizeMake(3, 3);
    self.shiyingrenqunLabel.layer.shadowOpacity = 0.5;
    self.shiyingrenqunLabel.layer.shadowRadius = 3;
    
    
    self.courseLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.courseLabel.layer.shadowOffset = CGSizeMake(3, 3);
    self.courseLabel.layer.shadowOpacity = 0.5;
    self.courseLabel.layer.shadowRadius = 3;
    
    
    self.wanchengTianLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.wanchengTianLabel.layer.shadowOffset = CGSizeMake(3, 3);
    self.wanchengTianLabel.layer.shadowOpacity = 0.5;
    self.wanchengTianLabel.layer.shadowRadius = 3;
    
    
    self.jianyiLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.jianyiLabel.layer.shadowOffset = CGSizeMake(3, 3);
    self.jianyiLabel.layer.shadowOpacity = 0.5;
    self.jianyiLabel.layer.shadowRadius = 3;
    
    
    self.kechengTime.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.kechengTime.layer.shadowOffset = CGSizeMake(3, 3);
    self.kechengTime.layer.shadowOpacity = 0.5;
    self.kechengTime.layer.shadowRadius = 3;
    
    
}
-(void)setCourseModel:(CourseModel *)courseModel
{
    _courseModel = courseModel;
    [_courseBgImg sd_setImageWithURL:[NSURL URLWithString:_courseModel.backgroud] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    _kechengTime.text = [NSString stringWithFormat:@"%ld 个动作    约 %d 分钟",(long)_courseModel.action_count,_courseModel.length/60];
    MyAttributedStringBuilder *builder = [[MyAttributedStringBuilder alloc] initWithString:[NSString stringWithFormat:@"第 %ld/%ld 次",(long)_courseModel.complete,(long)_courseModel.total]];
    
    NSInteger leng = [NSString stringWithFormat:@"%ld",(long)_courseModel.complete].length+[NSString stringWithFormat:@"%ld",(long)_courseModel.total].length+1;
    
    [[builder range:NSMakeRange(2,leng)] setFont:[UIFont systemFontOfSize:30]];
    _wanchengTianLabel.attributedText = builder.commit;
    
    
    _courseLabel.text = _courseModel.name;
    _shiyingrenqunLabel.text = [NSString stringWithFormat:@"%@",[_courseModel.descriptionss objectForKey:@"note"]];
    
}
-(void)setCoachModel:(CoachModel *)coachModel
{
    _coachModel = coachModel;
    _jianyiLabel.text = [NSString stringWithFormat:@"用户名：%@     塑形师：%@",[BusinessAirCoach getNickName],_coachModel.name];
}


@end

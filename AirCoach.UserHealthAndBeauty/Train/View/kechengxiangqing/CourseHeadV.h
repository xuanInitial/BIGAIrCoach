//
//  CourseHeadV.h
//  AirCoach.acUser
//
//  Created by xuan on 15/11/27.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"
#import "CoachModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyAttributedStringBuilder.h"
#import "BusinessAirCoach.h"
@protocol BtnClcikDelegate <NSObject>

- (void)btnClick:(UIButton *)sender;

@end


@interface CourseHeadV : UIView

@property (strong, nonatomic) IBOutlet UIImageView *courseBgImg;

@property (strong, nonatomic) IBOutlet UILabel *courseLabel;

@property (strong, nonatomic) IBOutlet UILabel *shiyingrenqunLabel;//注意



@property (strong, nonatomic) IBOutlet UILabel *wanchengTianLabel;
@property (strong, nonatomic) IBOutlet UILabel *jianyiLabel;//用户名+护理师

@property (strong, nonatomic) IBOutlet UILabel *kechengTime;//动作+时间

@property (nonatomic, strong) CourseModel *courseModel;
@property (strong, nonatomic) CoachModel*coachModel;
@end

//
//  DoctorDetailTableViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/7/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "MainTableViewCell.h"
#import "Cur_planModel.h"
#import "BusinessAirCoach.h"
@interface DoctorDetailTableViewCell : MainTableViewCell
@property(nonatomic,strong)UILabel *DoctorName;
@property(nonatomic,strong)UIImageView *DoctorHead;
@property(nonatomic,strong)UILabel *DoneDay;
@property(nonatomic,strong)UILabel *Notation;
@property(nonatomic,strong)Cur_planModel *planDetail;
@end

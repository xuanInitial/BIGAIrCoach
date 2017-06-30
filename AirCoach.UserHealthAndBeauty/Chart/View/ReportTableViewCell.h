//
//  ReportTableViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/8.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportModel.h"
#import "ReportCoach.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ReportTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *head;
@property(nonatomic,strong)UILabel *Name;
@property(nonatomic,strong)UILabel *Job;
@property(nonatomic,strong)UILabel *word;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,copy)ReportModel *ReportDetail;
@property(nonatomic,strong)UILabel *Mylable;
@end

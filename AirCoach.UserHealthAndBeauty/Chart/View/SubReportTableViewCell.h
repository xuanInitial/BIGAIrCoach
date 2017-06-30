//
//  SubReportTableViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/21.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportModel.h"
#import "ReportCoach.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+XMGExtension.h"
@interface SubReportTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *word;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,copy)ReportModel *ReportDetail;
@end

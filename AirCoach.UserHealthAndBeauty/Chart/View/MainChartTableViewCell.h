//
//  MainChartTableViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/7.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainChartTableViewCell : UITableViewCell

@property(nonatomic,weak)UILabel *NameItem;
@property(nonatomic,weak)UILabel *SedNameItem;
@property(nonatomic,weak)UILabel *NumItem;
@property(nonatomic,weak)UILabel *propolItem;
@property(nonatomic,copy)NSArray * cellArr;
@property(nonatomic,copy)NSArray * TimeArr;
@property(nonatomic,copy)NSArray * CollocetionCellArr;
@property(nonatomic,copy)NSMutableArray *Xnum;
@end

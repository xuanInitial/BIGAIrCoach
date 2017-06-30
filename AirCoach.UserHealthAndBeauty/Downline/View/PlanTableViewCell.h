//
//  PlanTableViewCell.h
//  Orderdemo
//
//  Created by wei on 16/5/25.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPlanModel.h"
#import "MainTableViewCell.h"
@interface PlanTableViewCell : MainTableViewCell

@property(nonatomic,strong)UserPlanModel *planModel;
@property(nonatomic,strong)UILabel *dietTime;
@property(nonatomic,strong)UIImageView *dietBackground;
@property(nonatomic,strong)UILabel *DoneDay;
@property(nonatomic,strong)UILabel *planName;
@property(nonatomic,strong)UIView *gray;
@property(nonatomic,strong)UIView *orange;
@property(nonatomic,strong)UIImageView *triple;
@property(nonatomic,strong)UIView *bottomLine;
@property(nonatomic,strong)UIView *CellbackView;
@end

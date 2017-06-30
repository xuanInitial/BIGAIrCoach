//
//  NoticTableViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/16.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "MainTableViewCell.h"
#import "NoticeModel.h"
@interface NoticTableViewCell : MainTableViewCell

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)NoticeModel *model;

@end

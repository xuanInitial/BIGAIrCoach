//
//  CourseDetailViewController.h
//  AirCoach.acUser
//
//  Created by xuan on 15/11/24.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "previewModel.h"
#import "WarmModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ClassCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *classLabel;
@property (nonatomic,strong)UIImageView *bgiMG;
@property (nonatomic,strong)previewModel *previewMod;
//@property (nonatomic,strong)UILabel *countLabel;
//@property (nonatomic,strong)WarmModel *warmMod;

//强度标签
@property (nonatomic,strong)UILabel *gradeLab;

@end

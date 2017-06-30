//
//  MyPlanCollectionViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/30.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyAttributedStringBuilder.h"
#import "WYTDevicesTool.h"
@interface MyPlanCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *planImage;
@property (weak, nonatomic) IBOutlet UILabel *minAndAction;
@property (weak, nonatomic) IBOutlet UILabel *proposal;
@property (weak, nonatomic) IBOutlet UILabel *actionDay;
@property (weak, nonatomic) IBOutlet UILabel *planName;

@property(nonatomic,strong)TrainModel *trainModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PlanItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jianbianHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backimageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *planNameTop;

@end

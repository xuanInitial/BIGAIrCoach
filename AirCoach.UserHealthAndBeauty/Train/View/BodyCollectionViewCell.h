//
//  BodyCollectionViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/27.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalModel.h"
#import "MyAttributedStringBuilder.h"
#import "WYTDevicesTool.h"
@interface BodyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *testDay;
@property (weak, nonatomic) IBOutlet UIButton *DoneBtn;
@property(nonatomic,strong)PersonalModel *model;

@property (weak, nonatomic) IBOutlet UILabel *jianyi;
@property (weak, nonatomic) IBOutlet UIButton *writeLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ItemHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DoneTop;



@end

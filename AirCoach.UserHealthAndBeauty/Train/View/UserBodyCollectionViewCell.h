//
//  UserBodyCollectionViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/27.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionViewCell.h"
@interface UserBodyCollectionViewCell : MainCollectionViewCell
-(void)configCellUI;
@property(nonatomic,strong)UILabel *Cishu;
@property(nonatomic,strong)UIButton *WriteBt;
@end

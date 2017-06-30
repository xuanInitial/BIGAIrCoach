//
//  DietTableViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/1.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessAirCoach.h"
@interface DietTableViewCell : UITableViewCell

@property(nonatomic)BOOL showFlag;

@property(nonatomic,strong)UILabel *whichDiet;

@property(nonatomic)NSInteger Mysection;

@end

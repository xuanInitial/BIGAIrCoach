//
//  TestTableViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/5/30.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *DoneLable;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UILabel *TestTime;

@end

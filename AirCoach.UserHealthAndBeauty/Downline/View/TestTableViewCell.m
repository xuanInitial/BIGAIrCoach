//
//  TestTableViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/5/30.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "TestTableViewCell.h"

@implementation TestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREENWIDTH - 42, 75) byRoundingCorners:UIRectCornerBottomLeft| UIRectCornerBottomRight  cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = CGRectMake(0, 0, SCREENWIDTH - 42, 75);
    maskLayer.path = maskPath.CGPath;
    _backView.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

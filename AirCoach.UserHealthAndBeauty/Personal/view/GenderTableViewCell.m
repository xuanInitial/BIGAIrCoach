//
//  GenderTableViewCell.m
//  AirCoach.acUser
//
//  Created by xuan on 15/12/7.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "GenderTableViewCell.h"

@implementation GenderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _nameTextField.borderStyle = UITextBorderStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

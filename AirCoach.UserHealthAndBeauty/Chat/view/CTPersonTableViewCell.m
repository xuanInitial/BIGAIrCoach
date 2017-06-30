//
//  CTPersonTableViewCell.m
//  AirCoach2.0
//
//  Created by 高静 on 16/1/10.
//  Copyright © 2016年 高静. All rights reserved.
//

#import "CTPersonTableViewCell.h"

@implementation CTPersonTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    _Header.layer.cornerRadius = 28;
    _Header.layer.masksToBounds = YES;
    _NewText.layer.cornerRadius = 5;
    _NewText.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

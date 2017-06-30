//
//  DietCollectionViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/15.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "DietCollectionViewCell.h"
#import "UIImageView+CornerRadius.h"
#import "UIView+XMGExtension.h"
@implementation DietCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        _DietImageV = [[UIImageView alloc]initWithCornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
        [_DietImageV setFrame:CGRectMake(0, 16, 100, 75)];
        _DietImageV.contentMode = UIViewContentModeScaleAspectFill;
        _DietImageV.clipsToBounds = YES;
        
        [self.contentView addSubview:_DietImageV];
        
        _DietNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _DietImageV.y + 75 + 8, 126, 12)];
        _DietNameLabel.textAlignment = NSTextAlignmentLeft; //水平对齐
        [_DietNameLabel setFont:[UIFont systemFontOfSize:12]];
        [_DietNameLabel setTextColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0f]];
        [self.contentView addSubview:_DietNameLabel];
        
        //数据控件设置
        _DietNum = [[UILabel alloc] initWithFrame:CGRectMake(0, _DietNameLabel.y + 12 + 8, 100, 12)];
        _DietNum.textAlignment = NSTextAlignmentLeft; //水平对齐
        [_DietNum setFont:[UIFont systemFontOfSize:12]];
        [_DietNum setTextColor:LableColor];
        [self.contentView addSubview:_DietNum];
        
    }
    return self;
}


@end

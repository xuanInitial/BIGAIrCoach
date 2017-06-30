//
//  MyCollecCollectionViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/7/18.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "MyCollecCollectionViewCell.h"

@implementation MyCollecCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imageView];
       
        [self addSubview:self.machLabel];
        
    }
    return self;
}


- (UIImageView *)imageView{
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width -43)/2,13, 43, 43)];
    }
    _imageView.image = [UIImage imageNamed:@"im"];
    
    _imageView.clipsToBounds = YES;
    _imageView.layer.cornerRadius = 21.5;
    
    _imageView.layer.masksToBounds = YES;
    return _imageView;
}

- (UILabel *)machLabel{
    if (!_machLabel) {
        _machLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, self.frame.size.width, 14)];
    }
    _machLabel.text = @" ";
    _machLabel.textColor = [UIColor colorWithRed:48/255.f green:48/255.f blue:48/255.f alpha:1];
    _machLabel.font  =[UIFont systemFontOfSize:14];
    _machLabel.textAlignment = NSTextAlignmentCenter; //水平对齐
    [_machLabel setTextColor:[UIColor blackColor]];
    return _machLabel;
}
@end

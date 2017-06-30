//
//  CourseDetailViewController.h
//  AirCoach.acUser
//
//  Created by xuan on 15/11/24.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "ClassCollectionViewCell.h"
#import "UIImageView+CornerRadius.h"
#import "UIView+XMGExtension.h"
#import "Header.h"

#define ac @"abcdefghijklmnopqrstuvwxyz"
#define AC @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
@implementation ClassCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageV = [[UIImageView alloc]initWithCornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
        [_imageV setFrame:CGRectMake(0, 0, 100, 75)];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
        
        [self.contentView addSubview:_imageV];
        
       _classLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 83, 100, 12)];
       _classLabel.textAlignment = NSTextAlignmentLeft; //水平对齐
        [_classLabel setFont:[UIFont systemFontOfSize:12]];
        [_classLabel setTextColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0f]];
        [self.contentView addSubview:_classLabel];
        
        //强度控件设置
        _gradeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _classLabel.y + 12 + 8, 100, 12)];
        _gradeLab.textAlignment = NSTextAlignmentLeft; //水平对齐
        [_gradeLab setFont:[UIFont systemFontOfSize:12]];
        [_gradeLab setTextColor:LableColor];
        [self.contentView addSubview:_gradeLab];
        
    }
    return self;
}

-(void)setPreviewMod:(previewModel *)previewMod
{
    _previewMod = previewMod;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@300w_225h_80q",previewMod.figure]] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    NSString *planName = previewMod.name;
    
    if (([AC rangeOfString:[planName substringFromIndex:planName.length - 1]].length != 0 ||[ac rangeOfString:[planName substringFromIndex:planName.length - 1]].length != 0) && previewMod.name != nil && previewMod.name.length!= 0)
    {
        planName = [previewMod.name substringToIndex:previewMod.name.length - 1];
    }
    
    NSString *foundStr = @"-";
    NSRange range = [previewMod.name rangeOfString:foundStr];
    if ([previewMod.name rangeOfString:foundStr].length != 0 && previewMod.name.length != 0 && previewMod.name != nil)
    {
       //截取两个字符串 “-”之前的
        _classLabel.text = [planName substringToIndex:range.location];
        //“-”之后的
        _gradeLab.text = [planName substringFromIndex:range.location + 1];
      
    }
    else
    {
        _classLabel.text = planName;
        _gradeLab.text = @"";
    }
    
}

@end

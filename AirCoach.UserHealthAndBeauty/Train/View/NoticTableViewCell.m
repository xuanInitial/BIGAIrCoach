//
//  NoticTableViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/16.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "NoticTableViewCell.h"

@implementation NoticTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 108)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteView];
        
        _imageV = [UIImageView new];
        [whiteView addSubview:_imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView.mas_left).offset(15);
            make.top.equalTo(whiteView.mas_top).offset(15);
            make.bottom.equalTo(whiteView.mas_bottom).offset(-15);
            make.width.equalTo(@104);
        }];
        _imageV.layer.cornerRadius = 3;
        _imageV.layer.masksToBounds = YES;//圆角
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;//居中显示
        
        _name = [UILabel new];
        [whiteView addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageV.mas_right).offset(15);
            make.top.equalTo(whiteView.mas_top).offset(46);
            make.right.equalTo(whiteView.mas_right).offset(-15);
            make.height.equalTo(@16);
        }];
        _name.textColor = Subcolor;
        _name.font = [UIFont systemFontOfSize:16];
        
        
        UIView *xiline = [UIView new];
        [whiteView addSubview:xiline];
        [xiline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView.mas_left).offset(15);
            make.right.equalTo(whiteView.mas_right).offset(-15);
            make.bottom.equalTo(whiteView.mas_bottom);
            make.height.equalTo(@(0.5));
        }];
        xiline.backgroundColor = specolor;
        
        
        
    }
    return self;
}
-(void)setModel:(NoticeModel *)model
{
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"提示页面占位图"]];
    _name.text = model.name;
}




@end

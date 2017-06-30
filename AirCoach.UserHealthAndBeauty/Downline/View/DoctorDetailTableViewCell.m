//
//  DoctorDetailTableViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/7/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "DoctorDetailTableViewCell.h"

@implementation DoctorDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //护理师头像
        _DoctorHead = [UIImageView new];
        [self.contentView addSubview:_DoctorHead];
        [_DoctorHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(14);
            make.width.equalTo(@22);
            make.height.equalTo(@22);
        }];
        _DoctorHead.layer.cornerRadius = 11;
        _DoctorHead.layer.masksToBounds = YES;
        _DoctorHead.image = [UIImage imageNamed:@"icon-护理师"];
        
        //护理师姓名
        _DoctorName = [UILabel new];
        [self.contentView addSubview:_DoctorName];
        [_DoctorName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_DoctorHead.mas_right).offset(9);
            make.top.equalTo(self.contentView.mas_top).offset(16);
            make.width.greaterThanOrEqualTo(@40);
            make.height.equalTo(@18);
        }];
        _DoctorName.textColor = Subcolor;
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _DoctorName.font = font;
        _DoctorName.text =[BusinessAirCoach getCoachName];
        
        //护理师职称
        UILabel *DoctorWho = [UILabel new];
        [self.contentView addSubview:DoctorWho];
        [DoctorWho mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_DoctorName.mas_right).offset(5);
            make.bottom.equalTo(_DoctorName.mas_bottom);
            make.width.greaterThanOrEqualTo(@40);
            make.height.equalTo(@12);
        }];
        DoctorWho.textColor = LableColor;
        DoctorWho.font = [UIFont systemFontOfSize:12];
        DoctorWho.text = @"护理师";
        
        //完成次数
        _DoneDay = [UILabel new];
        [self.contentView addSubview:_DoneDay];
        [_DoneDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.contentView.mas_top).offset(13);
            make.width.greaterThanOrEqualTo(@80);
            make.height.greaterThanOrEqualTo(@21);
        }];
        
        _DoneDay.text = @"已完成 3/3 次";
        _DoneDay.textColor = Subcolor;
        _DoneDay.font = [UIFont systemFontOfSize:12];
        
        
        //注意事项
        
//        _Notation = [UILabel new];
//        [self.contentView addSubview:_Notation];
//        [_Notation mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(15);
//            make.top.equalTo(_DoctorHead.mas_bottom).offset(15);
//            make.width.equalTo(@(SCREENWIDTH - 30));
//            make.height.greaterThanOrEqualTo(@15);
//        }];
//        _Notation.text = @"感觉部位酸痛时建议稍微延长休息休息时间，严重的话建议立即停止训练";
//        _Notation.numberOfLines = 0;
//        _Notation.font = [UIFont systemFontOfSize:14];
        
        //底部黑线
        UIView *LineView = [UIView new];
        [self.contentView addSubview:LineView];
        [LineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.left.equalTo(self.contentView.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@1);
        }];
        LineView.backgroundColor = xiLine;
    }
    return self;
}
//行距设置
-(NSMutableAttributedString*)TheLabletext:(NSString*)text
{
    if (text != nil)
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        paragraphStyle.lineSpacing = 8;  //行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        return attributedString;
    }
    else
    {
        return nil;
    }
}
-(void)setPlanDetail:(Cur_planModel *)planDetail
{
    _planDetail = planDetail;
//    _Notation.text = planDetail.discription.note;
//    NSMutableAttributedString *str = [self TheLabletext:_Notation.text];
//    _Notation.attributedText = str;
//    _Notation.y = _DoctorHead.y + 22 + 13;
//    NSLog(@"-------%lf",_Notation.height);
//    [_Notation sizeToFit];
    
    _DoneDay.text = [NSString stringWithFormat:@"已完成 %ld/%ld 次",(long)planDetail.complete,(long)planDetail.total];
    MyAttributedStringBuilder *wangcheng = [[MyAttributedStringBuilder alloc] initWithString:_DoneDay.text];
    NSInteger leng = _DoneDay.text.length;
    [[wangcheng range:NSMakeRange(3,leng - 5)] setFont:[UIFont systemFontOfSize:21]];
    _DoneDay.attributedText = wangcheng.commit;
    
    
    
}
@end

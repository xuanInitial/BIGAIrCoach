//
//  ReportTableViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/8.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "ReportTableViewCell.h"
#import "UIView+XMGExtension.h"

@implementation ReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _head = [[UIImageView alloc]initWithFrame:CGRectMake(15, 19, 56, 56)];
        _head.image = [UIImage imageNamed:@"用户-默认头像"];
        _head.layer.cornerRadius = 28;
        _head.layer.masksToBounds = YES;
        [self addSubview:_head];
        
        _Name = [[UILabel alloc]initWithFrame:CGRectMake(82, 29, 200, 17)];
        _Name.text = @"姓名";
        _Name.font = [UIFont systemFontOfSize:17];
        _Name.textColor = Subcolor;
        [self addSubview:_Name];
        
        _Job = [[UILabel alloc]initWithFrame:CGRectMake(82, _Name.y + 24, 150, 12)];
        _Job.text = @"塑形师";
        _Job.textColor = LableColor;
        _Job.font = [UIFont systemFontOfSize:12];
        [self addSubview:_Job];
        
        _word = [[UILabel alloc]initWithFrame:CGRectMake(15, _head.y + 75, SCREENWIDTH - 30, 50)];
        _word.textColor = Reportcolor;
        _word.font = [UIFont systemFontOfSize:14];
        _word.numberOfLines = 0;
        _word.tag = 2000;
        
        
        [self addSubview:_word];
        
        _time = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 85, _word.y + 61,70,12)];
        _time.font = [UIFont systemFontOfSize:12];
        _time.textColor = LableColor;
        
        [self addSubview:_time];
        
        
        
    }
    return self;
}
-(void)setMylable:(UILabel *)Mylable
{
    _Mylable = Mylable;
    _Name.text = @"暂无评论";
    
}
-(void)setReportDetail:(ReportModel *)ReportDetail
{
    _ReportDetail = ReportDetail;
    
    _word.text = _ReportDetail.content;
    //NSString *str1 = @"有时候为了不让别人知道，我就找个很厉害的歌手来唱我的歌,听出爱过的人彼时的真诚，就已足够";
    //_word.text = str1;
    //换行加设置行间距
    CGSize size = [_word.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREENWIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%lf",size.height);
    NSMutableAttributedString *str = [self TheLabletext:_word.text];
    _word.attributedText = str;
    _word.height = size.height;
    _word.y =_head.y + 72;
    [_word sizeToFit];
    
    NSLog(@"%lf",_word.height);
    _time.text = [_ReportDetail.created_at substringToIndex:10];
    
    _Name.text = _ReportDetail.coach.name;
    _time.y = _word.y + _word.height + 9;
    [_head sd_setImageWithURL:[NSURL URLWithString:_ReportDetail.coach.figure] placeholderImage:[UIImage imageNamed:@"数据图表页-塑形师"]];
    
    
    
    
    
    
}
//行距设置
-(NSMutableAttributedString*)TheLabletext:(NSString*)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //paragraphStyle.maximumLineHeight = 18;  //最大的行高
    paragraphStyle.lineSpacing = 5;  //行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}

@end

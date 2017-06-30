//
//  SubReportTableViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/21.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "SubReportTableViewCell.h"

@implementation SubReportTableViewCell

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
      
        
        
        _word = [[UILabel alloc]initWithFrame:CGRectMake(15, 19, SCREENWIDTH - 30, 50)];
        _word.text = @"评论内容请等待";
        _word.textColor = Reportcolor;
        _word.font = [UIFont systemFontOfSize:14];
        _word.numberOfLines = 0;
        [self addSubview:_word];
        
        
        _time = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 85, _word.y + 61,70,12)];
        _time.text = @"2016-7-6";
        _time.font = [UIFont systemFontOfSize:12];
        _time.textColor = LableColor;
        [self addSubview:_time];
        
        
        
    }
    return self;
}
-(void)setReportDetail:(ReportModel *)ReportDetail
{
    _ReportDetail = ReportDetail;
    
    _word.text = _ReportDetail.content;
    
    //换行加设置行间距
    CGSize size = [_word.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREENWIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%lf",size.height);
    NSMutableAttributedString *str = [self TheLabletext:_word.text];
    _word.attributedText = str;
    //_word.height = size.height;
    _word.y =16;
    [_word sizeToFit];
    

    
    _time.text = [_ReportDetail.created_at substringToIndex:10];
    _time.y = _word.y + _word.height + 11;
   
    
    
    
    
    
    
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

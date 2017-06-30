//
//  BodyCollectionViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/27.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "BodyCollectionViewCell.h"

@implementation BodyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([WYTDevicesTool iPhone6_iPhone6s]) {
        _ItemHeight.constant = 44;
        _ImageHeight.constant = 180;
        _DoneTop.constant = 87;
    }
    if ([WYTDevicesTool iPhone6Plus_iPhone6sPlus])
    {
        _ItemHeight.constant = 44;
        _ImageHeight.constant = 197;
        _DoneTop.constant = 87;
    }
    
}
-(void)setModel:(PersonalModel *)model
{
    _model = model;
    _testDay.text = [NSString stringWithFormat:@"已填写 %ld/4",(long)model.cur_checking.total];
    
    MyAttributedStringBuilder *wangcheng = [[MyAttributedStringBuilder alloc] initWithString:_testDay.text];
    NSInteger leng = _testDay.text.length;
    [[wangcheng range:NSMakeRange(3,leng - 3)] setFont:[UIFont systemFontOfSize:35]];
    _testDay.attributedText = wangcheng.commit;
    
    NSMutableAttributedString *str = [self TheLabletext:_jianyi.text];
    _jianyi.attributedText = str;

    

}
//行距设置
-(NSMutableAttributedString*)TheLabletext:(NSString*)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //paragraphStyle.maximumLineHeight = 18;  //最大的行高
    paragraphStyle.lineSpacing = 4;  //行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}

@end

//
//  UIView+WomenTestView.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/5/31.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "UIView+WomenTestView.h"

@implementation UIView (WomenTestView)
+ (UIView *)ViewWithFrameByCategory:(CGRect)frame MianView:(UIView*)mainView trainPic:(NSString*)name order:(NSString*)orderName Num:(NSString*)num detail:(BOOL)isopen itemName:(NSString*)item jieshi:(NSString*)word
{
     UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    
    UIView *backView = [[UIView alloc]initWithFrame:frame];
    [mainView addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    
    //训练图
    UIImageView *trainPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 0.65)];
    trainPic.image = [UIImage imageNamed:name];
    trainPic.contentMode = UIViewContentModeScaleAspectFill;
    trainPic.clipsToBounds = YES;
    [backView addSubview:trainPic];
    trainPic.tag = 997;
    
    
    //解释文字
//    UILabel *explo = [UILabel new];
//    explo.text = word;
//    explo.numberOfLines = 0;
//    explo.textColor = [UIColor whiteColor];
//    CGSize size = [word sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//    NSLog(@"%lf",size.height);
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:word];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    
//    //paragraphStyle.maximumLineHeight = 18;  //最大的行高
//    paragraphStyle.lineSpacing = 9;  //行间距
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, word.length)];
//    
//
//    explo.attributedText = attributedString;
//    explo.frame = CGRectMake((SCREENWIDTH - 200) / 2, trainPic.height - 32 - size.height, 200, size.height);
//    
//    [trainPic addSubview:explo];
    
    //标题
    UILabel *itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,30,SCREENWIDTH,18)];
    itemLabel.text = item;
    itemLabel.font = font;
    itemLabel.textColor = [UIColor whiteColor];
    itemLabel.textAlignment = 1;
    [trainPic addSubview:itemLabel];
    
    //名称
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, trainPic.height + 20, SCREENWIDTH, 17)];
    nameLabel.text = orderName;
    nameLabel.textAlignment = 1;
    [backView addSubview:nameLabel];
    nameLabel.textColor = Subcolor;
    nameLabel.tag = 998;
    
    
    CGFloat topy = 0;
    //提示信息
    if (isopen == YES)
    {
        UILabel *tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLabel.y + 9 + 17 , SCREENWIDTH, 13)];
        tishiLabel.text = @"(可精确至小数点后一位)";
        tishiLabel.textAlignment = 1;
        [backView addSubview:tishiLabel];
        tishiLabel.textColor = LableColor;
        tishiLabel.font = [UIFont systemFontOfSize:13];
        tishiLabel.tag = 999;
        
        topy = 9 + 13;
    }
    
    //输入框
    UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake((SCREENWIDTH - 100) / 2, nameLabel.y + topy + 30 + 17 , 100, 40)];
    [backView addSubview:input];
    input.tag = 1000;
    input.keyboardType = UIKeyboardTypeNumberPad;
    input.textAlignment = 1;
    input.font = [UIFont systemFontOfSize:40];
    input.textColor = SegementColor;
    
    //细线
    
    UIView *blackLine = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH - 153) / 2, input.y + 40 + 10, 153, 1)];
    blackLine.backgroundColor = [UIColor blackColor];
    [backView addSubview:blackLine];
    blackLine.backgroundColor = TestLinecolor;
    
    //单位
    UILabel *NumLabel = [[UILabel alloc]initWithFrame:CGRectMake(input.x + 100, blackLine.y - 10 - 20 ,50, 20)];
    NumLabel.text = num;
    NumLabel.textAlignment = 1;
    [backView addSubview:NumLabel];
    NumLabel.font = [UIFont systemFontOfSize:15];
    NumLabel.tag = 1001;
    
    
    
    
    
    
    
    return backView;
}


@end

//
//  UILabel+TopAndBottom.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/9/8.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "UILabel+TopAndBottom.h"

@implementation UILabel (TopAndBottom)
- (void)alignTop {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}
- (CGFloat)numberOfText{
    // 获取单行时候的内容的size
    CGSize singleSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    // 获取多行时候,文字的size
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(SCREENWIDTH - 149, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    // 返回计算的行数
    NSLog(@"%lf",ceil( textSize.height / singleSize.height));
    return ceil( textSize.height / singleSize.height);
}
@end

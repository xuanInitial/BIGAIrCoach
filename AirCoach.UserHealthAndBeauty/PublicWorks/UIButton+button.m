//
//  UIButton+button.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/30.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "UIButton+button.h"

@interface UIButton (button)

@property (nonatomic, assign) BOOL underlineNone;
@end
@implementation UIButton (button)
@dynamic underlineNone;

-(void)setUnderlineNone:(BOOL)flag {
    if (flag) {
        NSString *text = self.titleLabel.text;
       
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
        //    [str addAttribute:NSForegroundColorAttributeName value:ColorForGestureButton range:NSMakeRange(0,forgetPasswordText.length)];
        [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleNone] range:NSMakeRange(0,text.length)];
        [self setAttributedTitle:string forState:UIControlStateNormal];
    }
    
    
}
@end

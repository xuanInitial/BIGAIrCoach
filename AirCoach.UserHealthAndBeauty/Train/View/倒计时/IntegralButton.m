//
//  IntegralButton.m
//  9.17 new
//
//  Created by xuan on 15/9/17.
//  Copyright (c) 2015年 AVPlayer. All rights reserved.
//

#import "IntegralButton.h"
#import "Header.h"
@implementation IntegralScaleSetting
@end
@implementation IntegralButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}



- (void)scale:(IntegralScaleSetting*)setting {
    //self.titleLabel.transform = CGAffineTransformMakeScale(1, 1);
    self.titleLabel.alpha     = 0.99;
    [self setTitleColor:setting.colorTitle ? setting.colorTitle :ZiTiColor  forState:UIControlStateNormal];
    [self setTitleColor:setting.colorTitle ? setting.colorTitle : ZiTiColor forState:UIControlStateDisabled];
    if (setting.indexStart >= 0)
    {
        self.backgroundColor = setting.colorDisable ? setting.colorDisable : [UIColor clearColor];
        [self setEnabled:NO];
        NSString* title = [NSString stringWithFormat:@"   %@%d%@   ",(setting.strPrefix ? setting.strPrefix : @""),setting.indexStart,(setting.strSuffix ? setting.strSuffix : @"")];
        NSLog(@"%@",title);
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateDisabled];
        
        __weak typeof (self) wSelf = self;
        [UIView animateWithDuration:1 animations:^{
          //  self.titleLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.titleLabel.alpha     = 1.0;
        } completion:^(BOOL b){
            setting.indexStart--;
            [wSelf scale:setting];
        }];
    }
    else {
        self.backgroundColor = setting.colorCommon ? setting.colorCommon : [UIColor whiteColor];
        [self setEnabled:YES];
        [self setTitle:setting.strCommon forState:UIControlStateNormal];
    }
}



#pragma mark - 启动函数
- (void)startWithSetting:(IntegralScaleSetting *)setting {
    [self scale:setting];
}
@end

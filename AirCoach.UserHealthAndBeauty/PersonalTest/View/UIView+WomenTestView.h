//
//  UIView+WomenTestView.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/5/31.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XMGExtension.h"
@interface UIView (WomenTestView)
+ (UIView *)ViewWithFrameByCategory:(CGRect)frame MianView:(UIView*)mainView trainPic:(NSString*)name order:(NSString*)orderName Num:(NSString*)num detail:(BOOL)isopen itemName:(NSString*)item jieshi:(NSString*)word;
-(NSMutableAttributedString*)TheLabletext:(NSString*)text;
@end

//
//  UITabBar+badge.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/7/4.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)


- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end

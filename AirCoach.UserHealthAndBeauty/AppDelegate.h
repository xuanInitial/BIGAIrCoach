//
//  AppDelegate.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>

static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property(nonatomic,assign)NSInteger allowRotation;
@property (strong, nonatomic) UIWindow *window;


@end


//
//  RootTabBarController.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UITabBar+badge.h"

#import "AppConstant.h"

#import "clickClientPro.h"


@interface RootTabBarController : UITabBarController

@property(nonatomic,strong)id<clickClientProtocol>clientDelegate;
-(void)setClientDelegate:(id<clickClientProtocol>)clientDelegate;
+ (instancetype)instance;
@end

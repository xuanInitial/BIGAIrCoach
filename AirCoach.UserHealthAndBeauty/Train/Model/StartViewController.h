//
//  StartViewController.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/29.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "BaseViewController.h"


@interface StartViewController : BaseViewController

@property(nonatomic,copy)void (^requestForUserInfoBlock)();
@property(nonatomic,strong)NSString *loginFlag;

@end

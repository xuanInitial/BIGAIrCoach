//
//  NTESSessionViewController.h
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NIMSessionViewController.h"

#import "UIImageView+WebCache.h"


@interface NTESSessionViewController : NIMSessionViewController

@property (nonatomic,assign) BOOL disableCommandTyping;  //需要在导航条上显示“正在输入”
@property (nonatomic,strong) UILabel *titleLabel;
@end

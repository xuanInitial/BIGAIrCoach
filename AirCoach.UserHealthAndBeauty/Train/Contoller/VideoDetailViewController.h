//
//  VideoDetailViewController.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/16.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface VideoDetailViewController : BaseViewController

@property(nonatomic,strong)NSString *VideoUrl;
@property(nonatomic,strong)NSString *VideoDetail;
@property(nonatomic,strong)NSString *VideoName;
@property(nonatomic)NSInteger videoId;

@end

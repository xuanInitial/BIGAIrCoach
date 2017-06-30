//
//  AvPlayerViewController.h
//  AirCoach.acUser
//
//  Created by xuan on 15/11/27.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AvPlayerViewController : BaseViewController


@property (strong, nonatomic) NSArray *playlistARR;

@property(strong,nonatomic)NSString *isAudio;

@property(nonatomic)NSInteger AvplayerAllTimes;

@end

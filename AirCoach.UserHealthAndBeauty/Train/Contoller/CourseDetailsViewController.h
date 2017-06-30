//
//  CourseDetailsViewController.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/6.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "BaseViewController.h"

#import <AVFoundation/AVFoundation.h>

typedef void(^AlphaBlock)(CGFloat alpha);
@interface CourseDetailsViewController : BaseViewController
@property(nonatomic)NSInteger UrlID;


@property (nonatomic, copy) AlphaBlock alphaBlock;



@end

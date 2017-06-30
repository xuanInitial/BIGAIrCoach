//
//  NoticeModel.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/16.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject

@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *videoUrl;
@property(nonatomic,strong)NSString *videoDetail;

+(NSArray*)copyNoticeArr;

@end

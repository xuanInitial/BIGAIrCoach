//
//  CTAirCoachOss.h
//  AirCoach2.0
//
//  Created by wei on 16/1/26.
//  Copyright © 2016年 高静. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Header.h"
#import "TokenGet.h"
#import <AliyunOSSiOS/OSSService.h>
#import "BusinessAirCoach.h"
#import<UIKit/UIKit.h>
@interface CTAirCoachOss : NSObject<OSSCredentialProvider>



+(void)addPic:(UIImage*)pic PicName:(NSString*)picName;



@end

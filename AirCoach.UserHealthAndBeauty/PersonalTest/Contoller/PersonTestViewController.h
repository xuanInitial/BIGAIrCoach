//
//  PersonTestViewController.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/5/30.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"

@protocol WaitingForDelegate <NSObject>

-(void)setValueA:(NSString*)string;

@end


@interface PersonTestViewController : BaseViewController

@property(nonatomic)CGFloat labley;

@property(weak,nonatomic)id<WaitingForDelegate> B_delegate;

@end

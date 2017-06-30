//
//  TrainRefreshView.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/1.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol trainrefreshDelegate <NSObject>

-(void)refreshTrain;
-(void)jumpNoticPage;

@end


@interface TrainRefreshView : UIView

@property(nonatomic,strong)id<trainrefreshDelegate>trainDelegate;

-(void)hideTrainRefreshView;//隐藏视图
-(void)disPlayTrainRefreshView;//显示视图

@end

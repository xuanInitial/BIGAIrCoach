//
//  GHView.h
//  shouyeDemo
//
//  Created by wei on 16/10/24.
//  Copyright © 2016年 Aircoach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
typedef NS_ENUM(NSInteger, CardMoveDirection) {
    CardMoveDirectionNone,
    CardMoveDirectionLeft,
    CardMoveDirectionRight
};
typedef NS_ENUM(NSInteger, PlanType) {
    PlanPast,
    PlanFutrue
};

@protocol cardScorllViewDataSource <NSObject>

-(NSInteger)numberOfCards;
-(NSMutableArray*)contentOfCards;
-(UIView *)cardReuseView:(UIView *)reuseView atIndex:(NSInteger)index;
-(void)jumpTraining:(NSInteger)videoUrl;
-(void)jumpPastPlanAndFuturePlan:(NSInteger)videoUrl type:(PlanType)planType;//以前计划和未来计划
@end
@protocol cardScorllViewdelegate <NSObject>

- (void)updateCard:(UIView *)card withProgress:(CGFloat)progress direction:(CardMoveDirection)direction;
@end

@interface GHView : UIView

@property(nonatomic,strong)id<cardScorllViewDataSource>cardDataSource;
@property(nonatomic,strong)id<cardScorllViewdelegate>cardDataDelegate;
//计算view的位置
- (void)loadCard;
//卡片赋值方法
-(void)reloadCard;
@end

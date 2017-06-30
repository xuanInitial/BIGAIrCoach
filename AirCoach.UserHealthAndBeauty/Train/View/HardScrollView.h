//
//  HardScrollView.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/10/10.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "UIView+XMGExtension.h"

@protocol Acfeeldelegate <NSObject>

-(void)touchFeelbutton:(NSInteger)mytag;

@end

@interface HardScrollView : UIScrollView

@property(nonatomic,strong)UIView *firstView;

@property(nonatomic,strong)UIView *SecondView;

@property(nonatomic,strong)UIButton *NextBtn;

//点击代理
@property(nonatomic,strong)id<Acfeeldelegate>Acfeel;
-(void)setAcfeel:(id<Acfeeldelegate>)Acfeel;



@property(nonatomic)CGFloat MyW;

@property(nonatomic)CGFloat MyH;

@property(nonatomic,strong)UIButton *firstbtn;
@property(nonatomic,strong)UIButton *Sencondtbtn;
@property(nonatomic,strong)UIButton *Thirdbtn;



@end

//
//  AVEndViewController.h
//  AirCoach.acUser
//
//  Created by xuan on 15/12/21.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

//#import "MainViewController.h"
#import "BaseViewController.h"

@protocol BackDelegate <NSObject>

- (void)backCourseDetail;

@end

@interface AVEndViewController : BaseViewController


@property (weak, nonatomic) id<BackDelegate>delegate;

@property (strong, nonatomic) IBOutlet UILabel *wanchengLabel;

@property (strong, nonatomic) IBOutlet UILabel *kechengName;

@property (strong, nonatomic) IBOutlet UIButton *kunNanBtn;

- (IBAction)kunNanBtnClick:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *yiBanBtn;

- (IBAction)yiBanBtnClick:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *qingsongBtn;

- (IBAction)qingSongBtnClick:(UIButton *)sender;

- (IBAction)fenXiangBtnClick:(UIButton *)sender;




@property (strong, nonatomic) IBOutlet UIButton *fanHuiBtn;

- (IBAction)fanHuiBtnClick:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIView *bgWiterView;

@property (strong, nonatomic) IBOutlet UILabel *kunNanLabel;


@property (strong, nonatomic) IBOutlet UILabel *yiBanLabel;

@property (strong, nonatomic) IBOutlet UILabel *qingSongLabel;



@end

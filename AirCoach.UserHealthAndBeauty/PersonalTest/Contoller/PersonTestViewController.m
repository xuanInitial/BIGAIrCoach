//
//  PersonTestViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/5/30.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "PersonTestViewController.h"
#import "UIView+WomenTestView.h"
#import "ChartViewController.h"
#import "BusinessAirCoach.h"
#import "WYTDevicesTool.h"
#import "UILabel+TopAndBottom.h"

@interface PersonTestViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIScrollView *testScrollView;
//下一项按键
@property(nonatomic,strong)UIButton *NextBtn;
//取消按键
@property(nonatomic,strong)UIButton *CancelBtn;
//偏移量控制
@property(nonatomic)CGFloat MoveOffset;
@property(nonatomic,strong)UIView *weightView;
@property(nonatomic,strong)UIView *heatView;
@property(nonatomic,strong)UIView *bristView;
@property(nonatomic,strong)UIView *strentView;

@property(nonatomic,strong)UITextField *weightText;
@property(nonatomic,strong)UITextField *heatText;
@property(nonatomic,strong)UITextField *bristText;
@property(nonatomic,strong)UITextField *strentText;

@property(nonatomic,strong)UILabel *weightlabel;
@property(nonatomic,strong)UILabel *heatlabel;
@property(nonatomic,strong)UILabel *bristlabel;
@property(nonatomic,strong)UILabel *strentlabel;

@property(nonatomic,strong)UIView *PickView;

//底部标签
@property(nonatomic,strong)UILabel *allLabel;

@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *popBtn;
@property(nonatomic,strong)UIImageView *ClearImage;


@end

@implementation PersonTestViewController


- (BOOL)shouldAutorotate
{
    LRLog(@"让不让我旋转?");
    return YES;
}



-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dic = [BusinessAirCoach getUserCanMove];
    if (dic == nil)
    {
        NSDictionary *dic = @{@"isMove":@"See"};
        [BusinessAirCoach setUserCanMove:dic];
    }
    
    [self creatUI];
    
  
    
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return  UIStatusBarStyleLightContent;
}
-(void)creatUI
{

    
    _testScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_testScrollView];
    _testScrollView.bounces = NO;
    
    
    
    int i = 0;
    for (i = 0; i < 6; i++)
    {
        switch (i)
        {
            case 0:
            {
               
                UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                
                UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
                [_testScrollView addSubview:firstView];
                firstView.backgroundColor = [UIColor whiteColor];
                
                //背景图
                UIImageView *firstViewImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 0.65)];
                firstViewImage.image = [UIImage imageNamed:@"体测-背景图"];
                [firstView addSubview:firstViewImage];
                firstViewImage.userInteractionEnabled = YES;
//                firstViewImage.contentMode = UIViewContentModeScaleAspectFill;
//                firstViewImage.clipsToBounds = YES;
                
                //标题
                UILabel *itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 - 50 ,20, 100, 44)];
                itemLabel.text = @"体能测试";
                itemLabel.font = font;
                itemLabel.textColor = [UIColor whiteColor];
                itemLabel.textAlignment = 1;
                [firstViewImage addSubview:itemLabel];

                
                //消失按钮

                //返回键
                _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _popBtn.frame = CGRectMake(SCREENWIDTH - 30, 33, 60, 60);
                [_popBtn addTarget:self action:@selector(backpage) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:_popBtn];
                [self.view bringSubviewToFront:_popBtn];
                //返回图标
                _ClearImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 36, 33, 21, 21)];
                _ClearImage.image = [UIImage imageNamed:@"白关闭"];
                [self.view addSubview:_ClearImage];
                [self.view bringSubviewToFront:_ClearImage];

                _popBtn.center = _ClearImage.center;

                UILabel *item = [[UILabel alloc]initWithFrame:CGRectMake(0, firstViewImage.y + firstViewImage.height + 29, SCREENWIDTH, 18)];
                item.text = @"我们将辅助您记录以下数据";
                item.font = [UIFont systemFontOfSize:19];
                item.textAlignment = 1;
                item.textColor = Subcolor;
                [firstView addSubview:item];
                
                //8个控件
                
                //体重
                UIImageView *weightImage = nil;
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                   weightImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, item.y + item.height + 16, 30, 30)];
                }
                else
                {
                   weightImage = [[UIImageView alloc]initWithFrame:CGRectMake(50, item.y + item.height + 16, 30, 30)];
                }
                
                weightImage.image = [UIImage imageNamed:@"体重"];
                [firstView addSubview:weightImage];
                UILabel *weightlable = [[UILabel alloc]initWithFrame:CGRectMake(weightImage.x + 30 + 10, weightImage.y + 5, 35, 17)];
                weightlable.text = @"体重";
                weightlable.font = [UIFont systemFontOfSize:17];
                weightlable.textAlignment = 1;
                weightlable.textColor = Subcolor;
                [firstView addSubview:weightlable];
                
                //屏息时间
                UIImageView *BristImage = nil;
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    BristImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, weightImage.y + weightImage.height + 3 , 30, 30)];
                }
                else
                {
                    BristImage = [[UIImageView alloc]initWithFrame:CGRectMake(50, weightImage.y + weightImage.height + 3 , 30, 30)];
                }

                
                BristImage.image = [UIImage imageNamed:@"屏息时间"];
                [firstView addSubview:BristImage];
                UILabel *Bristlable = [[UILabel alloc]initWithFrame:CGRectMake(BristImage.x + 30 + 10, BristImage.y + 5, 72, 17)];
                Bristlable.text = @"屏息时间";
                Bristlable.font = [UIFont systemFontOfSize:17];
                Bristlable.textAlignment = 1;
                Bristlable.textColor = Subcolor;
                [firstView addSubview:Bristlable];
                
                
                //心率
                UILabel *Inerlable = nil;
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    Inerlable = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 72 - 25, item.y + item.height + 21, 72, 17)];
                }
                else
                {
                    Inerlable = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 72 - 50, item.y + item.height + 21, 72, 17)];
                }
                
               
                Inerlable.text = @"平静心率";
                Inerlable.font = [UIFont systemFontOfSize:17];
                Inerlable.textAlignment = 1;
                Inerlable.textColor = Subcolor;
                [firstView addSubview:Inerlable];
                UIImageView *InerImage = [[UIImageView alloc]initWithFrame:CGRectMake(Inerlable.x - 10 - 25, item.y + item.height + 16 , 30, 30)];
                InerImage.image = [UIImage imageNamed:@"平静心率"];
                [firstView addSubview:InerImage];
                
                //仰卧起坐
                UILabel *strengthlable = [[UILabel alloc]initWithFrame:CGRectMake(Inerlable.x, InerImage.y + InerImage.height + 8, 72, 17)];
                strengthlable.text = @"仰卧起坐";
                strengthlable.font = [UIFont systemFontOfSize:17];
                strengthlable.textAlignment = 1;
                strengthlable.textColor = Subcolor;
                [firstView addSubview:strengthlable];
                UIImageView *strengthImage = [[UIImageView alloc]initWithFrame:CGRectMake(Inerlable.x - 10 - 25, InerImage.y + InerImage.height + 3, 30, 30)];
                strengthImage.image = [UIImage imageNamed:@"仰卧起坐"];
                [firstView addSubview:strengthImage];
                
                
                //开始测试键
                
                UIButton *Testbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [firstView addSubview:Testbtn];
                [Testbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(firstView.mas_bottom);
                    make.left.equalTo(firstView.mas_left);
                    make.right.equalTo(firstView.mas_right);
                    make.height.equalTo(@50);
                }];
                Testbtn.backgroundColor = SegementColor;
                [Testbtn setTitle:@"开始" forState:UIControlStateNormal];
                [Testbtn addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [Testbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                
  
            }
                break;
            case 1:
            {
                _weightView = [UIView ViewWithFrameByCategory:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT) MianView:_testScrollView trainPic:@"体重-背景图" order:@"填写您的体重" Num:@"kg" detail:YES itemName:nil jieshi:@"请在保持身体平稳的情况下测量体重"];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [_weightView addGestureRecognizer:tap];
                
                _weightText = [_weightView viewWithTag:1000];
                _weightText.keyboardType = UIKeyboardTypeDecimalPad;
                
                
            }
                break;
            case 2:
            {
               _heatView = [UIView ViewWithFrameByCategory:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT) MianView:_testScrollView trainPic:@"平静心率-背景图" order:@"填写您的心率" Num:@"次/分" detail:NO itemName:nil jieshi:@"请计算您在平静状态下每分钟的心跳次数"];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [_heatView addGestureRecognizer:tap];
                _heatText = [_heatView viewWithTag:1000];
            }
                break;
            case 3:
            {
                _bristView = [UIView ViewWithFrameByCategory:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT) MianView:_testScrollView trainPic:@"屏息时间-背景图" order:@"填写您的屏息时间" Num:@"秒" detail:NO itemName:nil jieshi:@"请计算1次吸气后，屏息与呼气的时间之和"];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [_bristView addGestureRecognizer:tap];
                _bristText = [_bristView viewWithTag:1000];
            }
                break;
            case 4:
            {
                _strentView = [UIView ViewWithFrameByCategory:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT) MianView:_testScrollView trainPic:@"仰卧起坐-背景图" order:@"填写您的仰卧起坐个数" Num:@"个/分" detail:NO itemName:nil jieshi:@"请仰卧在地板或瑜伽垫上，双膝弯曲，双手抱头进行仰卧起坐，并计算每分钟个数"];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [_strentView addGestureRecognizer:tap];
                _strentText = [_strentView viewWithTag:1000];
            }
                break;
            case 5:
            {
                
            
                UIImageView *DoneView = [[UIImageView alloc]initWithFrame:CGRectMake(i * SCREENWIDTH, 0,  SCREENWIDTH, SCREENHEIGHT)];
                DoneView.image = [UIImage imageNamed:@"完成体测-背景图"];
                [_testScrollView addSubview:DoneView];
                DoneView.userInteractionEnabled = YES;
                UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                
                //标题
                UILabel *itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 - 50 ,20, 100, 44)];
                //itemLabel.text = @"完成检测";
                itemLabel.font = font;
                itemLabel.textColor = [UIColor whiteColor];
                itemLabel.textAlignment = 1;
                [DoneView addSubview:itemLabel];
                
                //白框
                UIView *whiteView = [UIView new];
                whiteView.backgroundColor = [UIColor whiteColor];
                [DoneView addSubview:whiteView];
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(DoneView.mas_left).offset(15);
                        make.right.equalTo(DoneView.mas_right).offset(-15);
                        make.top.equalTo(DoneView.mas_top).offset(120);
                        make.height.equalTo(@374);
                    }];
                }
                else
                {
                    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(DoneView.mas_left).offset(15);
                        make.right.equalTo(DoneView.mas_right).offset(-15);
                        make.top.equalTo(DoneView.mas_top).offset(120);
                        make.height.equalTo(@414);
                    }];
                }
                
                whiteView.layer.cornerRadius = 4;
                whiteView.layer.masksToBounds = YES;
                
                //头像
                UIImageView *UserHead = [UIImageView new];
                [DoneView addSubview:UserHead];
                [UserHead mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@74);
                    make.height.equalTo(@74);
                    make.centerX.equalTo(whiteView.mas_centerX);
                    make.top.equalTo(whiteView.mas_top).offset(-37);
                }];
                UserHead.layer.cornerRadius = 37;
                UserHead.layer.masksToBounds = YES;
                UserHead.layer.borderWidth = 3;
                UserHead.layer.borderColor = [UIColor whiteColor].CGColor;
                [UserHead sd_setImageWithURL:[NSURL URLWithString:[BusinessAirCoach getHeadPortrait]] placeholderImage:[UIImage imageNamed:@"我的.jpeg"]];
                
                //主体控件
                
                //8个控件
                
                //体重
                UIImageView *weightImage = nil;
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    weightImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, 37 + 12, 30, 30)];
                }
                else
                {
                    weightImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 37 + 30, 30, 30)];
                }
                
                weightImage.image = [UIImage imageNamed:@"体重"];
                [whiteView addSubview:weightImage];
                UILabel *weightlable = [[UILabel alloc]initWithFrame:CGRectMake(weightImage.x + 30 + 12, weightImage.y + 5, 35, 17)];
                weightlable.text = @"体重";
                weightlable.font = [UIFont systemFontOfSize:17];
                weightlable.textAlignment = 1;
                weightlable.textColor = Subcolor;
                [whiteView addSubview:weightlable];
                
                //体重数字及单位
                _weightlabel = [UILabel new];
                [whiteView addSubview:_weightlabel];
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    [_weightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(whiteView.mas_left).offset(49);
                        make.top.equalTo(weightImage.mas_bottom).offset(10);
                        make.width.lessThanOrEqualTo(@55);
                        
                        make.height.equalTo(@25);
                    }];
                }
                else
                {
                    [_weightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(whiteView.mas_left).offset(66);
                        make.top.equalTo(weightImage.mas_bottom).offset(10);
                        make.width.lessThanOrEqualTo(@55);
                        make.height.equalTo(@25);
                    }];
                }
                _weightlabel.textColor = SegementColor;
                _weightlabel.font = [UIFont systemFontOfSize:25];
                
                
                //体重单位
                UILabel *weightDan = [UILabel new];
                [whiteView addSubview:weightDan];
                [weightDan mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_weightlabel.mas_right).offset(6);
                    make.top.equalTo(weightImage.mas_bottom).offset(16);
                    make.width.equalTo(@30);
                    make.height.equalTo(@19);
                }];
                weightDan.text = @"kg";
                weightDan.textColor = SegementColor;
                
                
                //屏息时间
                UIImageView *BristImage = nil;
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    BristImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, weightImage.y + weightImage.height + 58 , 30, 30)];
                }
                else
                {
                    BristImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, weightImage.y + weightImage.height + 78 , 30, 30)];
                }
                BristImage.image = [UIImage imageNamed:@"屏息时间"];
                [whiteView addSubview:BristImage];
                UILabel *Bristlable = [[UILabel alloc]initWithFrame:CGRectMake(BristImage.x + 30 + 12, BristImage.y + 5, 72, 17)];
                Bristlable.text = @"屏息时间";
                Bristlable.font = [UIFont systemFontOfSize:17];
                Bristlable.textAlignment = 1;
                Bristlable.textColor = Subcolor;
                [whiteView addSubview:Bristlable];
                
                
                _bristlabel = [UILabel new];
                [whiteView addSubview:_bristlabel];
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    [_bristlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(whiteView.mas_left).offset(49);
                        make.top.equalTo(BristImage.mas_bottom).offset(10);
                        make.width.lessThanOrEqualTo(@55);
                        make.height.equalTo(@25);
                    }];
                }
                else
                {
                    [_bristlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(whiteView.mas_left).offset(66);
                        make.top.equalTo(BristImage.mas_bottom).offset(10);
                        make.width.lessThanOrEqualTo(@55);
                        make.height.equalTo(@25);
                    }];
                }
                _bristlabel.textColor = SegementColor;
                _bristlabel.font = [UIFont systemFontOfSize:25];
                
                
                //屏息单位
                UILabel *bristDan = [UILabel new];
                [whiteView addSubview:bristDan];
                [bristDan mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_bristlabel.mas_right).offset(6);
                    make.top.equalTo(BristImage.mas_bottom).offset(15);
                    make.width.equalTo(@30);
                    make.height.equalTo(@19);
                }];
                bristDan.text = @"秒";
                bristDan.textColor = SegementColor;

                
                
                
                
                //心率
                UILabel *Inerlable = nil;
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    Inerlable = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 30 - 72 - 18, 37 + 12 + 5, 72, 17)];
                }
                else
                {
                    Inerlable = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 30 - 72 - 35,  37 + 30 + 5, 72, 17)];
                }
                
                
                Inerlable.text = @"平静心率";
                Inerlable.font = [UIFont systemFontOfSize:17];
                Inerlable.textAlignment = 1;
                Inerlable.textColor = Subcolor;
                [whiteView addSubview:Inerlable];
                UIImageView *InerImage = nil;
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                   InerImage = [[UIImageView alloc]initWithFrame:CGRectMake(Inerlable.x - 12 - 30, 37 + 12 , 30, 30)];
                }
                else
                {
                   InerImage = [[UIImageView alloc]initWithFrame:CGRectMake(Inerlable.x - 12 - 30, 37 + 30 , 30, 30)];
                }
                
                InerImage.image = [UIImage imageNamed:@"平静心率"];
                [whiteView addSubview:InerImage];
                
                
                _heatlabel = [UILabel new];
                [whiteView addSubview:_heatlabel];
                
                [_heatlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(InerImage.mas_right).offset(1);
                        make.top.equalTo(InerImage.mas_bottom).offset(10);
                        make.width.lessThanOrEqualTo(@55);
                        make.height.equalTo(@25);
                    }];
                _heatlabel.textColor = SegementColor;
                _heatlabel.font = [UIFont systemFontOfSize:25];
                
                
                //屏息单位
                UILabel *heatDan = [UILabel new];
                [whiteView addSubview:heatDan];
                [heatDan mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_heatlabel.mas_right).offset(6);
                    make.top.equalTo(InerImage.mas_bottom).offset(16);
                    make.width.equalTo(@50);
                    make.height.equalTo(@14);
                }];
                heatDan.text = @"次/分";
                heatDan.textColor = SegementColor;
                
                
                //仰卧起坐
                UILabel *strengthlable = nil;
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    strengthlable = [[UILabel alloc]initWithFrame:CGRectMake(Inerlable.x, InerImage.y + InerImage.height + 58 + 5, 72, 17)];
                }
                else
                {
                    strengthlable = [[UILabel alloc]initWithFrame:CGRectMake(Inerlable.x, InerImage.y + InerImage.height + 78 + 5, 72, 17)];
                }
                
                strengthlable.text = @"仰卧起坐";
                strengthlable.font = [UIFont systemFontOfSize:17];
                strengthlable.textAlignment = 1;
                strengthlable.textColor = Subcolor;
                [whiteView addSubview:strengthlable];
                UIImageView *strengthImage = [[UIImageView alloc]initWithFrame:CGRectMake(Inerlable.x - 12 - 30, strengthlable.y - 5, 30, 30)];
                strengthImage.image = [UIImage imageNamed:@"仰卧起坐"];
                [whiteView addSubview:strengthImage];

                _strentlabel = [UILabel new];
                [whiteView addSubview:_strentlabel];
                
                [_strentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(strengthImage.mas_right).offset(1);
                    make.top.equalTo(strengthImage.mas_bottom).offset(10);
                    make.width.lessThanOrEqualTo(@55);
                    make.height.equalTo(@25);
                }];
                _strentlabel.textColor = SegementColor;
                _strentlabel.font = [UIFont systemFontOfSize:25];
                
                
                //力量单位
                UILabel *StrengthDan = [UILabel new];
                [whiteView addSubview:StrengthDan];
                [StrengthDan mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_strentlabel.mas_right).offset(6);
                    make.top.equalTo(strengthImage.mas_bottom).offset(16);
                    make.width.equalTo(@50);
                    make.height.equalTo(@14);
                }];
                StrengthDan.text = @"个/分";
                StrengthDan.textColor = SegementColor;

                
                //建议及线
                UILabel *jianyi = [UILabel new];
                [whiteView addSubview:jianyi];
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                   [jianyi mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.centerX.equalTo(whiteView.mas_centerX);
                       make.top.equalTo(StrengthDan.mas_bottom).offset(50);
                       make.width.equalTo(@35);
                       make.height.equalTo(@17);
                   }];
                }
                else
                {
                    [jianyi mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(whiteView.mas_centerX);
                        make.top.equalTo(Bristlable.mas_bottom).offset(78);
                        make.width.equalTo(@35);
                        make.height.equalTo(@17);
                    }];
                }

                jianyi.text = @"提示";
                jianyi.font = [UIFont systemFontOfSize:17];
                jianyi.textColor = Subcolor;
                
                //两条线
                UIView *firtViewLine = [UIView new];
                [whiteView addSubview:firtViewLine];
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    [firtViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(jianyi.mas_left).offset(-13);
                        make.centerY.equalTo(jianyi.mas_centerY);
                        make.width.equalTo(@100);
                        make.height.equalTo(@1);
                    }];
                    

                }
                else
                {
                    [firtViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(jianyi.mas_left).offset(-13);
                        make.centerY.equalTo(jianyi.mas_centerY);
                        make.width.equalTo(@119);
                        make.height.equalTo(@1);
                    }];
                
                }
                UIView *SedViewLine = [UIView new];
                [whiteView addSubview:SedViewLine];
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    [SedViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(jianyi.mas_right).offset(13);
                        make.centerY.equalTo(jianyi.mas_centerY);
                        make.width.equalTo(@100);
                        make.height.equalTo(@1);
                    }];
                    
                    
                }
                else
                {
                    [SedViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(jianyi.mas_right).offset(13);
                        make.centerY.equalTo(jianyi.mas_centerY);
                        make.width.equalTo(@119);
                        make.height.equalTo(@1);
                    }];
                    
                }

                firtViewLine.backgroundColor = xiLine;
                SedViewLine.backgroundColor = xiLine;
                
                if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
                {
                    //三行字
                    for (int i = 0; i < 1; i++)
                    {
                        UILabel *word = [UILabel new];
                        [whiteView addSubview:word];
                        [word mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(@(SCREENWIDTH - 30));
                            make.height.equalTo(@12);
                            make.top.equalTo(jianyi.mas_bottom).offset(26 + i * (12 + 6));
                            make.left.equalTo(whiteView.mas_left);
                        }];
                        
                        word.text = @"建议您每周至少记录一次身体数据。";
                        word.textColor = LableColor;
                        word.font = [UIFont systemFontOfSize:12];
                        word.textAlignment = 1;
                    }
 
                }
                else
                {
                    //三行字
                    for (int i = 0; i < 1; i++)
                    {
                        UILabel *word = [UILabel new];
                        [whiteView addSubview:word];
                        [word mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(@(SCREENWIDTH - 30));
                            make.height.equalTo(@14);
                            make.top.equalTo(jianyi.mas_bottom).offset(26 + i * (14 + 7));
                            make.left.equalTo(whiteView.mas_left);
                        }];
                        
                        word.text = @"建议您每周至少记录一次身体数据。";
                        word.textColor = LableColor;
                        word.font = [UIFont systemFontOfSize:14];
                        word.textAlignment = 1;
                    }

                }

                
                //跳转数据图表按钮
                UIButton *Testbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [DoneView addSubview:Testbtn];
                [Testbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(DoneView.mas_bottom);
                    make.left.equalTo(DoneView.mas_left);
                    make.right.equalTo(DoneView.mas_right);
                    make.height.equalTo(@50);
                }];
                Testbtn.backgroundColor = SegementColor;
                [Testbtn setTitle:@"完成" forState:UIControlStateNormal];
                [Testbtn addTarget:self action:@selector(backpage) forControlEvents:UIControlEventTouchUpInside];
                [Testbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                
                
            }
            
            default:
                break;
        }
    }
    
    
 
    _testScrollView.contentSize = CGSizeMake(i * SCREENWIDTH, SCREENHEIGHT);
    _testScrollView.pagingEnabled = YES;
    
    
    //下一项按钮
    _NextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _NextBtn.frame = CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50);
    [_NextBtn setTitle:@"下一项" forState:UIControlStateNormal];
    [_NextBtn setBackgroundColor:SegementColor];
    [self.view addSubview:_NextBtn];
    [self.view bringSubviewToFront:_NextBtn];
    _NextBtn.hidden = YES;
    [_NextBtn addTarget:self action:@selector(AutoMove) forControlEvents:UIControlEventTouchUpInside];
    
    
   
    
    _testScrollView.delegate = self;
    _testScrollView.scrollEnabled = NO;
    
    //键盘的弹出收回通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    NSDictionary *dic = [BusinessAirCoach getUserCanMove];
    if ([dic[@"isMove"] isEqualToString:@"See"])
    {
        //灰度蒙板
        _PickView = [[UIView alloc]init];
        _PickView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.view addSubview:_PickView];
        [self.view bringSubviewToFront:_PickView];
        [_PickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
        
        
        UIView *view1 = [[UIView alloc]init];
        [_PickView addSubview:view1];
        
        view1.backgroundColor = [UIColor whiteColor];
        view1.layer.cornerRadius = 5;
        view1.layer.masksToBounds = YES;
        
        UILabel *Item = [[UILabel alloc]init];
        Item.text = @"为了数据的准确与您的安全，我们建议您在顺产42天（剖腹产则为52天）后再记录身体数据";
        [view1 addSubview:Item];
        
        //文字居中
        Item.textAlignment = 1;
        Item.textColor = Subcolor;
        Item.font = [UIFont systemFontOfSize:15];
        Item.numberOfLines = 0;
        CGSize size;
        if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
        {
            size = [Item.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREENWIDTH - 80, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            
        }
        else
        {
            size = [Item.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREENWIDTH - 100, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        }

        
        NSMutableAttributedString *str = [self TheLabletext:Item.text];
        Item.attributedText = str;
        CGFloat strNum = ([Item numberOfText] - 1)  * 6 + size.height;
        [Item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view1.mas_top).offset(26);
            make.left.equalTo(view1.mas_left).offset(20);
            make.right.equalTo(view1.mas_right).offset(-20);
            make.height.equalTo(@(strNum));
        }];
        
        [Item sizeToFit];
        
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_PickView.mas_centerX);
            make.centerY.equalTo(_PickView.mas_centerY);
            make.height.equalTo(@(152 + strNum));
            make.width.equalTo(@(SCREENWIDTH - 60));
        }];
        //确定按钮
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitle:@"我知道了" forState:UIControlStateNormal];
       [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn2.font = [UIFont systemFontOfSize:17];
        [view1 addSubview:btn2];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
        if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
        {
            [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view1.mas_right).offset(-27);
                make.top.equalTo(Item.mas_bottom).offset(21);
                make.height.equalTo(@44);
                make.left.equalTo(view1.mas_left).offset(27);
            }];
        }
        else
        {
            [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view1.mas_right).offset(-44);
                make.top.equalTo(Item.mas_bottom).offset(21);
                make.height.equalTo(@44);
                make.left.equalTo(view1.mas_left).offset(44);
            }];
        }

        
        
        [btn2 addTarget:self action:@selector(dissmissTheMainView) forControlEvents:UIControlEventTouchUpInside];
        
        
       
        
        
        UILabel *tishi = [UILabel new];
        [view1 addSubview:tishi];
        [tishi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(Item.mas_right);
            make.top.equalTo(btn2.mas_bottom).offset(17);
            make.height.equalTo(@14);
            make.width.equalTo(@60);
        }];
        tishi.text = @"不再提示";
        tishi.font = [UIFont systemFontOfSize:14];
        tishi.textColor = LableColor;
        
        
        //不再提示按钮
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"未勾选"] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [view1 addSubview:btn1];
        
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tishi.mas_left).mas_offset(-9);
            make.top.equalTo(btn2.mas_bottom).offset(18);
            make.height.equalTo(@13);
            make.width.equalTo(@13);
        }];
        
        [btn1 addTarget:self action:@selector(dissmissTheView:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }

}
//行距设置
-(NSMutableAttributedString*)TheLabletext:(NSString*)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 6;  //行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}
- (void)starButtonClicked:(id)sender
{
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(AutoMove) object:sender];
    [self performSelector:@selector(AutoMove) withObject:sender afterDelay:0.2f];
}
-(void)dissmissTheView:(UIButton*)sender
{
    
    
    sender.selected = !sender.selected;
    if (sender.selected == YES)
    {
        NSDictionary *dic = @{@"isMove":@"NoSee"};
        [BusinessAirCoach setUserCanMove:dic];
    }
    else
    {
        NSDictionary *dic = @{@"isMove":@"See"};
        [BusinessAirCoach setUserCanMove:dic];
    }
    
}
-(void)dissmissTheMainView
{
    [_PickView removeFromSuperview];
}
-(void)jumpChart
{
  [self presentViewController:[ChartViewController new] animated:YES completion:nil];
}

//键盘出现
-(void)keyboardWillShow:(NSNotification*)note
{
    NSLog(@"%@",note.userInfo);
    CGRect endframe = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationOptions option = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        _weightView.y = -(SCREENHEIGHT - endframe.origin.y);
        _bristView.y =-(SCREENHEIGHT -  endframe.origin.y);
        _heatView.y = -(SCREENHEIGHT - endframe.origin.y);
        _strentView.y = -(SCREENHEIGHT - endframe.origin.y);
    } completion:nil];
    [self.view layoutIfNeeded];
    
    
}
//检测是否有汉字
-(BOOL)validatefloatNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
-(BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

//键盘消失
-(void)keyboardWillHide:(NSNotification*)note
{
    LRLog(@"%@",note.userInfo);
    //CGRect endframe = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationOptions option = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        _weightView.y = 0;
        _bristView.y = 0;
        _heatView.y = 0;
        _strentView.y = 0;
    } completion:nil];
    [self.view layoutIfNeeded];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if (_testScrollView.contentOffset.x == SCREENWIDTH||_testScrollView.contentOffset.x ==  2 *SCREENWIDTH||_testScrollView.contentOffset.x ==  3 *SCREENWIDTH||_testScrollView.contentOffset.x ==  4 *SCREENWIDTH)
   {
       _NextBtn.enabled = YES;
       LRLog(@"你好------");
   }
    
    if (scrollView.contentOffset.x >= SCREENWIDTH && scrollView.contentOffset.x <= SCREENWIDTH * 4) {
        _NextBtn.hidden = NO;
        _CancelBtn.hidden = NO;
    }
    else
    {
        _NextBtn.hidden = YES;
        _CancelBtn.hidden = YES;
    }
    LRLog(@"-----%d",_NextBtn.enabled);
}


-(void)AutoMove
{
   
    
    if (_testScrollView.contentOffset.x == SCREENWIDTH)
    {
        if (_weightText.text.length == 0 || !(_weightText.text.integerValue >= 30 && _weightText.text.integerValue <=150))
        {
            [self clickMe:@"请填写正确的数值"];
            return;
        }
        else
        {
            if ([self validatefloatNumber:_weightText.text] == YES)
            {
               
                _MoveOffset += SCREENWIDTH;

                _NextBtn.enabled = NO;
                [_testScrollView scrollRectToVisible:CGRectMake(_MoveOffset, 0, SCREENWIDTH, SCREENHEIGHT) animated:YES];
            }
            else
            {
                [self clickMe:@"请填写正确的数值"];
            }
            
            
            
        }
    }
    else if (_testScrollView.contentOffset.x == SCREENWIDTH * 2)
    {
        if (_heatText.text.length == 0|| !(_heatText.text.integerValue >= 30 && _heatText.text.integerValue <=180))
        {
            [self clickMe:@"请填写正确的数值"];
            return;
        }
        else
        {
           
            if ([self validateNumber:_heatText.text] == YES)
            {
                
                _MoveOffset += SCREENWIDTH;

                _NextBtn.enabled = NO;
                [_testScrollView scrollRectToVisible:CGRectMake(_MoveOffset, 0, SCREENWIDTH, SCREENHEIGHT) animated:YES];

            }else
            {
               [self clickMe:@"请填写正确的数值"];
            }
            
        }
    }
    else if (_testScrollView.contentOffset.x == SCREENWIDTH * 3) {
        if (_bristText.text.length == 0|| !(_bristText.text.integerValue >= 0 && _bristText.text.integerValue <=300))
        {
            [self clickMe:@"请填写正确的数值"];
            return;
        }
        else
        {
           
            if ([self validateNumber:_bristText.text] == YES) {
                
                _MoveOffset += SCREENWIDTH;
                _NextBtn.enabled = NO;

                _NextBtn.enabled = NO;
                [_testScrollView scrollRectToVisible:CGRectMake(_MoveOffset, 0, SCREENWIDTH, SCREENHEIGHT) animated:YES];
                 [_NextBtn setTitle:@"完成" forState:UIControlStateNormal];

            }
            else
            {
               [self clickMe:@"请填写正确的数值"];
            }
            
            
            
        }
    }
    else if (_testScrollView.contentOffset.x == SCREENWIDTH * 4) {
        
       
        
        if (_strentText.text.length == 0||! (_strentText.text.integerValue >= 0 && _strentText.text.integerValue <=100))
        {
            [self clickMe:@"请填写正确的数值"];
            return;
        }
        else
        {
            /*'weight' => integer
            'heart_rate' => integer
            'hold_breath' => integer
            'strength' => integer*/
            
            
            if ([self validateNumber:_strentText.text] == YES) {
                [BusinessAirCoach JugedToken];
                if ([[BusinessAirCoach getAlllabel] isEqualToString:@"CanUse"])
                {
                    //token没过期 开始刷新
                    [self submitTestData];
                }
                else
                {
                    //接收到通知 开始刷新
                    __weak typeof(self) weakSelf = self;
                    __block __weak id gpsObserver;
                    gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                        [weakSelf submitTestData];
                        [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
                    }];
                    
                }
                //赋值
                _weightlabel.text = _weightText.text;
                _bristlabel.text = _bristText.text;
                _heatlabel.text = _heatText.text;
                _strentlabel.text = _strentText.text;
            }
            
            else
            {
               [self clickMe:@"请填写正确的数值"];
            }
            
            
        }
    }
    else
    {
        
        _bottomView.hidden = YES;
        _MoveOffset += SCREENWIDTH;
        
        _NextBtn.enabled = NO;
        [_testScrollView scrollRectToVisible:CGRectMake(_MoveOffset, 0, SCREENWIDTH, SCREENHEIGHT) animated:YES];
    }
    
   
    
    
}
-(void)submitTestData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeCustom];
    NSDictionary *dic = @{@"weight":_weightText.text,
                          @"heart_rate":_heatText.text,
                          @"hold_breath":_bristText.text,
                          @"strength":_strentText.text
                          };
    
    [[HttpsRefreshNetworking Networking] POST:CHECKING parameters:dic success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        if ([statusCode isEqualToString:@"200"])
        {
            
            NSLog(@"%@",responseObject);
            @try {
                //存储用户体侧时间
                NSDictionary *dic = @{@"UserTime":[responseObject objectForKey:@"created_at"]};
                [BusinessAirCoach setUserTestTime:dic];
                
                [SVProgressHUD dismiss];
                
            } @catch (NSException *exception) {
                
                LRLog(@"解析失败");
                NSDictionary *dic = @{@"UserTime":[NSString stringWithFormat:@"%@",[NSDate date]]};
                [BusinessAirCoach setUserTestTime:dic];
                
                [SVProgressHUD dismiss];
            }
            _popBtn.hidden = YES;
            _ClearImage.hidden = YES;
            
            
            _MoveOffset += SCREENWIDTH;
            if (_MoveOffset > 5 * SCREENWIDTH) {
                _MoveOffset = 5 * SCREENWIDTH;
            }
            [UIView animateWithDuration:0.5 animations:^{
                [_testScrollView setContentOffset:CGPointMake(_MoveOffset, 0)];
            }];
        }
        
        
    } failure:^(NSDictionary *allHeaders,NSError *error, id statusCode) {
        if ([allHeaders objectForKey:@"Authorization"]) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Authorization"];
            [BusinessAirCoach setUserAuthorization:[allHeaders objectForKey:@"Authorization"]];
        }
#pragma mark---请求失败的时候获取返回参数
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSString *str = serializedData[@"error"];
        
        if (str != nil && [str isEqualToString:@"duplicate_submit"])
        {
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"一天只能填写一次哦~!"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
           
            [self performSelector:@selector(backpage) withObject:nil afterDelay:0.6];
        }
        else
        {
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
        }
        
        
    }];
 
}
-(void)backpage
{
    
    if ([self.B_delegate respondsToSelector:@selector(setValueA:)])
    {
        [self.B_delegate setValueA:@"1"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    
    return YES;
    
}
-(void)dismissKeyboard:(UITapGestureRecognizer*)tap
{
    UITextField *mytextField = [tap.view viewWithTag:1000];
    double i = _weightText.text.doubleValue;
    _weightText.text = [NSString stringWithFormat:@"%.1f",i];
    
    
    
    
    
    

    [mytextField resignFirstResponder];
}
-(void)clickMe:(NSString*)message{
    
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
    
}

-(void)dealloc
{
    @try
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception)
    {
        
    };
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

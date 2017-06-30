//
//  UserPlanDetailViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/7/25.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "UserPlanDetailViewController.h"
#import "PlanDetailDayTableViewCell.h"
#import "DoctorDetailTableViewCell.h"
#import "StartViewController.h"
#import "Cur_planModel.h"
#import "planProgress.h"
@interface UserPlanDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIImageView *header;
@property(nonatomic,strong)UILabel *planName;
@property(nonatomic,strong)Cur_planModel *planDetail;
//当前计划训练的次数
@property(nonatomic,strong)NSArray *planDoneTimes;

@property(nonatomic,strong)NSMutableArray *UserTimes;

@end

@implementation UserPlanDetailViewController
-(NSMutableArray *)UserTimes
{
    if (!_UserTimes)
    {
        _UserTimes = [NSMutableArray array];
    }
    return _UserTimes;
}
- (BOOL)shouldAutorotate
{
    NSLog(@"让不让我旋转?");
    return NO;
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
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 187, SCREENWIDTH, SCREENHEIGHT - 187 + 10) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.backgroundColor = tableViewColor;
    [self.tableview registerClass:[PlanDetailDayTableViewCell class] forCellReuseIdentifier:@"PlanDetailDay"];
    [self.tableview registerClass:[DoctorDetailTableViewCell class] forCellReuseIdentifier:@"DoctorDetail"];
    
    
    
    
    _header = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 187)];
    [_header sd_setImageWithURL:[NSURL URLWithString:_planBackgroud] placeholderImage:[UIImage imageNamed:@"未显示状态"]];
    _header.contentMode = UIViewContentModeScaleAspectFill;
    _header.clipsToBounds = YES;
    //遮罩
    UIView *headerBlur = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 187)];
    [_header addSubview:headerBlur];
    headerBlur.backgroundColor = [UIColor blackColor];
    headerBlur.alpha = 0.3;
    
    
    
    //返回键
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.frame = CGRectMake(SCREENWIDTH - 30, 33, 60, 60);
    [popBtn addTarget:self action:@selector(backPlanDetail) forControlEvents:UIControlEventTouchUpInside];
    [_header addSubview:popBtn];
    
    //返回图标
    UIImageView *ClearImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 36, 33, 21, 21)];
    ClearImage.image = [UIImage imageNamed:@"白关闭"];
    [_header addSubview:ClearImage];
    popBtn.center = ClearImage.center;
    _header.userInteractionEnabled = YES;
    
    [self.view addSubview:_header];
    
    //计划名称
    _planName = [[UILabel alloc]initWithFrame:CGRectMake(48, 77, SCREENWIDTH - 96, 95)];
    [_header addSubview:_planName];
    _planName.textColor = [UIColor whiteColor];
    _planName.numberOfLines = 0;
    _planName.text = _planNameTs;
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    _planName.font = font;
    NSMutableAttributedString *str = [self TheLabletext:_planName.text];
    _planName.attributedText = str;
    
    [self SetlableShadow:_planName];
    
    //判断token是否过期
    [BusinessAirCoach JugedToken];
    if ([[BusinessAirCoach getAlllabel] isEqualToString:@"CanUse"])
    {
        //token没过期 开始刷新
        [self loadData];
    }
    else
    {
        //接收到通知 开始刷新
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RequstAllready" object:nil];
        __weak typeof(self) weakSelf = self;
        __block __weak id gpsObserver;
        gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf loadData];
            [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
        }];
        
    }

   
    
    
}
- (void)loadData{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeCustom];
    [[HttpsRefreshNetworking  Networking] GET:[NSString stringWithFormat:PLANSHOW,(long)_planId] parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        
        //写入刷新时间
        [BusinessAirCoach setTrainShuaxuinTime:[NSDate date]];
        
        NSLog(@"%@",responseObject);
        @try
        {
            _planDetail = [Cur_planModel mj_objectWithKeyValues:responseObject];
            _planDoneTimes = [planProgress mj_objectArrayWithKeyValuesArray:_planDetail.progresses];
            for (int i = 0; i < _planDoneTimes.count; i++)
            {
                planProgress *plan = _planDoneTimes[i];
                plan.times = i;
                plan.Mytotal = _planDetail.total;
                [self.UserTimes addObject:plan];
            }
            
            [self.tableview reloadData];
            [SVProgressHUD dismiss];
            
        } @catch (NSException *exception)
        {
            NSLog(@"解析出错");
            [SVProgressHUD dismiss];
        }
        
        
        
        
    } failure:^(NSDictionary *allHeaders,NSError *error,id statusCode) {
        
        [SVProgressHUD dismiss];
        if ([statusCode isEqualToString:@"401"]) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authorization"];
           
            StartViewController *loginVC = [StartViewController new];
            
            AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            [self presentViewController:loginVC animated:YES completion:^{
                
                delegete.window.rootViewController = loginVC;
            }];
        }else{
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
        }
        
        NSLog(@"%@",error);
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return self.UserTimes.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        DoctorDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorDetail"];
        if (!cell)
        {
            cell = [[DoctorDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DoctorDetail"];
        }
        cell.planDetail = _planDetail;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
       PlanDetailDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanDetailDay"];
        if (!cell)
        {
            cell = [[PlanDetailDayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlanDetailDay"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0)
        {
            UIView *lineView = [cell.contentView viewWithTag:1002];
            [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right);
                make.left.equalTo(cell.contentView.mas_left);
                make.top.equalTo(cell.contentView.mas_top);
                make.height.equalTo(@1);
            }];
        }
        planProgress *plan = self.UserTimes[indexPath.row];
        cell.PlanProgress = plan;
       return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
//        if (_planDetail.discription.note != nil)
//        {
//            UILabel *Notation = [UILabel new];
//            Notation.frame = CGRectMake(0, 0, SCREENWIDTH - 30, 30);
//            Notation.font = [UIFont systemFontOfSize:14];
//            Notation.text = _planDetail.discription.note;
//            Notation.numberOfLines = 0;
//            NSMutableAttributedString *str = [self TheLabletext:Notation.text];
//            Notation.attributedText = str;
//            [Notation sizeToFit];
//            
//            CGFloat heignt = Notation.height;
//            NSLog(@"高度为%lf",heignt);
            return 54;
 
//        }
//        else
//        {
//            return 100;
//        }
    }
    else
    {
        return 54;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
  return 7;
    
}

//行距设置
-(NSMutableAttributedString*)TheLabletext:(NSString*)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //paragraphStyle.maximumLineHeight = 18;  //最大的行高
    paragraphStyle.lineSpacing = 8;  //行间距
    paragraphStyle.alignment = 1;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}

-(void)backPlanDetail
{
    if ([self.C_delegate respondsToSelector:@selector(setValueB:)])
    {
        [self.C_delegate setValueB:@"1"];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置阴影
-(void)SetlableShadow:(UILabel*)planName
{
    planName.layer.shadowColor = [[UIColor blackColor] CGColor];
    planName.layer.shadowOffset = CGSizeMake(3, 3);
    planName.layer.shadowOpacity = 0.7;
    planName.layer.shadowRadius = 3;
}
#pragma mark ---处理内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (!self.view.window) {
            
            self.view = nil;
        }
    }
    
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

@end

//
//  NewTrainViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/10/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "NewTrainViewController.h"
#import "GHView.h"
#import "WYTDevicesTool.h"
#import "CourseDetailsViewController.h"
#import "StartViewController.h"
#import "PersonalModel.h"
#import "NTESSessionViewController.h"
#import "RootTabBarController.h"
#import "CourseDetailsViewController.h"
#import "StageModel.h"
#import "UserPlanModel.h"
#import "TrainRefreshView.h"
#import "NNFMDBTool.h"
#import "TrainModel.h"
#import "MyPlanViewController.h"
#import "NewCourseDetailViewController.h"
#import "NoticeViewController.h"
#define kGCCardRatio 0.8
#define kGCCardWidth [UIScreen mainScreen].bounds.size.width - 50
#define kGCCardHeight 200
#define CardRatio 254/315 //卡片高度比例
#define PlanImageRatio 185/315 //计划图高度比例
@interface NewTrainViewController ()<cardScorllViewdelegate,cardScorllViewDataSource,clickClientProtocol,trainrefreshDelegate>
{
   CourseDetailsViewController *courseDetailVC;
}
//主背景图
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UIView *TrainShadow;

//子控件群
@property(nonatomic,strong)UIImageView *DoctorIM;
@property(nonatomic,strong)UIButton *DoctorImage;
@property(nonatomic,strong)UIImageView *WordImage;
@property(nonatomic,strong)UIImageView *ImageblackView;//头像黑色遮罩
@property(nonatomic,strong)UILabel *yunxinLabel;
@property(nonatomic,strong)UIButton *jumpStageBtn;//跳转阶段页按钮

//阶段及进度条控件
@property(nonatomic,strong)UILabel *UserStage;
@property(nonatomic,strong)UIView *TopProgressView;
@property(nonatomic,strong)UIView *BottomProgressView;
@property(nonatomic,strong)UILabel *StageStartDate;
@property(nonatomic,strong)UILabel *StageEndDate;

//封装的滚动视图
@property(nonatomic,strong)GHView *cardScrollView;
@property(nonatomic,strong)NSMutableArray *cards;//卡片数组
@property(nonatomic,strong)UIImageView *planBackGround;//计划背景图
@property(nonatomic,strong)UILabel *planProgress;//计划进度
@property(nonatomic,strong)UILabel *planName;//计划名称
@property(nonatomic,strong)UILabel *planTime;//计划起止时间

//封装的刷新视图
@property(nonatomic,strong)TrainRefreshView *refreshView;//刷新视图

//模型类
@property(nonatomic,strong)PersonalModel *Personalmodel;
@property(nonatomic)NSInteger videoUrl;//当前计划的url
@property(nonatomic,strong)NSMutableArray *sectionArr;//所有阶段的数组
@property(nonatomic,strong)NSMutableArray *CurrentPlanArr;//当前阶段的计划数组
@property(nonatomic,strong)TrainModel *MyTrainModel;//当前计划模型 用于3Dtouch



@end

@implementation NewTrainViewController
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//懒加载
-(NSMutableArray *)sectionArr
{
    if (!_sectionArr)
    {
        _sectionArr = [NSMutableArray array];
    }
    return _sectionArr;
}
-(NSMutableArray *)CurrentPlanArr
{
    if (!_CurrentPlanArr)
    {
        _CurrentPlanArr = [NSMutableArray array];
    }
    return _CurrentPlanArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navibar的设置
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([delegete.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        RootTabBarController *rootBar =(RootTabBarController*)delegete.window.rootViewController;
        rootBar.clientDelegate = self;
    }

    
    if ([[[UIApplication sharedApplication] delegate].window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        [BusinessAirCoach setTrainShuaxuinTime:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayMessage:) name:@"NewMessage" object:nil];
    
    //用来完成计划后的通知刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"trainRefresh" object:nil];
   
    //清除缓存后置空课程详情页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Empty) name:@"CourseDetailsViewController" object:nil];
    
    [self creatUI];
    
    //创建缓存列表
    [self createSQLite];
    [self queryData];//取数据
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
    //云信未读消息判断
    [self YunxinLogin];
    
    
    self.hidesBottomBarWhenPushed = NO;
    NSDate *loadDateTime = [BusinessAirCoach GetTrainShuaxuin];
    if (loadDateTime == nil)
    {
        [self GiveMeTheData];
    }
    else
    {
        [self isOrNoLoadData:loadDateTime];
    }
    
    
    [TalkingData trackPageBegin:@"塑形tab页面"];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)GiveMeTheData
{
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
        __weak typeof(self) weakSelf = self;
        __block __weak id gpsObserver;
        gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf loadData];
            [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
        }];
        
    }
 
}
-(void)creatUI
{
    //主视图控制
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49)];
    _headImage.image = [UIImage imageNamed:@"背景图-占位"];
    
    [self.view addSubview:_headImage];
    _headImage.userInteractionEnabled = YES;
    
    [self.view addSubview:_headImage];

    //高斯模糊
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *bgView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    bgView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49);
    bgView.alpha = 1.0;
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    //加主遮罩
    _TrainShadow = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49)];
    _TrainShadow.alpha = 0.25;
    _TrainShadow.backgroundColor = TrainZhezhaoColor;
    
    [self.view addSubview:_TrainShadow];
    
    //遮罩上加手势 跳转进入阶段详情页
    UITapGestureRecognizer *firTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpPlanDetail)];
    firTap.numberOfTapsRequired = 1;
    firTap.numberOfTouchesRequired = 1;
    [_TrainShadow addGestureRecognizer:firTap];
    
    
    //创建顶部按群
    [self CreatTopBtns];

    //创建刷新视图
    [self CreatRefreshView];
    
    //阶段及进度条控件
    [self CreatStageLabel];
    
    //下方滚动主视图
    [self CreatScrollView];
    
    //创建云信话语框
    [self isYunxinWordImage:self.view topView:_DoctorImage];
    
    //饮食计算
    [self TotalKcalNumber];
    
}
-(void)CreatTopBtns
{
    //图标
    UIImageView *ItemImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 - 15, 26, 30, 30)];
    ItemImage.image = [UIImage imageNamed:@"首页logo"];
    [self.view addSubview:ItemImage];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(SCREENWIDTH - 64,30,50,50);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowOpacity = 0.9;
    layer.cornerRadius = 27;
    layer.shouldRasterize = YES;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    //这里self表示当前自定义的view
    [self.view.layer addSublayer:layer];
    
    _DoctorImage = [UIButton buttonWithType:UIButtonTypeCustom];
    _DoctorImage.frame = CGRectMake(SCREENWIDTH - 64,30,50,50);
    _DoctorImage.layer.cornerRadius = 25;
    _DoctorImage.layer.masksToBounds = YES;
   
    [_DoctorImage addTarget:self action:@selector(jumpYunxin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_DoctorImage];
    
    //返回图标
    _DoctorIM = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10 , 50, 50)];
    
    
    [_DoctorIM sd_setImageWithURL:[NSURL URLWithString:[BusinessAirCoach getCoachFigure]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_DoctorImage setBackgroundImage:image forState:UIControlStateNormal];
    }];
    
    
    _jumpStageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _jumpStageBtn.frame = CGRectMake(9,20,44,44);
    [_jumpStageBtn setBackgroundImage:[UIImage imageNamed:@"计划表"] forState:UIControlStateNormal];
    [_jumpStageBtn addTarget:self action:@selector(jumpPlanDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jumpStageBtn];
 
}
-(void)loadData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeCustom];
    [[HttpsRefreshNetworking  Networking] GET:CUSTOM parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        
        //写入刷新时间
        [BusinessAirCoach setTrainShuaxuinTime:[NSDate date]];
        
        NSLog(@"%@",responseObject);
        @try
        {
            [self JsonToMydata:responseObject];
            [BusinessAirCoach setNickName:_Personalmodel.nickname];
            [BusinessAirCoach setHeadPortrait:_Personalmodel.figure];
        
            [SVProgressHUD dismiss];
            
        } @catch (NSException *exception)
        {
            NSLog(@"解析出错");
            [SVProgressHUD dismiss];
            [self hideStageLabAndScorllview];
            [_refreshView disPlayTrainRefreshView];
        }
        
        if ([BusinessAirCoach getUserSpeakerLab] != nil)
        {
            [self jumpYunxin:nil];
        }
        if ([BusinessAirCoach getUserStartPlan] != nil)
        {
            [self jumpCurriculumDetail:_videoUrl];
        }
        
        //拉取用户当前阶段的接口
        [self loadUserCurStage];
        
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
        
        if ([BusinessAirCoach getUserSpeakerLab] != nil)
        {
            [self jumpYunxin:nil];
        }
        if ([BusinessAirCoach getUserStartPlan] != nil)
        {
            [self jumpCurriculumDetail:_videoUrl];
        }
        
        NSLog(@"%@",error);
    }];
 
}
-(void)loadUserCurStage
{
    [[HttpsRefreshNetworking Networking] GET:STAGE parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        
        @try
        {
            if ([statusCode isEqualToString:@"200"])
            {
                LRLog(@"%@",responseObject);
                
                [self LoadCurStagedata:responseObject];
                
                //写入新的缓存
                [self deleteData];
                [self insertData:responseObject];
                
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[BusinessAirCoach getCruteBackgroudImage]] placeholderImage:[UIImage imageNamed:@"背景图-占位"]];
                [SVProgressHUD dismiss];
            }
        } @catch (NSException *exception)
        {
            //解析错误 发送talkingData
            LRLog(@"解析出错,查找原因");
            [self hideStageLabAndScorllview];
            [_refreshView disPlayTrainRefreshView];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
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
        
        
        
        LRLog(@"%@",error);
        
    }];
  
}
-(void)LoadCurStagedata:(id)responseObject
{
    
    
    [self.sectionArr removeAllObjects];
    
    NSArray *stageArr = [StageModel mj_objectArrayWithKeyValuesArray:responseObject];
    self.sectionArr = [NSMutableArray arrayWithArray:stageArr];
    if(self.sectionArr.count != 0)
    {
        //查找当前阶段的模型数组
        for (StageModel *model in self.sectionArr)
        {
            if ([model.status isEqualToString:@"current"])
            {
                
                [_refreshView hideTrainRefreshView];//刷新页面消失
                [self displayStageLabAndScorllview];//阶段控件显示
                
                NSArray *stagePlanArr = [UserPlanModel mj_objectArrayWithKeyValuesArray:model.plans];
                //阶段日期赋值
                _StageStartDate.text = [NSString stringWithFormat:@"%@日",[self DateChange:model.start]];
                _StageEndDate.text = [NSString stringWithFormat:@"%@日",[self DateChange:model.end]];
                //执行进度条动画
                [self stageProgress:model.start endDate:model.end];
                
                if ((stagePlanArr.count == self.CurrentPlanArr.count) &&(self.CurrentPlanArr.count != 0))
                {
                    //说明卡片数目没有变化 只需内容刷新即可
                    [self.CurrentPlanArr removeAllObjects];
                    self.CurrentPlanArr = [NSMutableArray arrayWithArray:stagePlanArr];
                    [self.cardScrollView reloadCard];
                }
                else
                {
                    [self.CurrentPlanArr removeAllObjects];
                    self.CurrentPlanArr = [NSMutableArray arrayWithArray:stagePlanArr];
                    [self.cards removeAllObjects];
                    if (self.CurrentPlanArr.count == 0)
                    {
                        //说明当前阶段没有计划 展示一个卡片 正在等待请求计划
                        [self.cards addObject:@(0)];
                    }
                    else
                    {
                        for (NSInteger i = 0; i < self.CurrentPlanArr.count; i++) {
                            [self.cards addObject:@(i)];
                        }
                    }
                    //创建卡片
                    [self.cardScrollView loadCard];
                    
                    
                    
                }
                
                
                break;
            }
            else
            {
                //如果到此 代表新阶段还没有被创建 应该显示刷新按钮
                [self hideStageLabAndScorllview];
                [_refreshView disPlayTrainRefreshView];
                
            }
        }
 
    }
    else
    {
        //如果到此 代表没有任何阶段 应该显示刷新按钮
        [self hideStageLabAndScorllview];
        [_refreshView disPlayTrainRefreshView];
    }
//    [self hideStageLabAndScorllview];
//    [_refreshView disPlayTrainRefreshView];

}
-(void)stageProgress:(NSString*)stageStartDate endDate:(NSString*)stageEnddate
{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    
    
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval timeNow = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *dateNow = [[NSDate date] dateByAddingTimeInterval:timeNow];//当前时间
    
    NSDate *dateS =[[formatter dateFromString:stageStartDate] dateByAddingTimeInterval:timeNow];//开始时间
    NSDate *dateE =[[formatter dateFromString:stageEnddate] dateByAddingTimeInterval:timeNow];//结束时间
    
    
    
    NSTimeInterval timeS = [dateS timeIntervalSince1970];
    NSTimeInterval timeE = [dateE timeIntervalSince1970];
    NSTimeInterval timeN = [dateNow timeIntervalSince1970];
    
    NSInteger stageTime = timeE / (3600 * 24) - timeS / (3600 * 24);
    NSInteger curTime = timeN / (3600 * 24) - timeS / (3600 * 24);
    
    if (curTime *((SCREENWIDTH - 46)/stageTime) >= SCREENWIDTH - 46)
    {
        [UIView animateWithDuration:0.6 animations:^{
            _TopProgressView.width = SCREENWIDTH - 46;
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.6 animations:^{
           _TopProgressView.width = curTime *((SCREENWIDTH - 46)/stageTime);
        }];
        
    }
    
}
-(void)JsonToMydata:(id)jsonStr
{
    
    NSArray *arr = jsonStr[@"cur_training"];
    NSDictionary *dic = nil;
    if (arr.count != 0)
    {
        dic = (NSDictionary*)arr.firstObject;
        _MyTrainModel = [TrainModel mj_objectWithKeyValues:dic];
        _videoUrl =_MyTrainModel.host_id;
    }
    _Personalmodel = [PersonalModel mj_objectWithKeyValues:jsonStr];
    
    NSLog(@"%@",_Personalmodel.nurse.figure);
    NSLog(@"%@",_Personalmodel.nurse.name);
    NSLog(@"%@",_Personalmodel.nurse.nim.acc_id);
    [BusinessAirCoach                                                                                                                                                                                                                                                                                                                                                                                            setCoachFigure:_Personalmodel.nurse.figure];
    [BusinessAirCoach setCoachName:_Personalmodel.nurse.name];
    [BusinessAirCoach setCoachAcc_id:_Personalmodel.nurse.nim.acc_id];
    
    [_DoctorIM sd_setImageWithURL:[NSURL URLWithString:_Personalmodel.nurse.figure] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_DoctorImage setBackgroundImage:image forState:UIControlStateNormal];
    }];
    if (_Personalmodel.cur_stage != 0)
    {
        //当前第几阶段
       _UserStage.text = [NSString stringWithFormat:@"第%ld阶段",(long)_Personalmodel.cur_stage];
    }
    
}
- (void)Empty{
    
    courseDetailVC = nil;
}

-(void)CreatScrollView
{
    self.cardScrollView = [[GHView alloc] initWithFrame:CGRectMake(0, _TopProgressView.y + 14 + 66, SCREENWIDTH, (kGCCardWidth - 22) * CardRatio)];
    self.cardScrollView.cardDataDelegate = self;
    self.cardScrollView.cardDataSource = self;
    
    [self.view addSubview:self.cardScrollView];
    
    self.cards = [NSMutableArray array];
}
-(void)CreatRefreshView
{
    _refreshView = [[TrainRefreshView alloc]initWithFrame:CGRectMake(0, 165, SCREENWIDTH, SCREENHEIGHT - 108 - 64 - 49)];
    _refreshView.trainDelegate = self;
    [self.view addSubview:_refreshView];
    [_refreshView hideTrainRefreshView];
}
-(void)hideStageLabAndScorllview
{
    _cardScrollView.hidden = YES;
    _UserStage.hidden = YES;
    _StageEndDate.hidden = YES;
    _StageStartDate.hidden = YES;
    _TopProgressView.hidden = YES;
    _BottomProgressView.hidden = YES;
    [_refreshView disPlayTrainRefreshView];
    
}
-(void)displayStageLabAndScorllview
{
    _UserStage.hidden = NO;
    _StageEndDate.hidden = NO;
    _StageStartDate.hidden = NO;
    _TopProgressView.hidden = NO;
    _BottomProgressView.hidden = NO;
    _cardScrollView.hidden = NO;
    [_refreshView hideTrainRefreshView];
}
-(void)CreatStageLabel
{
    _UserStage = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT * 0.23, SCREENWIDTH, 30)];
    _UserStage.text = @"第3阶段";
    _UserStage.textAlignment = 1;
    _UserStage.textColor = [UIColor whiteColor];
    [self DoublePen:_UserStage size:30];
    [self.view addSubview:_UserStage];
    
    //进度条(底部)
    _BottomProgressView = [[UIView alloc]initWithFrame:CGRectMake(23, _UserStage.y + 54, SCREENWIDTH - 46 , 14)];
    _BottomProgressView.backgroundColor = [UIColor whiteColor];
    _BottomProgressView.alpha = 0.2;
    _BottomProgressView.layer.cornerRadius = 7;
    _BottomProgressView.layer.masksToBounds = YES;
    [self.view addSubview:_BottomProgressView];
    
    //进度条(顶部)
    _TopProgressView = [[UIView alloc]initWithFrame:CGRectMake(23, _UserStage.y + 54, 0 , 14)];
    _TopProgressView.backgroundColor = TrainProgressTopColor;
    _TopProgressView.layer.cornerRadius = 7;
    _TopProgressView.layer.masksToBounds = YES;
    [self.view addSubview:_TopProgressView];
    
    //开始日期
    _StageStartDate = [[UILabel alloc]initWithFrame:CGRectMake(23, _BottomProgressView.y + 22, 70, 14)];
    _StageStartDate.font = [UIFont systemFontOfSize:14];
    _StageStartDate.textColor = [UIColor whiteColor];
    [self.view addSubview:_StageStartDate];
    
    //结束日期
    _StageEndDate = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 62 - 15, _BottomProgressView.y + 22, 62, 14)];
    _StageEndDate.textColor = [UIColor whiteColor];
    _StageEndDate.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_StageEndDate];

    
    
    
}
//加粗字体
-(void)DoublePen:(UILabel*)lab size:(NSInteger)Labsize
{
   UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:Labsize];
   lab.font = font;
}
//跳入云信
-(void)jumpYunxin:(UIButton*)sender
{
    
    [self YunXindetail];
    
}
-(void)YunXindetail
{
    NIMSession *session = [NIMSession session:[BusinessAirCoach getCoachAcc_id] type:NIMSessionTypeP2P];
    
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    vc.hidesBottomBarWhenPushed = YES;
    [vc.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--cardScorllViewDataSource
-(NSMutableArray *)contentOfCards
{
    return self.CurrentPlanArr;
}
-(NSInteger)numberOfCards
{
    return self.cards.count;
}
-(void)jumpTraining:(NSInteger)videoUrl
{
    [self jumpCurriculumDetail:videoUrl];
}
-(void)jumpPastPlanAndFuturePlan:(NSInteger)videoUrl type:(PlanType)planType
{
    NewCourseDetailViewController *newTrain = [NewCourseDetailViewController new];
    newTrain.UrlID = videoUrl;
    newTrain.pastOrfutrue = planType;
    newTrain.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:bar];
    [self.navigationController pushViewController:newTrain animated:YES];

}
-(UIView *)cardReuseView:(UIView *)reuseView atIndex:(NSInteger)index
{
    UIView *card = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kGCCardWidth - 11, (kGCCardWidth - 11) * CardRatio)];
    card.layer.backgroundColor = [UIColor whiteColor].CGColor;
    //[self clipView:card];
    card.layer.cornerRadius = 8.0f;
    card.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    card.layer.shadowOpacity = 0.7f;
    card.layer.shadowRadius = 8.0f;
    card.layer.shadowOffset = CGSizeMake(0,0);
    card.layer.shadowPath = [UIBezierPath bezierPathWithRect:card.bounds].CGPath;
    //设置缓存
    card.layer.shouldRasterize = YES;
    //设置抗锯齿边缘
    card.layer.rasterizationScale = [UIScreen mainScreen].scale;

    
    _planBackGround = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kGCCardWidth - 11, (kGCCardWidth - 11) * PlanImageRatio)];
    _planBackGround.image = [UIImage imageNamed:@"暂无计划背景图"];
    _planBackGround.contentMode = UIViewContentModeScaleAspectFill;
    _planBackGround.clipsToBounds = YES;
    _planBackGround.tag = 1001;
    [card addSubview:_planBackGround];
    
    [self clipImage:_planBackGround];
    
    
    //半透明黑色遮罩
    UIImageView *shadowImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kGCCardWidth - 11, (kGCCardWidth - 11) * PlanImageRatio + 1)];
    shadowImage.image = [UIImage imageNamed:@"计划图遮罩"];
    shadowImage.tag = 1005;
    [card addSubview:shadowImage];
    
    [self clipImage:shadowImage];
    //计划进度
    _planProgress = [[UILabel alloc]initWithFrame:CGRectMake(0, _planBackGround.height - 53, kGCCardWidth - 11, 32)];
    _planProgress.font = [UIFont systemFontOfSize:32];
    _planProgress.textAlignment = 1;
    _planProgress.textColor = [UIColor whiteColor];
    _planProgress.tag = 1002;
    [shadowImage addSubview:_planProgress];
    
    
    UIImageView *openImage = nil;
    //计划名称
    if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c]||[WYTDevicesTool iPhone4_iPhone4s])
    {
        _planName = [[UILabel alloc]initWithFrame:CGRectMake(0, _planBackGround.height + 13, kGCCardWidth - 11, 17)];
        _planName.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        _planTime = [[UILabel alloc]initWithFrame:CGRectMake(0, _planName.y + 19 + 7, kGCCardWidth - 11, 12)];
        openImage = [[UIImageView alloc]initWithFrame:CGRectMake((card.width - 70) / 2, _planProgress.y - 10 - 70, 70, 70)];
    }
    else
    {
        _planName = [[UILabel alloc]initWithFrame:CGRectMake(0, _planBackGround.height + 13, kGCCardWidth - 22, 19)];
        _planName.font = [UIFont systemFontOfSize:19 weight:UIFontWeightSemibold];
        _planTime = [[UILabel alloc]initWithFrame:CGRectMake(0, _planName.y + 19 + 9, kGCCardWidth - 22, 12)];
        openImage = [[UIImageView alloc]initWithFrame:CGRectMake((card.width - 70) / 2, _planProgress.y - 25 - 70, 70, 70)];
  
    }
    _planName.text = @"暂无训练方案";
    _planName.tag = 1003;
    _planName.textAlignment = 1;
    _planName.textColor = Reportcolor;
    [card addSubview:_planName];

    //计划时间
   // _planTime = [[UILabel alloc]initWithFrame:CGRectMake(0, _planName.y + 19 + 9, kGCCardWidth - 22, 12)];
    _planTime.font = [UIFont systemFontOfSize:12];
    _planTime.textAlignment = 1;
    _planTime.textColor = LableColor;
    _planTime.tag = 1004;
    _planTime.text = @"护理师正为您定制训练方案，请稍等";
    [card addSubview:_planTime];
    
    //锁定和打开的状态
    openImage.image = [UIImage imageNamed:@"计划未开始"];
    [card addSubview:openImage];
    openImage.tag = 1006;
    
    
    return card;

}
-(void)clipImage:(UIImageView*)planBackGround
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kGCCardWidth - 11, (kGCCardWidth - 11) * PlanImageRatio) byRoundingCorners:UIRectCornerTopLeft| UIRectCornerTopRight  cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = CGRectMake(0, 0, SCREENWIDTH - 11, (kGCCardWidth - 11) * PlanImageRatio);
    maskLayer.path = maskPath.CGPath;
    planBackGround.layer.mask = maskLayer;
}
-(void)clipView:(UIView*)planBackGround
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kGCCardWidth - 11, (kGCCardWidth - 11) * CardRatio) byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(8.2, 8.2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = CGRectMake(0, 0, kGCCardWidth - 11, (kGCCardWidth - 11) * CardRatio);
    maskLayer.path = maskPath.CGPath;
    planBackGround.layer.mask = maskLayer;
}

#pragma mark--cardScorllViewdelegate

-(void)updateCard:(UIView *)card withProgress:(CGFloat)progress direction:(CardMoveDirection)direction
{
   //未完待续
}
#pragma mark----clickdelegate销毁页面
-(void)pauseTheMV
{
    [self Empty];
}
#pragma mark--TrainRefreshdelegate
-(void)refreshTrain
{
    [self GiveMeTheData];
}
-(void)jumpNoticPage
{
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[NoticeViewController new]];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}
- (void)jumpCurriculumDetail:(NSInteger)videoUrl{
    
    if (videoUrl != 0)
    {
        [BusinessAirCoach setcurID:[NSString stringWithFormat:@"%ld",(long)videoUrl]];
        NSLog(@"跳到课程详情页面");
        if (!courseDetailVC) {
            courseDetailVC = [[CourseDetailsViewController alloc] init];
            courseDetailVC.hidesBottomBarWhenPushed = YES;
        }
        
        UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:bar];
        courseDetailVC.UrlID = videoUrl;
        [self.navigationController pushViewController:courseDetailVC animated:YES];
    }
    
}
-(void)jumpPlanDetail
{
    [self presentViewController:[MyPlanViewController new] animated:YES completion:nil];
}
#pragma mark---yunXinLab
//消息提示框
-(void)isYunxinWordImage:(UIView*)headImage topView:(UIButton*)doctor
{
    if (_WordImage == nil)
    {
        _WordImage = [UIImageView new];
    }
    
    [headImage addSubview:_WordImage];
    [_WordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(doctor.mas_bottom).offset(3);
        make.right.equalTo(headImage.mas_right).offset(-14);
        make.height.equalTo(@42);
        make.width.equalTo(@220);
    }];
    _WordImage.image = [UIImage imageNamed:@"对话框"];
    _WordImage.userInteractionEnabled = YES;
    //云信的话
    if (_yunxinLabel == nil)
    {
        _yunxinLabel = [UILabel new];
    }
    
    [_WordImage addSubview:_yunxinLabel];
    [_yunxinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_WordImage.mas_top).offset(16);
        make.left.equalTo(_WordImage.mas_left).offset(8);
        make.height.equalTo(@14);
        make.width.equalTo(@162);
    }];
    _yunxinLabel.font = [UIFont systemFontOfSize:14];
    _yunxinLabel.textColor = MessageBlock;
    
    //点击消失
    UIButton *dissword = [UIButton buttonWithType:UIButtonTypeCustom];
    [_WordImage addSubview:dissword];
    [dissword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_WordImage.mas_top).offset(5);
        make.right.equalTo(_WordImage.mas_right);
        make.height.equalTo(@37);
        make.width.equalTo(@37);
    }];
    [dissword setBackgroundImage:[UIImage imageNamed:@"小关闭"] forState:UIControlStateNormal];
    [dissword addTarget:self action:@selector(yunxinWordLableDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpYunxin:)];
    [_WordImage addGestureRecognizer:tap];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    _WordImage.hidden = YES;
}
//云信聊天标签退出
-(void)yunxinWordLableDismiss
{
    [_WordImage removeFromSuperview];
    //消息标已读
    NIMSession *session = [NIMSession session:[BusinessAirCoach getCoachAcc_id] type:NIMSessionTypeP2P];
    [[[NIMSDK sharedSDK] conversationManager] markAllMessagesReadInSession:session];
}
-(void)someMethod
{
    [self YunxinLogin];
}
-(void)YunxinLogin
{
    NSLog(@"未读消息数%ld",(long)[[[NIMSDK sharedSDK] conversationManager] allUnreadCount]);
    
    if([[[NIMSDK sharedSDK] conversationManager] allUnreadCount] == 0)
    {
        _WordImage.hidden = YES;
    }
    else
    {
        _WordImage.hidden = NO;
        _yunxinLabel.text = [BusinessAirCoach getlastMessage:[BusinessAirCoach getTel]];
    }
    
}
-(void)displayMessage:(NSNotification*)noti
{
    
    if (_WordImage == nil)
    {
        [self isYunxinWordImage:self.view topView:_DoctorImage];
        _WordImage.hidden = NO;
        _yunxinLabel.text = noti.userInfo[@"msg"];
    }
    else
    {
        
        [self isYunxinWordImage:self.view topView:_DoctorImage];
        _WordImage.hidden = NO;
        _yunxinLabel.text = noti.userInfo[@"msg"];
    }
    
}

#pragma mark---TimeTools
-(void)isOrNoLoadData:(NSDate*)dateMore
{
    
    NSDateComponents *d = [self timeLenght:dateMore];
    if ([d minute] >= 2||[d minute] <= -2)
    {
        NSLog(@"超过两分钟了,刷新去吧");
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
            __weak typeof(self) weakSelf = self;
            __block __weak id gpsObserver;
            gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                [weakSelf loadData];
                [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
            }];
        }
        
    }
    else
    {
        NSLog(@"没有超过两分钟,不用刷新");
    }
    
}
//计算两个时间差
-(NSDateComponents *)timeLenght:(NSDate *)dateTime
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //计算日期差值
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval time = [zone secondsFromGMTForDate:dateTime];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSTimeInterval timeNow = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *datefir = [dateTime dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
    NSDate *dateNow = [[NSDate date] dateByAddingTimeInterval:timeNow];
    
    
    NSDateComponents *d = [cal components:unitFlags fromDate:datefir toDate:dateNow options:0];
    return d;
}

//处理时间格式
-(NSString*)DateChange:(NSString*)startAndEndTime
{
    NSString *changeDate = nil;
    if (startAndEndTime.length == 0)
    {
        
    }
    else
    {
        changeDate = [startAndEndTime substringFromIndex:5];
        changeDate = [changeDate stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    }
    return changeDate;
}

#pragma mark---饮食数据计算
- (void)TotalKcalNumber{
    
    if ([BusinessAirCoach getTotalKcal:[BusinessAirCoach getTel]] == nil) {
        CGFloat ran = [self randomFloatBetween:1.05 andLargerFloat:1.1];
        NSLog(@"-------------%f",ran);
        CGFloat  TotalKcal = 1378*ran;
        [BusinessAirCoach setTotalKcal:[NSString stringWithFormat:@"%f",TotalKcal]];
    }
    
}

-(float)randomFloatBetween:(float)num1 andLargerFloat:(float)num2
{
    int startVal = num1*10000;
    int endVal = num2*10000;
    
    int randomValue = startVal +(arc4random()%(endVal - startVal));
    float a = randomValue;
    
    return(a /10000.0);
}

#pragma mark--缓存处理
//创建表
- (void)createSQLite{
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"NewUserTrainData%@.sqlite",[BusinessAirCoach getTel]] dbHandler:^(FMDatabase *nn_db) {
        NSString *cSql = @"CREATE TABLE IF NOT EXISTS OLD (id INTEGER PRIMARY KEY, UserID TEXT NOT NULL, UserTrainData TEXT NOT NULL)";
        BOOL res = [nn_db executeUpdate:cSql];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"succ to creating db table");
        }
    }];
}
//存数据
- (void)insertData:(NSString *)modelArray{
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"NewUserTrainData%@.sqlite",[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
        NSString * sql = @"insert into OLD (UserID, UserTrainData) values(?, ?)";
        NSData *UserTrainData = [NSKeyedArchiver archivedDataWithRootObject:modelArray];
        NSString *UserID = [BusinessAirCoach getTel];
        BOOL res = [nn_db executeUpdate:sql, UserID, UserTrainData];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"OK");
        }
    }];
}
//取数据
- (void)queryData{
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"NewUserTrainData%@.sqlite",[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
        NSString *qSql = @"SELECT * FROM OLD WHERE UserID = ?";
        FMResultSet *set = [nn_db executeQuery:qSql,[BusinessAirCoach getTel]];
        while ([set next]) {
            
            NSData *StageData = [set dataForColumn:@"UserTrainData"];
            [self LoadCurStagedata:[NSKeyedUnarchiver unarchiveObjectWithData:StageData]];
        }
    }];
}
//删除数据
- (void)deleteData {
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"NewUserTrainData%@.sqlite",[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
        NSString *dSql = @"DELETE FROM OLD WHERE UserID = ?";
        BOOL res = [nn_db executeUpdate:dSql,[BusinessAirCoach getTel]];
        if (!res) {
            NSLog(@"error to DELETE data");
        } else {
            NSLog(@"succ to DELETE data");
            
        }
    }];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

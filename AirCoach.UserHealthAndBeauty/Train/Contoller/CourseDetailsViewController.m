//
//  CourseDetailsViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/6.
//  Copyright © 2016年 xuan. All rights reserved.
//



/*
                                    _ooOoo_
                                   o8888888o
                                   88" . "88
                                   (| -_- |)
                                   O\  =  /O
                                ____/`---'\____
                              .'  \\|     |//  `.
                             /  \\|||  :  |||//  \
                            /  _||||| -:- |||||-  \
                            |   | \\\  -  /// |   |
                            | \_|  ''\---/''  |   |
                            \  .-\__  `-`  ___/-. /
                          ___`. .'  /--.--\  `. . __
                       ."" '<  `.___\_<|>_/___.'  >'"".
                      | | :  `- \`.;`\ _ /`;.`/ - ` : | |
                      \  \ `-.   \_ __\ /__ _/   .-` /  /
                 ======`-.____`-.___\_____/___.-`____.-'======
                                    `=---='
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                          佛祖保佑       永无BUG
                 */


#import "CourseDetailsViewController.h"
#import "DietTableViewCell.h"
#import "CourseHeadV.h"
#import "ClassCell.h"
#import "ZLPhotoPickerBrowserPhoto.h"
#import "AvPlayerViewController.h"
#import "PlanList.h"
#import "CourseModel.h"
#import "previewModel.h"
#import "CommonUtil.h"

#import "ICSandboxHelper.h"

#import "HashMD5Check.h"

#import "CoachModel.h"

#import "AVEndViewController.h"

#import "UIView+CTOpenView.h"

#import "UIControl+BlocksKit.h"

#import "StartViewController.h"
#import "previewModel.h"


static int errorNum = 0;
@interface CourseDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,BtnClcikDelegate,ZLPhotoPickerBrowserViewControllerDelegate,UITableViewCellDelsegate,UIGestureRecognizerDelegate,AlertControllerDZDelegate>{
    CourseHeadV *couseHeadview;//headView
}
@property(nonatomic,strong)UITableView *courseDetailsTableView;


@property (strong, nonatomic) UIView *bgBlackView;

@property (nonatomic,strong) AVPlayerItem * playerItem;//视频
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;//播放器场景
@property(nonatomic,strong)UIButton *startButton;

@property (nonatomic, strong) NSArray *playList; //播放列表

@property (strong, nonatomic) NSMutableArray *MainArray;
@property (strong, nonatomic) NSMutableArray *StrenchArray;
@property (nonatomic, strong) CourseModel *courseModel;
@property (strong, nonatomic) NSMutableArray *warmArray; //中间层的数据

@property (strong,nonatomic) previewModel *previewModel;
@property (strong, nonatomic) NSMutableArray *playlistArray; //播放列表数据
@property (strong,nonatomic) NSMutableArray *playShowArray;//动作讲解展示数据

@property (assign, nonatomic) int loadIndex;//记录下载的个数
@property (assign,nonatomic) int isQuanBuYou;


@property (strong, nonatomic) UIView *bGView;//下载进度背景View
@property (strong, nonatomic) UIView *progressView;//下载view
@property (strong, nonatomic) UILabel *startLabel; //下载进度展示label

@property (strong, nonatomic)UIImageView *titleImageView;

@property (strong, nonatomic) CoachModel*coachModel;

//count
@property (strong ,nonatomic) NSMutableArray *reShengArray;
@property (strong ,nonatomic) NSMutableArray *laShengArray;
@property (strong ,nonatomic) NSMutableArray *zhuYaoArray;

@property (strong, nonatomic) NSMutableArray *countMutableArray;

//UIVisualEffectView
@property (nonatomic, strong) UIView *maoboliView;

@property (nonatomic, assign) CGFloat alphaMemory;

@property (nonatomic, strong) UILabel *action;
@property (nonatomic, strong) UILabel *endLabel;

@property (nonatomic,strong)UIActivityIndicatorView *testActivityIndicator;

@property(nonatomic)NSInteger AllTimes;


//头部视图控件
@property(nonatomic,strong)UIView *MyheaderView;

@property(nonatomic,strong)UIImageView *headerImageView;

@property(nonatomic,strong)UIImageView *ZheZhaoImageView;

@property(nonatomic,strong)UIView *mengbanView;

@property(nonatomic,strong)UILabel *PlanNameLab;

@property(nonatomic,strong)UILabel *PlanDetailLab;

//导航栏底部黑线
@property(nonatomic,strong)UIView *bottomBlackView;

@property(nonatomic,strong)id MyresponseObject;

@property(nonatomic,strong)AlertControllerDZ *alertViewBook;

@property(nonatomic,strong)UIImage *NormalImage;//返回键粉色
@property(nonatomic,strong)UIImage *WhiteImage;//返回键白色


@end



@implementation CourseDetailsViewController

-(UIActivityIndicatorView *)testActivityIndicator
{
    if (!_testActivityIndicator)
    {
        _testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
       // _testActivityIndicator.center = CGPointMake(100.0f, 100.0f);
        
    }
    return _testActivityIndicator;
}
- (BOOL)shouldAutorotate
{
   // LRLog(@"让不让我旋转?");
    return NO;
}

//不让手机横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (UIButton *)startButton{
    
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_startButton setBackgroundColor:ZhuYao];
        [_startButton setTintColor:[UIColor whiteColor]];
        
        _startButton.font = [UIFont systemFontOfSize:18];
        
        _startButton.frame = CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50);
        [_startButton setTitle:@"开始训练" forState:UIControlStateNormal];
        [self.view addSubview:_startButton];
        
    }
    return _startButton;
}


- (UIView *)bGView{
    
    if (!_bGView) {
        _bGView = [UIView new];
        _bGView.backgroundColor = ZhuYao;
//        _bGView.backgroundColor = [UIColor colorWithRed:243/255.0 green:110/255.0 blue:154/255.0 alpha:1.0f];
        _bGView.hidden = YES;
        [self.view addSubview:_bGView];
        
        [_bGView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@(50));
            make.bottom.equalTo(self.view.mas_bottom);
            
        }];
        
        
        _progressView = [UIView  new];
//        _progressView.backgroundColor = ZhuYao;
        _progressView.backgroundColor = [UIColor colorWithRed:243/255.0 green:110/255.0 blue:154/255.0 alpha:1.0f];
        _progressView.frame = CGRectMake(0, 0, 0, 50);
        [_bGView addSubview:_progressView];
        
        _startLabel = [UILabel new];
        _startLabel.frame = CGRectMake(0, 0, SCREENWIDTH, 50);
        _startLabel.text = @"正在下载：0%";
        _startLabel.backgroundColor = [UIColor clearColor];
        _startLabel.textColor = [UIColor whiteColor];
        _startLabel.font = [UIFont systemFontOfSize:18];
        [_startLabel setTextAlignment:NSTextAlignmentCenter];
        [_bGView addSubview:_startLabel];
    }
    
    return _bGView;
}


-(NSMutableArray *)MainArray
{
    if (!_MainArray)
    {
        _MainArray = [NSMutableArray array];
    }
    return _MainArray;
}
-(NSMutableArray *)StrenchArray
{
    if (!_StrenchArray)
    {
        _StrenchArray = [NSMutableArray array];
    }
    return _StrenchArray;
}

- (NSMutableArray *)warmArray{
    if (!_warmArray) {
         _warmArray = [[NSMutableArray alloc] init];
    }
    return _warmArray;
}

- (NSMutableArray *)playlistArray{
    if (!_playlistArray) {
        _playlistArray = [[ NSMutableArray alloc] init];
    }
    return _playlistArray;
}

- (NSMutableArray *)playShowArray{
    if (!_playShowArray) {
        _playShowArray = [[NSMutableArray alloc] init];
    }
    
    return _playShowArray;
}


- (NSMutableArray *)reShengArray{
    if (!_reShengArray) {
        _reShengArray = [[NSMutableArray alloc] init];
    }
    
    return _reShengArray;
}

- (NSMutableArray *)zhuYaoArray{
    if (!_zhuYaoArray) {
        _zhuYaoArray = [[NSMutableArray alloc] init];
    }
    
    return _zhuYaoArray;
}

- (NSMutableArray *)laShengArray{
    if (!_laShengArray) {
        _laShengArray = [[NSMutableArray alloc] init];
    }
    
    return _laShengArray;
}

- (NSMutableArray *)countMutableArray{
    if (!_countMutableArray) {
        _countMutableArray = [[NSMutableArray alloc] init];
    }
    return _countMutableArray;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_细线.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self startLoadData];
    
    //注意这边如果下拉过程中点了按钮去往别的界面后 如果不还原出现错位的情况 在这里强行让控件还原  防止这种情况
    [self updateSubViewsInheader];
    
    [TalkingData trackPageBegin:@"课程详情页面"];
}
-(void)updateSubViewsInheader
{
    _headerImageView.frame = CGRectMake(0, 0, SCREENWIDTH, 228);
    _ZheZhaoImageView.frame = CGRectMake(0, 0, SCREENWIDTH, 228);
    _mengbanView.frame = CGRectMake(0, 0, SCREENWIDTH, 228);
    
    _PlanNameLab.x = 15;
    _PlanNameLab.y = 160;
    _PlanDetailLab.x = 15;
    _PlanDetailLab.y = 192;
}
-(void)startLoadData
{
    //判断token是否过期
    [BusinessAirCoach JugedToken];
    if ([[BusinessAirCoach getAlllabel] isEqualToString:@"CanUse"])
    {
        //token没过期 开始刷新
        [self loadCourseDetailData];
    }
    else
    {
        //接收到通知 开始刷新
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RequstAllready" object:nil];
        __weak typeof(self) weakSelf = self;
        __block __weak id gpsObserver;
        gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf loadCourseDetailData];
            [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
        }];
        
    }
 
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
   
    if (_playerItem != nil) {
        [self jumpView];
    }
    
    if ([BusinessAirCoach getUserStartPlan] != nil)
    {
        [BusinessAirCoach setUserStartPlan:nil];
    }
    
   [TalkingData trackPageEnd:@"课程详情页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //添加轻扫手势
    UIScreenEdgePanGestureRecognizer *swipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture)];
    //设置轻扫的方向
    swipeGesture.edges = MASAttributeLeft; //默认向右
    [self.view addGestureRecognizer:swipeGesture];
    //设置电池条为白色
    //self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    _titleImageView.image = [UIImage imageNamed:@""];
    _titleImageView.hidden = YES;
    [self.view addSubview:_titleImageView];
    

   
    self.titleLabel.text = @"训练方案";
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    
     [self creatUI];
   
    //创建缓存
    [self createSQLite:@"UserCourseDetails"];
    //取数据
    [self queryData:@"UserCourseDetails"];
    
    
    //创建缓存
    [self createSQLite:@"UserCourseList"];
    //取数据
    if([self queryOldData:@"UserCourseList"].count != 0)
    {
        [self deleteData:@"UserCourseList" type:@"New"];
        [self insertData:_MyresponseObject addSqlName:@"UserCourseList"];
        [self deleteData:@"UserCourseList" type:@"old"];
    }
    [self queryData:@"UserCourseList"];
    
   
    
     
    [self iOS8blurAction];
    

    _NormalImage = [[UIImage imageNamed:@"Y返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _WhiteImage = [[UIImage imageNamed:@"Y返回白色"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem.image = _WhiteImage;
    
}


-(void)swipeGesture
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [self RefreshProgressBar];
}


- (void)iOS8blurAction {
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _maoboliView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    _maoboliView.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
    // _maoboliView.backgroundColor = [UIColor whiteColor];
    _maoboliView.alpha = 0;
    
    _bottomBlackView = [[UIView alloc]init];
    _bottomBlackView.frame = CGRectMake(0, 63.5, SCREENWIDTH, 0.5);
    _bottomBlackView.backgroundColor = BottomlineColor;
    _bottomBlackView.alpha = 0;
    
    [_maoboliView addSubview:_bottomBlackView];
    
    [self.view addSubview:_maoboliView];
}


-(void)creatUI
{
    
    
    
    _courseDetailsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT ) style:UITableViewStyleGrouped];
    _courseDetailsTableView.delegate = self;
    _courseDetailsTableView.dataSource = self;
    _courseDetailsTableView.separatorStyle = NO;
    _courseDetailsTableView.showsVerticalScrollIndicator = NO;
    _courseDetailsTableView.contentInset = UIEdgeInsetsMake(228, 0, 49, 0);
    [self.view addSubview:_courseDetailsTableView];
    [self createHeadView];
    
    [self.startButton addTarget:self action:@selector(startBtnClcik) forControlEvents:UIControlEventTouchUpInside];
}


- (void)loadCourseDetailData{

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeCustom];
    [[HttpsRefreshNetworking Networking] GET:[NSString stringWithFormat:PLANSHOW,(long)_UrlID] parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        
      
        LRLog(@"%@", responseObject);
        
       
        @try {
            
            [self.playlistArray removeAllObjects];
            [self.reShengArray removeAllObjects];
            [self.laShengArray removeAllObjects];
            [self.zhuYaoArray removeAllObjects];
            [self.countMutableArray removeAllObjects];
            [self.playShowArray removeAllObjects];
            [self.warmArray removeAllObjects];
            [self.MainArray removeAllObjects];
            [self.StrenchArray removeAllObjects];
            _courseModel = [CourseModel mj_objectWithKeyValues:responseObject];
            
           
             [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_courseModel.backgroud] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
            
            _PlanDetailLab.text = [NSString stringWithFormat:@"%ld个动作  约%d分钟  已完成 %ld/%ld 次",(long)_courseModel.action_count,_courseModel.length/60,(long)_courseModel.complete,(long)_courseModel.total];
            _PlanNameLab.text = [NSString stringWithFormat:@"%@",_courseModel.name];
            //总时长
            _AllTimes = _courseModel.length;
    
            _coachModel = [CoachModel mj_objectWithKeyValues:_courseModel.coach];
            
            couseHeadview.coachModel = _coachModel;
            LRLog(@"%ld",(long)_courseModel.coach_id);
            
            for (WarmModel *warm in _courseModel .warm) {
                [self.playlistArray   addObject:warm];
                [self.reShengArray addObject:warm];
             
                previewModel *public = [previewModel mj_objectWithKeyValues:warm];
                
                [self.warmArray addObject:public];
                
            }
            
            for (WarmModel *warm in _courseModel.main) {
                
                [self.playlistArray  addObject:warm];
                [self.zhuYaoArray addObject:warm];
                
                previewModel *public = [previewModel mj_objectWithKeyValues:warm];
                
                
                [self.MainArray addObject:public];
                
            }
            for (WarmModel *warm in _courseModel.stretch) {
                
                [self.playlistArray  addObject:warm];
                [self.laShengArray addObject:warm];
                previewModel *public = [previewModel mj_objectWithKeyValues:warm];
                
             
                [self.StrenchArray addObject:public];
                
            }
            
            
            if (self.warmArray.count != 0) {
                [self.playShowArray addObject:self.warmArray];
                [self.countMutableArray addObject:self.reShengArray];
            }
            
            if (self.MainArray.count != 0) {
                [self.playShowArray addObject:self.MainArray];
                [self.countMutableArray addObject:self.zhuYaoArray];
            }
            if (self.StrenchArray.count  != 0) {
                [self.playShowArray addObject:self.StrenchArray];
                [self.countMutableArray addObject:self.laShengArray];
            }
#pragma mark---标签判断是否点击过
            if ([BusinessAirCoach getProgressBarToDownloadANumberOfLabels] != nil) {
                
                if ([BusinessAirCoach getProgressBarToDownloadANumberOfLabels].integerValue > 0 && [BusinessAirCoach getProgressBarToDownloadANumberOfLabels].integerValue < _playlistArray.count) {
                    
                    [self jindutiao];
                    _loadIndex = [[BusinessAirCoach getProgressBarToDownloadANumberOfLabels] intValue];
                    [self RefreshProgressBar];
                   
                    
                    
                }
            }
            
            
            [self.courseDetailsTableView reloadData];
            
            //存课程详情的数据 先删后存
            [self deleteData:@"UserCourseDetails" type:@"New"];
            [self insertData:responseObject addSqlName:@"UserCourseDetails"];
            
        
            
        } @catch (NSException *exception) {
            
            
            LRLog(@"解析失败");
            
        }
       
#pragma mark  --获取播放list
        
       
        [[HttpsRefreshNetworking Networking] GET:[NSString stringWithFormat:PLANLIST,(long)_UrlID] parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
            @try {
                LRLog(@"%@",responseObject);
                _playList = [PlanList mj_objectArrayWithKeyValuesArray:responseObject];
                
                [self deleteData:@"UserCourseList" type:@"New"];
                [self insertData:responseObject addSqlName:@"UserCourseList"];
            } @catch (NSException *exception) {
                
            }
            [BusinessAirCoach setLastcurID:[NSString stringWithFormat:@"%ld",(long)_UrlID]];//网络刷新成功 id替身可以换了
            [SVProgressHUD dismiss];
            
        } failure:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
            
            if ([statusCode isEqualToString:@"401"]) {
                
                StartViewController *loginVC = [StartViewController new];
                
                AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                [self presentViewController:loginVC animated:YES completion:^{
                    
                    delegete.window.rootViewController = loginVC;
                }];
                
            }else{
                PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
                [[UIApplication sharedApplication].keyWindow addSubview:prom];
            }
            
            [SVProgressHUD dismiss];
            if (![[BusinessAirCoach getLastPlancurID] isEqualToString:[BusinessAirCoach getPlancurID]]) {
                [BusinessAirCoach setcurID:[BusinessAirCoach getLastPlancurID]];//网络失败了 不好意思 你得用以前的id
            }
            LRLog(@"--------  %@",error);
        }];
        
        
    } failure:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
        
        [SVProgressHUD dismiss];
        if ([statusCode isEqualToString:@"401"]) {
            
            StartViewController *loginVC = [StartViewController new];
            
            AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            [self presentViewController:loginVC animated:YES completion:^{
                
                delegete.window.rootViewController = loginVC;
            }];
            
        }else{
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
        }
        LRLog(@"========================  %@",error);
        if (![[BusinessAirCoach getLastPlancurID] isEqualToString:[BusinessAirCoach getPlancurID]]) {
            [BusinessAirCoach setcurID:[BusinessAirCoach getLastPlancurID]];//网络失败了 不好意思 你得用以前的id
        }
    }];
}


- (void)createHeadView{
    
    _MyheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, -228, SCREENWIDTH, 228*WIDTHBASE)];
    _MyheaderView.backgroundColor = [[UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1] colorWithAlphaComponent:0];
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 228)];
    _headerImageView.image = [UIImage imageNamed:@"头像-背景图"];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    [_MyheaderView addSubview:_headerImageView];
    //蒙版
    _mengbanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 228)];
    _mengbanView.backgroundColor = [UIColor blackColor];
    _mengbanView.alpha = 0.3;
    [_MyheaderView addSubview:_mengbanView];
    
    //遮罩
    _ZheZhaoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 228)];
    _ZheZhaoImageView.image = [UIImage imageNamed:@"半透明渐变"];
    [_MyheaderView addSubview:_ZheZhaoImageView];
    
    _PlanNameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 160 , SCREENWIDTH, 21)];
    //字体加粗
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    _PlanNameLab.font = font;
    _PlanNameLab.textColor = [UIColor whiteColor];
    
    [self setmyLabel:_PlanNameLab];
    [_ZheZhaoImageView addSubview:_PlanNameLab];
    
    _PlanDetailLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 192 , SCREENWIDTH, 21)];
    _PlanDetailLab.font = [UIFont systemFontOfSize:12];
    _PlanDetailLab.textColor = [UIColor whiteColor];
    [self setmyLabel:_PlanDetailLab];
    [_ZheZhaoImageView addSubview:_PlanDetailLab];
    
    [_courseDetailsTableView addSubview:_MyheaderView];

}
//设置阴影
-(void)setmyLabel:(UILabel*)sender
{
    sender.layer.shadowColor = [[UIColor blackColor] CGColor];
    sender.layer.shadowOffset = CGSizeMake(3, 3);
    sender.layer.shadowOpacity = 0.5;
    sender.layer.shadowRadius = 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.playShowArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classcell"];
    if (!cell) {
        cell = [[ClassCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"classcell"];
    }
   
    cell.delegate = self;
 
    cell.cellArr = self.playShowArray[indexPath.section];
    cell.countArray = self.countMutableArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LRLog(@"点击了cell");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.warmArray.count==0 && self.StrenchArray.count == 0  && self.MainArray.count != 0)
    {
        return 143;
    }
    
    if (self.warmArray.count==0 && self.StrenchArray.count != 0  && self.MainArray.count == 0) {
        
        return 123;
    }
    if (self.warmArray.count != 0 && self.StrenchArray.count != 0  && self.MainArray.count == 0) {
        
        return 123;
    }
    
    if (self.warmArray.count == 0&&self.MainArray.count != 0 && self.StrenchArray.count != 0) {
        
        if (indexPath.section == 0)
        {
            
            return 143;
        }
        else if (indexPath.section == 1)
        {
            return 123;
        }
    }
    
    
    if (self.warmArray.count != 0 &&self.MainArray.count != 0 && self.StrenchArray.count == 0) {
        if (indexPath.section == 0)
        {
            return 123;
        }
        else if (indexPath.section == 1)
        {
            return 143;
        }
    }
    
    
    if (self.warmArray.count != 0 && self.MainArray.count != 0 && self.StrenchArray.count != 0) {
        if (indexPath.section == 0 ||indexPath.section == 2)
        {
            return 123;
        }
        else
        {
            return 143;
        }
    
    }
    if (self.warmArray.count != 0 && self.MainArray.count == 0 && self.StrenchArray.count == 0) {
        return 123;
    }
    return 143;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREENWIDTH, 30)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    //headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:48/255.0f green:48/255.0f blue:48/255.0f alpha:1];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    headerLabel.frame = CGRectMake(15, 16, 300.0, 14);
    
    NSInteger warmNum = 0;
    NSInteger MainNum = 0;
    NSInteger strentNum = 0;
    
    if (self.MainArray.count != 0)
    {
        for (previewModel *model in self.MainArray)
        {
            if ([model.type isEqualToString:@"common"])
            {
                
            }
            else
            {
                MainNum++;
            }
        }

    }
    
    if (self.warmArray.count != 0)
    {
        for (previewModel *model in self.warmArray)
        {
            if ([model.type isEqualToString:@"common"])
            {
                
            }
            else
            {
                warmNum++;
            }
        }
    }
    
    if (self.StrenchArray.count != 0)
    {
        for (previewModel *model in self.StrenchArray)
        {
            if ([model.type isEqualToString:@"common"])
            {
                
            }
            else
            {
                strentNum++;
            }
        }
    }

    if (self.warmArray.count !=0 && self.StrenchArray.count == 0  && self.MainArray.count == 0) {
        headerLabel.text = [NSString stringWithFormat:@"热身动作（%ld 个 ）",(long)warmNum];
        customView.backgroundColor = [UIColor whiteColor];
    }
    if (self.warmArray.count==0 && self.StrenchArray.count == 0  && self.MainArray.count != 0) {
        
        headerLabel.text = [NSString stringWithFormat:@"主要动作（%ld 个 ）",(long)MainNum];
        customView.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.warmArray.count==0 && self.StrenchArray.count != 0  && self.MainArray.count == 0) {
        
        headerLabel.text = [NSString stringWithFormat:@"拉伸动作（%ld 个 ）",(long)strentNum];
        customView.backgroundColor = [UIColor whiteColor];
    }
    if (self.warmArray.count != 0 && self.StrenchArray.count != 0  && self.MainArray.count == 0) {
        
        if (section == 0)
        {
            
            headerLabel.text = [NSString stringWithFormat:@"热身动作（%ld 个 ）",(long)warmNum];
            customView.backgroundColor = [UIColor whiteColor];
            
            
        }
        else if (section == 1)
        {
            headerLabel.text = [NSString stringWithFormat:@"拉伸动作（%ld 个 ）",(long)strentNum];
            customView.backgroundColor = [UIColor whiteColor];
        }

        
        
    }
    
    if (self.warmArray.count == 0&&self.MainArray.count != 0 && self.StrenchArray.count != 0) {
        
        if (section == 0)
        {
            
            headerLabel.text = [NSString stringWithFormat:@"主要动作（%ld 个 ）",(long)MainNum];
            customView.backgroundColor = [UIColor whiteColor];
            
            
        }
        else if (section == 1)
        {
            headerLabel.text = [NSString stringWithFormat:@"拉伸动作（%ld 个 ）",(long)strentNum];
            customView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    
    if (self.warmArray.count != 0 &&self.MainArray.count != 0 && self.StrenchArray.count == 0) {
        if (section == 0)
        {
            
            headerLabel.text = [NSString stringWithFormat:@"热身动作（%ld 个 ）",(long)warmNum];
            customView.backgroundColor = [UIColor whiteColor];
            
            
        }
        else if (section == 1)
        {
            headerLabel.text = [NSString stringWithFormat:@"主要动作（%ld 个 ）",(long)MainNum];
            customView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    
    if (self.warmArray.count != 0 && self.MainArray.count != 0 && self.StrenchArray.count != 0) {
        if (section == 0)
        {
            
            headerLabel.text = [NSString stringWithFormat:@"热身动作（%ld 个 ）",(long)warmNum];
            customView.backgroundColor = [UIColor whiteColor];
            
            
        }
        else if (section == 1)
        {
            headerLabel.text = [NSString stringWithFormat:@"主要动作（%ld 个 ）",(long)MainNum];
            customView.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            
            headerLabel.text = [NSString stringWithFormat:@"拉伸动作（%ld 个 ）",(long)strentNum];
            customView.backgroundColor = [UIColor whiteColor];
            
            
        }
    }
    
    [customView addSubview:headerLabel];
    
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREENWIDTH, 1)];
    views.backgroundColor = [UIColor whiteColor];
    [customView addSubview:views];
    
    return customView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}



- (void)TableViewCellDelsegateWithCollectionDidselection:(NSInteger)index addUrl:(NSString *)url addAction:(NSString *)action{
    
 
    [TalkingData trackEvent:@"课程详情页面_预览了讲解动作"];
    _bgBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    _bgBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self addAvPlayWithUrlString:url];
    } completion:^(BOOL finished) {
        
    }];
    
    
    UITapGestureRecognizer *ViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpView)];
    ViewTap.numberOfTapsRequired = 1;
    ViewTap.numberOfTouchesRequired = 1;
    [_bgBlackView addGestureRecognizer:ViewTap];
    
    
    _action = [[UILabel alloc] initWithFrame:CGRectMake(0, _playerLayer.frame.origin.y-16-17, SCREENWIDTH, 17)];
    
    _action.text = action;
    
    _action.textAlignment = NSTextAlignmentCenter; //水平对齐
    _action.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [_action setTextColor:[UIColor whiteColor]];
    [_bgBlackView addSubview:_action];
    _endLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-200)/2, _playerLayer.frame.size.height+_playerLayer.frame.origin.y+16, 200, 14)];
    
    _endLabel.text = @"轻触退出";
    
    _endLabel.textAlignment = NSTextAlignmentCenter; //水平对齐
    [_endLabel setFont:[UIFont systemFontOfSize:14]];
    [_endLabel setTextColor:[UIColor whiteColor]];
    [_bgBlackView addSubview:_endLabel];
    
    [self.view addSubview:_bgBlackView];
   
    
}

- (void)addAvPlayWithUrlString:(NSString *)playTtemUrlString{
    
   // [_bgBlackView addSubview:self.testActivityIndicator];
    self.testActivityIndicator.center = _bgBlackView.center;
    [self.testActivityIndicator startAnimating];
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:playTtemUrlString]];
    
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    
    _playerLayer.backgroundColor = (__bridge CGColorRef _Nullable)([[UIColor blackColor] colorWithAlphaComponent:1]);
  
   
    
    
    _playerLayer.frame = CGRectMake(27, (SCREENHEIGHT-((SCREENWIDTH-54)*9/16))/2,(SCREENWIDTH-54) ,(SCREENWIDTH-54)*9/16);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
   
    [_bgBlackView.layer addSublayer:_playerLayer];
     [_player play];
  //  [self performSelector:@selector(stopsss) withObject:nil afterDelay:5];
   
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PreviewingVideoEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
-(void)stopsss
{
    [self.testActivityIndicator stopAnimating];
}
- (void)PreviewingVideoEnd:(NSNotification *)item{
 
    [self jumpView];
}


- (void)jumpView{
    [self.testActivityIndicator removeFromSuperview];
    [_player pause];
    _playerItem = nil;
    _player = nil;
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [_playerLayer removeFromSuperlayer];
    [_endLabel removeFromSuperview];
    [_action removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        _bgBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _playerLayer.backgroundColor = (__bridge CGColorRef _Nullable)([[UIColor blackColor] colorWithAlphaComponent:0]);

    } completion:^(BOOL finished) {
         [_bgBlackView removeFromSuperview];
    }];
   
    
}


- (UIViewController *)getSuperViewController{
    return self;
}
//视频按钮点击方法
-(void)startBtnClcik
{
    

    
    [self StartDownload];
}


//判断是否全部有
- (void)StartDownload{
    LRLog(@"点击了播放按钮");
    if (self.playlistArray.count==0) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    } else {
        
        _isQuanBuYou = 0;
        NSString *archivingPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *caches = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserVideo",[BusinessAirCoach getTel]]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        for ( WarmModel *warm in self.playlistArray) {
            //检查本地文件是否已存在
            NSString *fileName = [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.mp4",warm.hostID]];
            if ([fileManager fileExistsAtPath:fileName]) {
                LRLog(@"文件存在%@",fileName);
                
                 _isQuanBuYou +=1;
            } else {
               
                
            }
            
            
        }
        
        
        if (_isQuanBuYou == self.playlistArray.count) {
            
            
            [self tiaozhuang];
        } else {
            
            _loadIndex = [[BusinessAirCoach getProgressBarToDownloadANumberOfLabels] intValue] ;
            
            // 检测网络连接状态
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
            // 连接状态回调处理
            /* AFNetworking的Block内使用self须改为weakSelf, 避免循环强引用, 无法释放 */
            __weak typeof(self) weakSelf = self;
            [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                
                [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                    [weakSelf jindutiao];
                     [weakSelf  kaishixiazai];
                }
                else if (status == AFNetworkReachabilityStatusReachableViaWWAN)
                {
                    
                    _alertViewBook = [[AlertControllerDZ alloc] initWithFrame:self.view.bounds WithTitle:nil andDetail:@"您正使用移动网络，下载课程可能会造成流量消耗，确定继续？" andCancelTitle:@"取消" andOtherTitle:@"确定" andFloat:66 BtnNum:@"Two" location:NSTextAlignmentCenter];
                    _alertViewBook.detailLabel.textColor = [UIColor blackColor];
                    _alertViewBook.delegate = self;
                    _alertViewBook.tag = 1001;
                    [[UIApplication sharedApplication].keyWindow addSubview:_alertViewBook];
                    
                }
                else
                {
                    PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
                    [[UIApplication sharedApplication].keyWindow addSubview:prom];
                }
                
            }];
            
            
            
            
            
           
           
        }
        
    }
}

- (void)kaishixiazai{
    
   
    
    if (_loadIndex >= self.playlistArray.count) {
        return;
    }
    WarmModel *warm = self.playlistArray[_loadIndex];
    
    [CommonUtil sessionDownloadWithUrl:warm.url fileName:warm.hostID success:^(NSDictionary *allHeaders, NSURL *fileURL) {
        
#pragma mark---
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //检查本地文件是否已存在
        if ([fileManager fileExistsAtPath:[fileURL absoluteString]]) {
            LRLog(@"文件存在%@",[fileURL absoluteString]);
            [self RefreshProgressBar];
            
            NSString *file = [[fileURL absoluteString] substringFromIndex:7];
            LRLog(@"%@",file);
            NSString *hashMD5=  [HashMD5Check getFileMD5WithPath:file];
            
            LRLog(@"hashMD5=====%@",hashMD5);
            LRLog(@"allHeadersMD5==%@",[allHeaders objectForKey:@"x-oss-meta-md5"]);
            
            if ([hashMD5 isEqualToString:[allHeaders objectForKey:@"x-oss-meta-md5"]]) {

                
                if ([BusinessAirCoach getProgressBarToDownloadANumberOfLabels].integerValue +1 == _playlistArray.count) {
                    
                  //  [self.bGView removeFromSuperview];
                    self.bGView.hidden = YES;
                    _isQuanBuYou =0;
                    _loadIndex = 0;
                    
                    [BusinessAirCoach setProgressBarToDownloadANumberOfLabels:nil];
                    
                } else {
                  int i  =  [[BusinessAirCoach getProgressBarToDownloadANumberOfLabels] intValue];
                    
                    i++;
                    
                    [BusinessAirCoach setProgressBarToDownloadANumberOfLabels:[NSString stringWithFormat:@"%d",i]];
                     _loadIndex = [[BusinessAirCoach getProgressBarToDownloadANumberOfLabels] intValue];
                    
                    [self kaishixiazai];
                     LRLog(@"开始下载新的");
                   
                }
                
            } else {
                
                LRLog(@"视频不完整");
                if ([fileManager removeItemAtPath:[fileURL absoluteString] error:nil]) {
                    [self kaishixiazai];
                    LRLog(@"删除视频重新下载");
                }
            }
        
        
        }
        
    } fail:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (!error) {
            LRLog(@"文件不存在 下载成功%@",filePath);
            
            [self RefreshProgressBar];
            

            
             
            if ([BusinessAirCoach getProgressBarToDownloadANumberOfLabels].integerValue +1 == _playlistArray.count) {
                
                   //  [self.bGView removeFromSuperview];
                    self.bGView.hidden = YES;
                     _isQuanBuYou =0;
                     _loadIndex = 0;
                
                [BusinessAirCoach setProgressBarToDownloadANumberOfLabels:nil];
            
            } else {
                
                NSString *file = [[filePath absoluteString] substringFromIndex:7];
                LRLog(@"%@",file);
                
                NSString *hashMD5=  [HashMD5Check getFileMD5WithPath:file];
                
                LRLog(@"hashMD5=====%@",hashMD5);
                
                
                NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                NSDictionary *dic = res.allHeaderFields;
                LRLog(@"md5String====%@",[dic objectForKey:@"x-oss-meta-md5"]);
                if ([hashMD5 isEqualToString:[dic objectForKey:@"x-oss-meta-md5"]]) {

                    
                    int i  =  [[BusinessAirCoach getProgressBarToDownloadANumberOfLabels] intValue];
                    
                    i++;
                    
                    [BusinessAirCoach setProgressBarToDownloadANumberOfLabels:[NSString stringWithFormat:@"%d",i]];
                    
                    _loadIndex = [[BusinessAirCoach getProgressBarToDownloadANumberOfLabels] intValue];
                    
                    [self kaishixiazai];
                    
                } else {
                    [self kaishixiazai];
                }
                
                
            }
        } else {
            //下载失败
           
            errorNum++;
            if (errorNum >= 3) {
                
                _alertViewBook = [[AlertControllerDZ alloc]initWithFrame:self.view.bounds WithTitle:nil andDetail:@"视频下载失败，请您稍后再试。" andCancelTitle:nil andOtherTitle:@"确定" andFloat:66 BtnNum:@"One" location:NSTextAlignmentCenter];
                _alertViewBook.detailLabel.textColor = [UIColor blackColor];
                _alertViewBook.tag = 10;
                _alertViewBook.delegate = self;
                [[UIApplication sharedApplication].keyWindow addSubview:_alertViewBook];
                
                return ;
            }else{
                [self kaishixiazai];
                LRLog(@"下载失败%@",error);
            }
           

        }
    }];
}


-(void)clickButtonWithTag:(UIButton *)button{
    
    if (button.tag == 308)
    {
        LRLog(@"传过来的是取消按钮");
    }
    if (button.tag == 309)
    {
        if (_alertViewBook.tag == 1001)
        {
            [self jindutiao];
            [self kaishixiazai];
        }
        else
        {
        LRLog(@"确定");
        
        NSString *archivingPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserVideo",[BusinessAirCoach getTel]]];
        
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
        
        for (NSString *p in files) {
            
            NSError *error;
            
            NSString *Path = [path stringByAppendingPathComponent:p];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                
                [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
                
                
            }
        }
        
        
        self.bGView.hidden = YES;
        _isQuanBuYou =0;
        _loadIndex = 0;
        [BusinessAirCoach setProgressBarToDownloadANumberOfLabels:nil];
        
        
    }
  }
}

- (void)jindutiao{
    self.bGView.hidden = NO;
    [self RefreshProgressBar];
    [self.startButton setBackgroundColor: ZhuYao];

    
    
}

#pragma mark---刷新进度条
- (void)RefreshProgressBar{
   
    [UIView animateWithDuration:0.3 animations:^{
         self.progressView.frame = CGRectMake(0, 0, SCREENWIDTH*(float)[[BusinessAirCoach getProgressBarToDownloadANumberOfLabels] intValue]/_playlistArray.count, 50);
    }];
    self.startLabel.text = [NSString stringWithFormat:@"正在下载：%0.f%%",(float)[[BusinessAirCoach getProgressBarToDownloadANumberOfLabels] intValue]/_playlistArray.count*100];
    LRLog(@"f,%f",(float)[[BusinessAirCoach getProgressBarToDownloadANumberOfLabels] intValue]/_playlistArray.count);
    LRLog(@"d,%d",_loadIndex);
}


#pragma mark----跳转播放页面
- (void)tiaozhuang
{
    AvPlayerViewController *avPlayer = [[AvPlayerViewController alloc] init];
    avPlayer.hidesBottomBarWhenPushed = YES;
    avPlayer.playlistARR = _playList;
    avPlayer.AvplayerAllTimes = _AllTimes;
    avPlayer.navigationController.navigationBarHidden = YES;
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
        if (status == AFNetworkReachabilityStatusReachableViaWiFi ||status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            NSDictionary *dic = [BusinessAirCoach getUserUseAudio];
            if (dic == nil || [dic[@"isAudio"] isEqualToString:@"YesAudio"]) {
                avPlayer.isAudio = @"HaveAudio" ;
                
                [weakSelf presentViewController:avPlayer animated:YES completion:nil];
                
            }
            else
            {
              
                [weakSelf presentViewController:avPlayer animated:YES completion:nil];
            }
        }
        else
        {
            [weakSelf presentViewController:avPlayer animated:YES completion:nil];
        }
        
    }];

    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat offsetY = scrollView.contentOffset.y;//注意
   
    if (offsetY > -228 && offsetY <= -158 ) {
        
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.navigationController.navigationBar.tintColor=[UIColor blackColor];
        
        self.titleLabel.textColor = ZhuYao;
        self.navigationItem.leftBarButtonItem.image = _NormalImage;
        _alphaMemory = 1 - (ABS(offsetY) - 158) / 70 >= 1 ? 1 :1 - (ABS(offsetY) - 158) / 70;
        
        self.maoboliView.alpha = _alphaMemory;
        _bottomBlackView.alpha = _alphaMemory;
        
        
    }
    else if (offsetY > -128)
    {
        
        //_alphaMemory = 1 - ABS(offsetY * 0.3) / 228 >= 1 ? 1 :1 - ABS(offsetY * 0.3)/228;
        _alphaMemory = 1;
        self.maoboliView.alpha = _alphaMemory;
        _bottomBlackView.alpha = _alphaMemory;
        
       
    }
    
    else if (offsetY <= -228) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem.image = _WhiteImage;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.maoboliView.alpha = 0;
        _bottomBlackView.alpha = 0;
        
        
        //_courseDetailsTableView.contentOffset.y为负值 实际为求得新的头部图的y值
        _headerImageView.frame = CGRectMake((_courseDetailsTableView.contentOffset.y+228) / 2, _courseDetailsTableView.contentOffset.y+228, SCREENWIDTH+(-_courseDetailsTableView.contentOffset.y)-228, -_courseDetailsTableView.contentOffset.y);
        _ZheZhaoImageView.frame = CGRectMake((_courseDetailsTableView.contentOffset.y+228)/2, _courseDetailsTableView.contentOffset.y+228, SCREENWIDTH+(-_courseDetailsTableView.contentOffset.y)-228, -_courseDetailsTableView.contentOffset.y);
        _mengbanView.frame = CGRectMake((_courseDetailsTableView.contentOffset.y+228)/2, _courseDetailsTableView.contentOffset.y+228, SCREENWIDTH+(-_courseDetailsTableView.contentOffset.y)-228, -_courseDetailsTableView.contentOffset.y);
        
        //标签操作
        _PlanNameLab.x = -(_courseDetailsTableView.contentOffset.y+ 228) / 2 + 15;
        _PlanNameLab.y = -(_courseDetailsTableView.contentOffset.y+ 228) + 160;
        _PlanDetailLab.x = -(_courseDetailsTableView.contentOffset.y+228) / 2 + 15;
        _PlanDetailLab.y = -(_courseDetailsTableView.contentOffset.y+ 228) + 192;
        
        
        
    }

    

    
    
}



#pragma mark----/**存储数据**/

//创建表
- (void)createSQLite:(NSString *)sqlName {
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@%ld.sqlite",sqlName,[BusinessAirCoach getTel],(long)_UrlID] dbHandler:^(FMDatabase *nn_db) {
       
        NSString *cSql = nil;
        if ([sqlName isEqualToString:@"UserCourseDetails"]) {
             cSql = @"CREATE TABLE IF NOT EXISTS OLD (id INTEGER PRIMARY KEY, UserID TEXT NOT NULL, UserCourseDetails TEXT NOT NULL)";
        } else {
            cSql = @"CREATE TABLE IF NOT EXISTS OLD (id INTEGER PRIMARY KEY, UserID TEXT NOT NULL, UserCourseList TEXT NOT NULL)";
        }
        
        BOOL res = [nn_db executeUpdate:cSql];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"succ to creating db table");
        }
    }];
}
//存数据
- (void)insertData:(NSString *)modelArray addSqlName:(NSString *)sqlName{
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@%ld.sqlite",sqlName,[BusinessAirCoach getTel],(long)_UrlID]  dbHandler:^(FMDatabase *nn_db) {
        
        NSString *sql = nil;
         if ([sqlName isEqualToString:@"UserCourseDetails"]) {
             
             sql = @"insert into OLD (UserID, UserCourseDetails) values(?, ?)";
         }else {
             sql = @"insert into OLD (UserID, UserCourseList) values(?, ?)";
         }
        
        NSData *UserCourseDetails = [NSKeyedArchiver archivedDataWithRootObject:modelArray];
        NSString *UserID = [BusinessAirCoach getTel];
        BOOL res = [nn_db executeUpdate:sql,UserID, UserCourseDetails];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"OK");
        }
    }];
}
//取数据
- (void)queryData:(NSString *)sqlName{
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@%ld.sqlite",sqlName,[BusinessAirCoach getTel],(long)_UrlID]  dbHandler:^(FMDatabase *nn_db) {
        NSString *qSql = @"SELECT * FROM OLD WHERE UserID = ?";
        FMResultSet *set = [nn_db executeQuery:qSql,[BusinessAirCoach getTel]];
        
        if ([sqlName isEqualToString:@"UserCourseDetails"]) {
            while ([set next]) {
                
                NSData *CourseData = [set dataForColumn:@"UserCourseDetails"];
                
                
                _courseModel = [CourseModel mj_objectWithKeyValues:[NSKeyedUnarchiver unarchiveObjectWithData:CourseData]];
                
                
                _coachModel = [CoachModel mj_objectWithKeyValues:_courseModel.coach];
                
                [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_courseModel.backgroud] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
                _PlanDetailLab.text = [NSString stringWithFormat:@"%ld个动作 约%d分钟 已完成 %ld/%ld 次",(long)_courseModel.action_count,_courseModel.length/60,(long)_courseModel.complete,(long)_courseModel.total];
                _PlanNameLab.text = [NSString stringWithFormat:@"%@",_courseModel.name];
                _AllTimes = _courseModel.length;
                LRLog(@"%ld",(long)_courseModel.coach_id);
                
                for (WarmModel *warm in _courseModel.warm) {
                    [self.playlistArray   addObject:warm];
                    [self.reShengArray addObject:warm];
                    
                    previewModel *public = [previewModel mj_objectWithKeyValues:warm];
                    
                    [self.warmArray addObject:public];
                    
                }
                
                for (WarmModel *warm in _courseModel.main) {
                    
                    [self.playlistArray  addObject:warm];
                    [self.zhuYaoArray addObject:warm];
                  
                    previewModel *public = [previewModel mj_objectWithKeyValues:warm];
                    
                    [self.MainArray addObject:public];
                    
                }
                for (WarmModel *warm in _courseModel.stretch) {
                    
                    [self.playlistArray  addObject:warm];
                    [self.laShengArray addObject:warm];
                    previewModel *public = [previewModel mj_objectWithKeyValues:warm];
                    
                    
                    [self.StrenchArray addObject:public];
                    
                }
                
                
                if (self.warmArray.count != 0) {
                    [self.playShowArray addObject:self.warmArray];
                    [self.countMutableArray addObject:self.reShengArray];
                }
                
                if (self.MainArray.count != 0) {
                    [self.playShowArray addObject:self.MainArray];
                    [self.countMutableArray addObject:self.zhuYaoArray];
                }
                if (self.StrenchArray.count  != 0) {
                    [self.playShowArray addObject:self.StrenchArray];
                    [self.countMutableArray addObject:self.laShengArray];
                }
                
                [self.courseDetailsTableView reloadData];
            }
        } else {
            _playList = nil;
             while ([set next])
             {
                 
              NSData *CourseList = [set dataForColumn:@"UserCourseList"];
              _playList = [PlanList mj_objectArrayWithKeyValuesArray:[NSKeyedUnarchiver unarchiveObjectWithData:CourseList]];
            
             }
        }
        
        
    }];
}
//取数据
- (NSArray*)queryOldData:(NSString *)sqlName{
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@.sqlite",sqlName,[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
        NSString *qSql = @"SELECT * FROM OLD WHERE UserID = ?";
        FMResultSet *set = [nn_db executeQuery:qSql,[BusinessAirCoach getTel]];
        _playList = nil;
        while ([set next])
            {
                
                NSData *CourseList = [set dataForColumn:@"UserCourseList"];
                _playList = [PlanList mj_objectArrayWithKeyValuesArray:[NSKeyedUnarchiver unarchiveObjectWithData:CourseList]];
                _MyresponseObject = [NSKeyedUnarchiver unarchiveObjectWithData:CourseList];
            }
    }];
    return _playList;
}
//删除数据
- (void)deleteData:(NSString *)sqlName type:(NSString*)oldOrNew{
    //删老的还是新的
    if ([oldOrNew isEqualToString:@"old"])
    {
        [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@.sqlite",sqlName,[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
            NSString *dSql = @"DELETE FROM OLD WHERE UserID = ?";
            BOOL res = [nn_db executeUpdate:dSql,[BusinessAirCoach getTel]];
            if (!res) {
                NSLog(@"error to DELETE data");
            } else {
                NSLog(@"succ to DELETE data");
                
            }
        }];

    }
    else
    {
        [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@%ld.sqlite",sqlName,[BusinessAirCoach getTel],(long)_UrlID]  dbHandler:^(FMDatabase *nn_db) {
            NSString *dSql = @"DELETE FROM OLD WHERE UserID = ?";
            BOOL res = [nn_db executeUpdate:dSql,[BusinessAirCoach getTel]];
            if (!res) {
                NSLog(@"error to DELETE data");
            } else {
                NSLog(@"succ to DELETE data");
                
            }
        }];
 
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
#pragma mark ---处理内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (!self.view.window) {
            
            [self.countMutableArray removeAllObjects];
            [self.reShengArray removeAllObjects];
            [self.laShengArray removeAllObjects];
            [self.zhuYaoArray removeAllObjects];
            [self.playlistArray removeAllObjects];
            [self.playShowArray removeAllObjects];
            [self.warmArray removeAllObjects];
            [self.StrenchArray removeAllObjects];
            [self.MainArray removeAllObjects];
            self.playList = nil;
            self.view = nil;
        }
    }
    
}


@end

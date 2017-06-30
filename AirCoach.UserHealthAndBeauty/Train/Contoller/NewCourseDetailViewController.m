//
//  NewCourseDetailViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/2.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "NewCourseDetailViewController.h"
#import "CourseModel.h"
#import "CoachModel.h"
#import "CourseHeadV.h"
#import "StartViewController.h"
#import "ClassCell.h"
@interface NewCourseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITableViewCellDelsegate>
{
   CourseHeadV *couseHeadview;
}
@property (strong, nonatomic)UIImageView *titleImageView;
@property(nonatomic,strong)UITableView *courseDetailsTableView;

//播放列表控件
@property (strong, nonatomic) UIView *bgBlackView;
@property (nonatomic,strong) AVPlayerItem * playerItem;//视频
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;//播放器场景
@property (nonatomic, strong) UILabel *action;
@property (nonatomic, strong) UILabel *endLabel;
//头部视图控件
@property(nonatomic,strong)UIView *MyheaderView;
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UIImageView *ZheZhaoImageView;
@property(nonatomic,strong)UIView *mengbanView;
@property(nonatomic,strong)UILabel *PlanNameLab;
@property(nonatomic,strong)UILabel *PlanDetailLab;
@property(nonatomic,strong)UIButton *displayBtn;//底部按钮展示
//导航栏底部黑线
@property(nonatomic,strong)UIView *bottomBlackView;
@property (nonatomic, strong) UIView *maoboliView;
@property (nonatomic, assign) CGFloat alphaMemory;
//数据群
@property(nonatomic,strong)NSMutableArray *MainArray;
@property(nonatomic,strong)NSMutableArray *StrenchArray;
@property(nonatomic,strong)NSMutableArray *warmArray;
@property(nonatomic,strong)NSMutableArray *playShowArray;
@property(nonatomic,strong)CourseModel *courseModel;
@property(nonatomic,strong)CoachModel *coachModel;

@property(nonatomic,strong)UIImage *NormalImage;//返回键粉色
@property(nonatomic,strong)UIImage *WhiteImage;//返回键白色


@end

@implementation NewCourseDetailViewController
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



- (NSMutableArray *)playShowArray{
    if (!_playShowArray) {
        _playShowArray = [[NSMutableArray alloc] init];
    }
    
    return _playShowArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //添加轻扫手势
    UIScreenEdgePanGestureRecognizer *swipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture)];
    swipeGesture.edges = MASAttributeLeft; //默认向右
    
    [self.view addGestureRecognizer:swipeGesture];
    //设置电池条为白色
    //self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    _titleImageView.image = [UIImage imageNamed:@""];
    _titleImageView.hidden = YES;
    [self.view addSubview:_titleImageView];
    
    self.titleLabel.text = @"训练方案";
    self.titleLabel.textColor = ZhuYao;
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [self creatUI];
    [self iOS8blurAction];
    
    [self createSQLite];
    [self queryData];
    
    _NormalImage = [[UIImage imageNamed:@"Y返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _WhiteImage = [[UIImage imageNamed:@"Y返回白色"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem.image = _WhiteImage;
    
    
    
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
    
    if(_pastOrfutrue == 0)
    {
        _displayBtn.hidden = YES;
    }else
    {
        _displayBtn.hidden = NO;
    }
    
    
    [TalkingData trackPageBegin:@"课程详情页面"];
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
- (void)loadCourseDetailData{
    
     [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeCustom];
    [[HttpsRefreshNetworking Networking] GET:[NSString stringWithFormat:PLANSHOW,(long)_UrlID] parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        
        
        LRLog(@"%@", responseObject);
        
        
        @try {
            
            [self jsonMydata:responseObject];
            [self deleteData];
            [self insertData:responseObject];
            
        } @catch (NSException *exception) {
            
            LRLog(@"解析失败");
        }
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
        LRLog(@"========================  %@",error);
        [SVProgressHUD dismiss];
    }];

    
}
-(void)jsonMydata:(id)responseObject
{
    [self.playShowArray removeAllObjects];
    [self.warmArray removeAllObjects];
    [self.MainArray removeAllObjects];
    [self.StrenchArray removeAllObjects];
    _courseModel = [CourseModel mj_objectWithKeyValues:responseObject];
    
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_courseModel.backgroud] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    
    _PlanDetailLab.text = [NSString stringWithFormat:@"%ld个动作  约%d分钟  已完成 %ld/%ld 次",(long)_courseModel.action_count,_courseModel.length/60,(long)_courseModel.complete,(long)_courseModel.total];
    _PlanNameLab.text = [NSString stringWithFormat:@"%@",_courseModel.name];
    
    _coachModel = [CoachModel mj_objectWithKeyValues:_courseModel.coach];
    couseHeadview.coachModel = _coachModel;
    LRLog(@"%ld",(long)_courseModel.coach_id);
    
    for (WarmModel *warm in _courseModel .warm)
    {
        previewModel *public = [previewModel mj_objectWithKeyValues:warm];
        [self.warmArray addObject:public];
    }
    
    for (WarmModel *warm in _courseModel.main) {
        
        previewModel *public = [previewModel mj_objectWithKeyValues:warm];
        [self.MainArray addObject:public];
        
    }
    for (WarmModel *warm in _courseModel.stretch) {
        
        previewModel *public = [previewModel mj_objectWithKeyValues:warm];
        
        [self.StrenchArray addObject:public];
        
    }
    
    
    if (self.warmArray.count != 0) {
        [self.playShowArray addObject:self.warmArray];
    }
    
    if (self.MainArray.count != 0) {
        [self.playShowArray addObject:self.MainArray];
    }
    if (self.StrenchArray.count  != 0) {
        [self.playShowArray addObject:self.StrenchArray];
    }
    
    
    [self.courseDetailsTableView reloadData];

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

-(void)creatUI
{
    _courseDetailsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT ) style:UITableViewStyleGrouped];
    _courseDetailsTableView.delegate = self;
    _courseDetailsTableView.dataSource = self;
    _courseDetailsTableView.separatorStyle = NO;
    _courseDetailsTableView.showsVerticalScrollIndicator = NO;
    _courseDetailsTableView.contentInset = UIEdgeInsetsMake(228, 0, 49, 0);
    [self.view addSubview:_courseDetailsTableView];
    
    _displayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _displayBtn.frame = CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50);
    _displayBtn.backgroundColor = [UIColor colorWithRed:196/255.f green:196/255.f blue:196/255.f alpha:1];
    [_displayBtn setTitle:@"计划暂未开始" forState:UIControlStateNormal];
    [_displayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _displayBtn.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_displayBtn];
    
    [self createHeadView];
    
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
-(void)swipeGesture
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if (self.warmArray.count !=0 && self.StrenchArray.count == 0 && self.MainArray.count == 0) {
        
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
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [_action setFont:font];
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
    
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:playTtemUrlString]];
    
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    
    _playerLayer.backgroundColor = (__bridge CGColorRef _Nullable)([[UIColor blackColor] colorWithAlphaComponent:1]);
    
    
    
    
    _playerLayer.frame = CGRectMake(27, (SCREENHEIGHT-((SCREENWIDTH-54)*9/16))/2,(SCREENWIDTH-54) ,(SCREENWIDTH-54)*9/16);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [_bgBlackView.layer addSublayer:_playerLayer];
    [_player play];
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PreviewingVideoEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
- (void)PreviewingVideoEnd:(NSNotification *)item{
    
    [self jumpView];
}
- (void)jumpView{
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

- (void)iOS8blurAction {
    
    _maoboliView = [[UIView alloc]init];
    _maoboliView.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
    _maoboliView.backgroundColor = [UIColor whiteColor];
    _maoboliView.alpha = 0;
    
    _bottomBlackView = [[UIView alloc]init];
    _bottomBlackView.frame = CGRectMake(0, 63.5, SCREENWIDTH, 0.5);
    _bottomBlackView.backgroundColor = BottomlineColor;
    _bottomBlackView.alpha = 0;
    
    [_maoboliView addSubview:_bottomBlackView];
    
    [self.view addSubview:_maoboliView];
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
#pragma mark--缓存处理
//创建表
- (void)createSQLite{
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"NewCoursDetailData%@%ld.sqlite",[BusinessAirCoach getTel],(long)_UrlID] dbHandler:^(FMDatabase *nn_db) {
        NSString *cSql = @"CREATE TABLE IF NOT EXISTS OLD (id INTEGER PRIMARY KEY, UserID TEXT NOT NULL, NewCoursData TEXT NOT NULL)";
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
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"NewCoursDetailData%@%ld.sqlite",[BusinessAirCoach getTel],(long)_UrlID]  dbHandler:^(FMDatabase *nn_db) {
        NSString * sql = @"insert into OLD (UserID, NewCoursData) values(?, ?)";
        NSData *NewCoursData = [NSKeyedArchiver archivedDataWithRootObject:modelArray];
        NSString *UserID = [BusinessAirCoach getTel];
        BOOL res = [nn_db executeUpdate:sql, UserID, NewCoursData];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"OK");
        }
    }];
}
//取数据
- (void)queryData{
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"NewCoursDetailData%@%ld.sqlite",[BusinessAirCoach getTel],(long)_UrlID]  dbHandler:^(FMDatabase *nn_db) {
        NSString *qSql = @"SELECT * FROM OLD WHERE UserID = ?";
        FMResultSet *set = [nn_db executeQuery:qSql,[BusinessAirCoach getTel]];
        while ([set next]) {
            
            NSData *StageData = [set dataForColumn:@"NewCoursData"];
            [self jsonMydata:[NSKeyedUnarchiver unarchiveObjectWithData:StageData]];
        }
    }];
}
//删除数据
- (void)deleteData {
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"NewCoursDetailData%@%ld.sqlite",[BusinessAirCoach getTel],(long)_UrlID]  dbHandler:^(FMDatabase *nn_db) {
        NSString *dSql = @"DELETE FROM OLD WHERE UserID = ?";
        BOOL res = [nn_db executeUpdate:dSql,[BusinessAirCoach getTel]];
        if (!res) {
            NSLog(@"error to DELETE data");
        } else {
            NSLog(@"succ to DELETE data");
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

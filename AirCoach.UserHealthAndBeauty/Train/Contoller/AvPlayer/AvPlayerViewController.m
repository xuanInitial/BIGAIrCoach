//
//  AvPlayerViewController.m
//  AirCoach.acUser
//
//  Created by xuan on 15/11/27.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "AvPlayerViewController.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
#import "PlanList.h"
#import "ICSandboxHelper.h"
#import "IntegralButton.h"
#import "AVEndViewController.h"
#import "RootTabBarController.h"
#import "previewModel.h"
#import "iflyMSC/iflyMSC.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"

#import "clickClientPro.h"

static NSInteger playLoopCount;//循环次数
#define ac @"abcdefghijklmnopqrstuvwxyz"
#define AC @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"

@interface AvPlayerViewController ()<BackDelegate,AlertControllerDZDelegate,IFlySpeechRecognizerDelegate,clickClientProtocol>
{
  AlertControllerDZ *alertView;  
}
@property (nonatomic, assign) NSInteger localPalyCount;//本地计数（用来统计取数组的第几个，包含主要动作）

@property (nonatomic,assign)NSInteger MainMovePlayCount;//本地主要动作计数(用来统计除休息之外的动作)

@property(nonatomic,assign)NSInteger MainCount;//除休息动作之外的动作总数

@property (nonatomic, strong) UIButton *playBtn;//播放按钮
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *actionExplanationBtn;//动作讲解按钮

@property (nonatomic, strong) UIView *bgHeadView;

@property (nonatomic, strong)UIVisualEffectView *bgView;

@property (nonatomic, strong)UIImageView *imageView;


@property (nonatomic,strong) AVPlayerItem * playerItem;//视频

@property (nonatomic, strong) PlanList *playListModel;
@property (nonatomic,strong) NSString *pathUrl;//沙盒路径

@property (nonatomic,assign) int cycleCountNum;
@property (nonatomic ,strong) UIButton *bgBtnView;//背景透明view
@property (nonatomic, strong) UIButton *overBtn;//暂停关闭
//@property (nonatomic, assign) BOOL btnViewBool;

@property (nonatomic, strong) AVPlayer *player_0;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;//播放器场景



@property (strong, nonatomic) NSMutableArray *stateArr;

@property (assign, nonatomic) int stateNum;


//在线播放页面相关
@property (strong, nonatomic) UIView *bgBlackView;

@property (nonatomic, strong) UILabel *action;


@property (nonatomic, strong) UILabel *endLabel;

@property (nonatomic,strong) AVPlayerItem * playerItem_2;//视频
@property (nonatomic, strong) AVPlayer *player_2;
@property (nonatomic, strong) AVPlayerLayer *playerLayer_2;//播放器场景

@property(nonatomic,strong)UIImageView *AudioView;

@property(nonatomic,strong)UIView *firView;
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property(nonatomic,strong)NSString *result;
@property(nonatomic,strong)UIImageView *MikeView;
@property(nonatomic)BOOL CheckReady;

@property(nonatomic,strong)UILabel *volomLab;

//剩余时间
@property(nonatomic,strong)UILabel *afterTime;
//进度条

@property (nonatomic, strong) UIView *ProgressBarView;

@property (nonatomic, strong) UILabel *nameLabel;


@property (nonatomic, strong) UIImageView *yuyinImage;

//用于识别手势的透明view
@property(nonatomic,strong)UIView *tapClearView;

@end


@implementation AvPlayerViewController


- (BOOL)shouldAutorotate
{
   // LRLog(@"让不让我旋转?");
    return YES;
}
////强制横屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
   // LRLog(@"让我旋转哪些方向");
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    playLoopCount = 0;
    _cycleCountNum = 0;
    self.localPalyCount =0;
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    
     [TalkingData trackPageBegin:@"训练视频播放页面"];
    
     [self initRecognizer];//初始化识别对象
}


#pragma mark---研究一下这句话的意识


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
// [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [TalkingData trackPageEnd:@"训练视频播放页面"];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _stateArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    [self createData];
    [self createUI];
    
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([delegete.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        RootTabBarController *rootBar =(RootTabBarController*)delegete.window.rootViewController;
        rootBar.clientDelegate = self;
    }
    
    
}
#pragma mark ---clientDelegate
-(void)pauseTheMV
{
    [_player_0 pause];
    _playerItem = nil;
    _player_0 = nil;
    
    [self.player_0.currentItem cancelPendingSeeks];
    [self.player_0.currentItem.asset cancelLoading];
    if (_playerItem_2) {
        [_player_2 pause];
        _playerItem_2 = nil;
        _player_2 = nil;
        [self.player_2.currentItem cancelPendingSeeks];
        [self.player_2.currentItem.asset cancelLoading];
    }
  
}
- (void)createData
{
    LRLog(@"%@",_playlistARR);
    LRLog(@"%ld",(unsigned long)_playlistARR.count);
    for (PlanList *mode in _playlistARR) {
        if ([mode.type isEqualToString:@"pos_start"]) {
            [_stateArr addObject:mode];
        }
    }
}
//返回YES表示同时支持识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
    
}
- (void)createUI {
   
    NSString *archivingPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    _pathUrl = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserVideo",[BusinessAirCoach getTel]]];
    WS(ws);
    self.view.backgroundColor = [UIColor whiteColor];
    
    //主要动作计数
    _MainMovePlayCount = 0;
    _MainCount = 0;
    for (int i = 0; i < self.playlistARR.count; i++)
    {
        PlanList *plan = self.playlistARR[i];
        if ([plan.type isEqualToString:@"common"])
        {
            NSLog(@"这是休息动作不计数");
        }
        else
        {
            _MainCount++;
        }
    }

    
    
    
    
    if (self.playlistARR != nil) {
       _playListModel = [self.playlistARR objectAtIndex:0];
        
    }
  
  
    LRLog(@"======= %@",_playListModel.url);
    NSString *strUrl = [NSString stringWithFormat:@"%@/%ld.mp4",_pathUrl,(long)_playListModel.hostID];
    
    LRLog(@"%@",strUrl);
    
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:strUrl]];
    
    self.player_0 = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player_0];
    _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    _playerLayer.frame = CGRectMake(0, 0, SCREENHEIGHT,SCREENWIDTH);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:_playerLayer];
    
#pragma mark---创建视频播放页面的按钮
    _tapClearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, SCREENWIDTH)];
    _tapClearView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tapClearView];
    //左右滑手势
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftBtnClicak:)];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnClicak:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgBtnViewClick)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [_tapClearView addGestureRecognizer:leftSwipeGestureRecognizer];
    [_tapClearView addGestureRecognizer:rightSwipeGestureRecognizer];
    [_tapClearView addGestureRecognizer:tapGestureRecognizer];
    
#pragma mark---创建视频播放页面的按钮
    _bgBtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, SCREENWIDTH)];
    [_bgBtnView addTarget:self action:@selector(bgBtnViewClick) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:_bgBtnView];
    
    
    //毛玻璃
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _bgView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    _bgView.frame = CGRectMake(0, 0, SCREENHEIGHT, SCREENWIDTH);
    _bgView.alpha = 1.0;
    _bgView.hidden = YES;
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
    _bgHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, SCREENWIDTH)];
    _bgHeadView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _bgHeadView.hidden = YES;
    [_bgView addSubview:_bgHeadView];

    
    //开始暂停按钮
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.hidden = YES;
    [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
   [_playBtn setImage:[UIImage imageNamed:@"视频播放暂停页-播放"] forState:UIControlStateNormal];

    [_bgView addSubview:_playBtn];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).with.offset(0);
        make.left.equalTo(ws.view).with.offset(110);
      
        make.size.mas_equalTo(CGSizeMake(SCREENHEIGHT- 220,SCREENWIDTH));
    }];
    //默认按钮是高亮状态，开始播放
    _playBtn.selected = YES;
    
  
    
    
    //关闭按钮
    _overBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _overBtn.hidden = YES;
    [_overBtn setBackgroundImage:[UIImage imageNamed:@"视频播放暂停页-关闭"] forState:UIControlStateNormal];
    [_overBtn addTarget:self action:@selector(bbtClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_overBtn];
    [_overBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).with.offset(0);
        make.left.equalTo(ws.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    
    
    
    
    //上一个动作
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     _leftBtn.hidden = YES;
    [_leftBtn addTarget:self action:@selector(leftBtnClicak:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn setImage:[UIImage imageNamed:@"视频播放暂停页-后退"] forState:UIControlStateNormal];
    [_bgView addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view).with.offset(0);
        make.left.equalTo(ws.view).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    
    //下一个动作
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.hidden = YES;
    _rightBtn.userInteractionEnabled = YES;
    [_rightBtn addTarget:self action:@selector(rightBtnClicak:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setImage:[UIImage imageNamed:@"视频播放暂停页-前进"] forState:UIControlStateNormal];
    [_bgView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view).with.offset(0);
        make.right.equalTo(ws.view).with.offset(-3);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    
    
    //下一个动作
    _actionExplanationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionExplanationBtn.hidden = YES;
    _actionExplanationBtn.userInteractionEnabled = YES;
    [_actionExplanationBtn addTarget:self action:@selector(actionExplanationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionExplanationBtn setImage:[UIImage imageNamed:@"视频播放暂停页-动作详解"] forState:UIControlStateNormal];
    [_bgView addSubview:_actionExplanationBtn];
    [_actionExplanationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).with.offset(0);
        make.right.equalTo(ws.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    
    
    //进度条
    _ProgressBarView = [[UIView alloc] init];
    _ProgressBarView.backgroundColor = [UIColor whiteColor];
    
    [_bgView addSubview:_ProgressBarView];
    [_ProgressBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).with.offset(0);
        make.bottom.equalTo(ws.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREENHEIGHT, 4*WIDTHBASE));
    }];
    
    LRLog(@"%ld",_playlistARR.count);
    
    CGFloat ViewX = 0;
    int RestNum = 0;
    //判断有多少个休息动作
    for (PlanList *plan in _playlistARR)
    {
        
        if ([plan.type isEqualToString:@"common"])
        {
            RestNum++;
        }
    }
    //除休息以外的动作长度
    CGFloat MainMoveLenght = (SCREENHEIGHT - ((_playlistARR.count-1)*1) - RestNum * 11) /(_playlistARR.count - RestNum);
    //创建进度条
    for (int i = 0; i < _playlistARR.count; i++) {
        
        UIView *view = [UIView new];
        
        PlanList *plan = _playlistARR[i];
        if ([plan.type isEqualToString:@"common"])
        {
            
            view = [[UIView alloc] initWithFrame:CGRectMake(ViewX + 1 * i, 0,11,4)];
            
            ViewX += 11;
            
        }
        else
        {
            view = [[UIView alloc] initWithFrame:CGRectMake(ViewX + 1 * i, 0,MainMoveLenght, 4)];
            
            ViewX += MainMoveLenght;
            

        }

        view.tag = i+200;
        view.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1];
     
        [_ProgressBarView addSubview:view];
    }
    
    //名字label
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textAlignment = NSTextAlignmentCenter; //水平对齐
    _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [_bgView addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).with.offset(0);
        make.bottom.equalTo(ws.view).with.offset(-41);
        make.size.mas_equalTo(CGSizeMake(SCREENHEIGHT, 16));
    }];
    
    _afterTime = [[UILabel alloc] init];
    _afterTime.textAlignment = NSTextAlignmentCenter; //水平对齐
    [_afterTime setFont:[UIFont systemFontOfSize:14]];
    [_afterTime setTextColor:afterColor];
    [_bgView addSubview:_afterTime];
    
    [_afterTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).with.offset(0);
        make.bottom.equalTo(ws.view).with.offset(-19);
        make.size.mas_equalTo(CGSizeMake(SCREENHEIGHT, 14));
    }];

    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upDataControl:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
  
    
    //语音控制view
    
 
    if (_isAudio != nil &&[_isAudio isEqualToString:@"HaveAudio"])
    {
        
        [self AudioControlView];
        _CheckReady = NO;
        _bgBtnView.userInteractionEnabled = NO;
    }
    else
    {
        [_player_0 play];  
    }
}

//语音控制view
-(void)AudioControlView
{
    WS(ws);
    //语音播放背景图
    _AudioView = [UIImageView new];
    [self.view addSubview:_AudioView];
    [_AudioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left);
        make.right.equalTo(ws.view.mas_right);
        make.top.equalTo(ws.view.mas_top);
        make.bottom.equalTo(ws.view.mas_bottom);
    }];
    _AudioView.image = [UIImage imageNamed:@"语音-背景图"];
    [self.view bringSubviewToFront:_AudioView];
    _AudioView.userInteractionEnabled = YES;
    
    //话筒
    _MikeView = [UIImageView new];
    [_AudioView addSubview:_MikeView];
    [_MikeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@104);
        make.height.equalTo(@104);
        make.top.equalTo(_AudioView.mas_top).offset((SCREENWIDTH * 0.28));
        make.centerX.equalTo(_AudioView.mas_centerX);
    }];
    _MikeView.image = [UIImage imageNamed:@"icon-语音"];
    
    
    //话筒
//    _volomLab = [UILabel new];
//    [_AudioView addSubview:_volomLab];
//    [_volomLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@104);
//        make.height.equalTo(@15);
//        make.top.equalTo(_AudioView.mas_top).offset((SCREENWIDTH * 0.28));
//        make.centerX.equalTo(_AudioView.mas_centerX);
//    }];
//    _volomLab.font = [UIFont systemFontOfSize:15];
//    _volomLab.textColor = [UIColor redColor];
//    _volomLab.backgroundColor = [UIColor grayColor];
    
    
    
    UIButton *ReAutoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_AudioView addSubview:ReAutoBtn];
    [ReAutoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_AudioView.mas_left);
        make.right.equalTo(_AudioView.mas_right);
        make.bottom.equalTo(_AudioView.mas_bottom);
        make.height.equalTo(@49);
    }];
    ReAutoBtn.backgroundColor = AudioBtnColor;
    [ReAutoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ReAutoBtn.font = [UIFont systemFontOfSize:17];
    [ReAutoBtn setTitle:@"或者点击此处开始" forState:UIControlStateNormal];
    
    UILabel *ReAutolab = [UILabel new];
    [_AudioView addSubview:ReAutolab];
    [ReAutolab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_AudioView.mas_centerX);
        make.bottom.equalTo(ReAutoBtn.mas_top).offset(-17);
        make.height.equalTo(@14);
        make.width.equalTo(@210);
    }];
    ReAutolab.textColor = AudioLabColor;
    ReAutolab.font = [UIFont systemFontOfSize:14];
    ReAutolab.textAlignment = 1;
    ReAutolab.text = @"下次训练前不再使用此语音控制";

    
    _yuyinImage = [[UIImageView alloc] init];
    _yuyinImage.image = [UIImage imageNamed:@"语音未勾选"];
    [_AudioView addSubview:_yuyinImage];
    
    [_yuyinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ReAutoBtn.mas_top).offset(-17);
        make.right.equalTo(ReAutolab.mas_left).offset(-4);
        make.height.equalTo(@13);
        make.width.equalTo(@13);
    }];
    
    //不再提示按钮
    UIButton *CancelAudioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [CancelAudioBtn setBackgroundImage:[UIImage imageNamed:@"语音未勾选"] forState:UIControlStateNormal];
//    [CancelAudioBtn setBackgroundImage:[UIImage imageNamed:@"语音已勾选"] forState:UIControlStateSelected];
//    CancelAudioBtn.backgroundColor = [UIColor redColor];
    [_AudioView addSubview:CancelAudioBtn];
    
    [CancelAudioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ReAutoBtn.mas_top).offset(-10);
        make.right.equalTo(ReAutolab.mas_left).offset(-1);
        make.height.equalTo(@35);
        make.width.equalTo(@35);
    }];
    
    [CancelAudioBtn addTarget:self action:@selector(dissmissTheView:) forControlEvents:UIControlEventTouchUpInside];
    [ReAutoBtn addTarget:self action:@selector(VideoStart) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self startBtnHandler];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(clickAnimation) userInfo:nil repeats:YES];
    
}
//点击不再使用语音系统
-(void)dissmissTheView:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES)
    {
         _yuyinImage.image = [UIImage imageNamed:@"语音已勾选"];
        
        NSDictionary *dic = @{@"isAudio":@"NoAudio"};
        [BusinessAirCoach setUserCanUseAudio:dic];
    }
    else
    {
        _yuyinImage.image = [UIImage imageNamed:@"语音未勾选"];
        NSDictionary *dic = @{@"isAudio":@"YesAudio"};
        [BusinessAirCoach setUserCanUseAudio:dic];
    }
 
}
-(void)clickAnimation
{
    UIImageView *YuanView =[UIImageView new];
    YuanView.image = [UIImage imageNamed:@"语音播放光圈"];
    [_AudioView addSubview:YuanView];
    [_AudioView sendSubviewToBack:YuanView];
    [YuanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@125);
        make.height.equalTo(@125);
        make.centerY.equalTo(_MikeView.mas_centerY);
        make.centerX.equalTo(_AudioView.mas_centerX);
    }];
    
    
    
    
    
    [UIView animateWithDuration:1.5 animations:^{
        YuanView.transform = CGAffineTransformScale(YuanView.transform, 1.7, 1.7);
        YuanView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [YuanView removeFromSuperview];
        
    }];
    
    [self performSelector:@selector(nextOne) withObject:nil afterDelay:0.2];
    
    
    
}
-(void)nextOne
{
    UIImageView *YuanView =[UIImageView new];
    YuanView.image = [UIImage imageNamed:@"光圈"];
    [_AudioView addSubview:YuanView];
    [_AudioView sendSubviewToBack:YuanView];
    [YuanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@125);
        make.height.equalTo(@125);
        make.centerY.equalTo(_MikeView.mas_centerY);
        make.centerX.equalTo(_AudioView.mas_centerX);
    }];
    
    [UIView animateWithDuration:2 animations:^{
        YuanView.transform = CGAffineTransformScale(YuanView.transform, 1.7, 1.7);
        YuanView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [YuanView removeFromSuperview];
    }];
    
}
- (void)startBtnHandler{
    
    LRLog(@"%s[IN]",__func__);
    
    
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {
        LRLog(@"识别开始");
    }else{
        LRLog(@"识别未开始");
    }
    
    
    
    
}
/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    LRLog(@"%s",__func__);
    
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
    
}
/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    LRLog(@"onBeginOfSpeech");
}

-(void)onError:(IFlySpeechError *)errorCode
{
    LRLog(@"识别错误码%@",errorCode);
}
/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
   
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    _volomLab.text = vol;
}
/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    LRLog(@"onEndOfSpeech停止录音");
    if (_CheckReady == NO)
    {
       [_iFlySpeechRecognizer startListening];
    }
}
/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@",resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
   
    
    if (isLast){
        LRLog(@"听写结果(json)：%@测试", self.result);
    }
    NSInteger num = 0;
    NSString *thirdStr = nil;
    if (resultFromJson.length != 0)
    {
        for (int i = 0; i < [resultFromJson length]; i++)
        {
            NSString *temp = [resultFromJson substringWithRange:NSMakeRange(i, 1)];
            if ([temp isEqualToString:@"开"]&&![thirdStr isEqualToString:temp])
            {
                num++;
                thirdStr = temp;
            }else
            {
                if ([temp isEqualToString:@"始"]&& num != 0)
                {
                    num++;
                    break;
                }
            }
            
        }
 
    }
    
    if (num == 2)
    {
       //搜索到开始两个字
        [self VideoStart];
    }
   
}
-(void)VideoStart
{
    [_AudioView removeFromSuperview];
    [_player_0 play];
    _bgBtnView.userInteractionEnabled = YES;
    _CheckReady = YES;
    [_iFlySpeechRecognizer stopListening];
}

- (void)leftBtnClicak:(UIButton *)leftBtn
{
    
 
    
     [TalkingData trackEvent:@"训练视频播放页面_点击了上一个按钮"];

    if (self.localPalyCount-1 >= 0) {
        _leftBtn.hidden = NO;
        self.localPalyCount--;
    
        self.playListModel = self.playlistARR[self.localPalyCount];
        [self runLoopTheMovie];
    
        if (_bgView.hidden == YES)
        {
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"已切换至上一个动作"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
        }
    
    }else {
      
       // [self leftBtnClicak:leftBtn];
        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"当前是第一个动作"];
        [[UIApplication sharedApplication].keyWindow addSubview:prom];
    }
    
    
    
    NSString *planName = _playListModel.preview.name;
    if (([AC rangeOfString:[planName substringFromIndex:planName.length - 1]].length != 0 ||[ac rangeOfString:[planName substringFromIndex:planName.length - 1]].length != 0) && planName != nil && planName.length!= 0)
    {
        planName = [_playListModel.preview.name substringToIndex:_playListModel.preview.name.length - 1];
    }
    _nameLabel.text = planName;
    //计算时长
    NSInteger pastTime = 0;
    for (int i = 0; i < self.localPalyCount; i++)
    {
        PlanList *plan = self.playlistARR[i];
        pastTime += plan.length * [plan.count integerValue];
        if ([plan.type isEqualToString:@"common"])
        {
            NSLog(@"这是休息动作不计数");
        }
        else
        {
            _MainMovePlayCount++;
        }

    }
    
    //判断当前动作是不是休息
    if ([self.playListModel.type isEqualToString:@"common"])
    {
        [_rightBtn setImage:nil forState:UIControlStateNormal];
        [_rightBtn setTitle:@"跳过休息" forState:UIControlStateNormal];
        _rightBtn.font = [UIFont systemFontOfSize:14];
    }
    else
    {
        [_rightBtn setImage:[UIImage imageNamed:@"视频播放暂停页-前进"] forState:UIControlStateNormal];
        [_rightBtn setTitle:nil forState:UIControlStateNormal];
        _MainMovePlayCount++;
    }

    if ((_AvplayerAllTimes - pastTime) / 60 == 0)
    {
        _afterTime.text = [NSString stringWithFormat:@"%ld/%ld 训练剩余不到1分钟",(long)_MainMovePlayCount,(unsigned long)_MainCount];
    }
    else
    {
        _afterTime.text = [NSString stringWithFormat:@"%ld/%ld 训练剩约%ld分钟",(long)_MainMovePlayCount,(unsigned long)_MainCount,(long)(_AvplayerAllTimes - pastTime) / 60];
    }
    
    //清空数据 下次重新算
    _MainMovePlayCount = 0;
    
    UIView *view = [_ProgressBarView viewWithTag:200+_localPalyCount];
    view.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1];
    
    
}

//#warning 有bug 按钮的问题到了  第一个或者或者最后一个还在点击的话 不会崩 但是没反应
- (void)rightBtnClicak:(UIButton *)rightBtn
{
    NSInteger lala = 0;
    for (int i = 0; i < self.playlistARR.count; i++)
    {
       PlanList *plan = self.playlistARR[i];
        lala += plan.length;
    }
  
 [TalkingData trackEvent:@"训练视频播放页面_点击了下一个按钮"];
    if (self.localPalyCount +1 < self.playlistARR.count) {
        _rightBtn.userInteractionEnabled = YES;
        self.localPalyCount++;
        
        if (_bgView.hidden == YES)
        {
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"已切换至下一个动作"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
        }
        
        
        self.playListModel = self.playlistARR[self.localPalyCount];
        
        NSString *planName = _playListModel.preview.name;
        if (([AC rangeOfString:[planName substringFromIndex:planName.length - 1]].length != 0 ||[ac rangeOfString:[planName substringFromIndex:planName.length - 1]].length != 0) && planName != nil && planName.length!= 0)
        {
            planName = [_playListModel.preview.name substringToIndex:_playListModel.preview.name.length - 1];
        }
        _nameLabel.text = planName;
        
        //计算时长
        NSInteger pastTime = 0;
        for (int i = 0; i < self.localPalyCount; i++)
        {
           PlanList *plan = self.playlistARR[i];
           pastTime += plan.length * [plan.count integerValue];
           if ([plan.type isEqualToString:@"common"])
          {
              NSLog(@"这是休息动作不计数");
          }
            else
          {
              _MainMovePlayCount++;
          }
        }
       
        //判断当前动作是不是休息
        if ([self.playListModel.type isEqualToString:@"common"])
        {
            [_rightBtn setImage:nil forState:UIControlStateNormal];
            [_rightBtn setTitle:@"跳过休息" forState:UIControlStateNormal];
            _rightBtn.font = [UIFont systemFontOfSize:14];
        }
        else
        {
            [_rightBtn setImage:[UIImage imageNamed:@"视频播放暂停页-前进"] forState:UIControlStateNormal];
            [_rightBtn setTitle:nil forState:UIControlStateNormal];
            _MainMovePlayCount++;
        }
        
        
        
        if ((_AvplayerAllTimes - pastTime) / 60 == 0)
        {
            _afterTime.text = [NSString stringWithFormat:@"%ld/%ld 训练剩余不到1分钟",(long)_MainMovePlayCount,(unsigned long)_MainCount];
        }
        else
        {
            _afterTime.text = [NSString stringWithFormat:@"%ld/%ld 训练剩约%ld分钟",(long)_MainMovePlayCount,(unsigned long)_MainCount,(long)(_AvplayerAllTimes - pastTime) / 60];
        }
        _MainMovePlayCount = 0;
        
        [self runLoopTheMovie];
            
        
        
    }else {
        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"当前是最后一个动作"];
        [[UIApplication sharedApplication].keyWindow addSubview:prom];
    }
    if (_localPalyCount != 0) {
        
        //防止数组越界
        PlanList *plan = _playlistARR[_localPalyCount - 1];
        UIView *view = [_ProgressBarView viewWithTag:200+ _localPalyCount - 1];
        
        if ([plan.type isEqualToString:@"common"])
        {
            view.backgroundColor = RestColor;
        }
        else
        {
            view.backgroundColor = ZhuYao;
        }

    }
   
}



- (void)bbtClick:(UIButton *)bbt
{
   
     [TalkingData trackEvent:@"训练视频播放页面_退出了训练"];
    
    alertView = [[AlertControllerDZ alloc]initWithFrame:self.view.bounds WithTitle:@"训练尚未结束，您确定要退出此次训练吗？" andDetail:nil andCancelTitle:@"取消" andOtherTitle:@"确定" andFloat:320 BtnNum:@"Two" location:NSTextAlignmentCenter];
    alertView.detailLabel.textColor = [UIColor blackColor];
    alertView.tag = 8;
    alertView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    
}


-(void)clickButtonWithTag:(UIButton *)button{
    
    if (button.tag == 308)
    {
        LRLog(@"传过来的是取消按钮");
        
    }
    if (button.tag == 309)
    {
        LRLog(@"确定");
        
        [_player_0 pause];
        _playerItem = nil;
        _player_0 = nil;
        
        [self.player_0.currentItem cancelPendingSeeks];
        [self.player_0.currentItem.asset cancelLoading];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}


- (void)stopPlaying{
    [_player_0 pause];
    _playerItem = nil;
    _player_0 = nil;
    
    [self.player_0.currentItem cancelPendingSeeks];
    [self.player_0.currentItem.asset cancelLoading];
    if (_playerItem_2) {
        [_player_2 pause];
        _playerItem_2 = nil;
        _player_2 = nil;
        [self.player_2.currentItem cancelPendingSeeks];
        [self.player_2.currentItem.asset cancelLoading];
    }
    
}
#pragma mark---动作讲解按钮
- (void)actionExplanationBtnClick:(UIButton *)sender{
    WS(ws);
     [TalkingData trackEvent:@"训练视频播放页面_查看了动作讲解"];
    PlanList *plan = _playlistARR[_localPalyCount];
    
    
    _bgBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    _bgBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        [ws addAvPlayWithUrlString:plan.preview.url];
    } completion:^(BOOL finished) {
        
    }];
    
    
    UITapGestureRecognizer *ViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpView)];
    ViewTap.numberOfTapsRequired = 1;
    ViewTap.numberOfTouchesRequired = 1;
    [_bgBlackView addGestureRecognizer:ViewTap];
    
    
    _action = [[UILabel alloc] initWithFrame:CGRectMake(0, _playerLayer_2.frame.origin.y-16-17, SCREENWIDTH, 17)];
    
    if (([AC rangeOfString:[plan.preview.name substringFromIndex:plan.preview.name.length - 1]].length != 0 ||[ac rangeOfString:[plan.preview.name substringFromIndex:plan.preview.name.length - 1]].length != 0) && plan.preview.name != nil && plan.preview.name.length!= 0)
    {
       _action.text = [plan.preview.name substringToIndex:plan.preview.name.length - 1];
    }
    else
    {
      _action.text = plan.preview.name;
    }
    _action.textAlignment = NSTextAlignmentCenter; //水平对齐
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [_action setFont:font];
    [_action setTextColor:[UIColor whiteColor]];
    [_bgBlackView addSubview:_action];
    _endLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-200)/2, _playerLayer_2.frame.size.height+_playerLayer_2.frame.origin.y+16, 200, 14)];
    
    _endLabel.text = @"轻触退出";
    
    _endLabel.textAlignment = NSTextAlignmentCenter; //水平对齐
    [_endLabel setFont:[UIFont systemFontOfSize:14]];
    [_endLabel setTextColor:[UIColor whiteColor]];
    [_bgBlackView addSubview:_endLabel];
    
    [self.view addSubview:_bgBlackView];
}

- (void)addAvPlayWithUrlString:(NSString *)playTtemUrlString{
    
    _playerItem_2 = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:playTtemUrlString]];
    
    self.player_2 = [AVPlayer playerWithPlayerItem:_playerItem_2];
    _playerLayer_2 = [AVPlayerLayer playerLayerWithPlayer:_player_2];
    
    
    _playerLayer_2.backgroundColor = (__bridge CGColorRef _Nullable)([[UIColor blackColor] colorWithAlphaComponent:1]);
    
    
    
    
    _playerLayer_2.frame = CGRectMake((SCREENWIDTH - 368)/2, (SCREENHEIGHT-207)/2,368 ,207);
    _playerLayer_2.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [_bgBlackView.layer addSublayer:_playerLayer_2];
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PreviewingVideoEnds:) name:AVPlayerItemDidPlayToEndTimeNotification object:[_player_2 currentItem]];
    [_player_2 play];
    
}
       
- (void)PreviewingVideoEnds:(NSNotification *)item{
    
    LRLog(@"%@",item.userInfo);
    [self jumpView];
}


- (void)jumpView{
    [_player_2 pause];
    _playerItem_2 = nil;
    _player_2 = nil;
    [self.player_2.currentItem cancelPendingSeeks];
    [self.player_2.currentItem.asset cancelLoading];
    [_playerLayer_2 removeFromSuperlayer];
    [_endLabel removeFromSuperview];
    [_action removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        _bgBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _playerLayer_2.backgroundColor = (__bridge CGColorRef _Nullable)([[UIColor blackColor] colorWithAlphaComponent:0]);
        
    } completion:^(BOOL finished) {
        [_bgBlackView removeFromSuperview];
    }];
    
    
}


//通知
- (void)upDataControl:(NSNotification *)item
{
    
    //加判断解决 多个通知混淆问题
    if (_bgHeadView.hidden == YES) {
        
        playLoopCount++;
        AVPlayerItem * playerItem = [item object];
        //关键代码
        [playerItem seekToTime:kCMTimeZero];
        
#pragma mark---加判断保护 如果循环次数 playLoopCount> 播放次数的时候跳到下个视频
        if (playLoopCount == [self.playListModel.count integerValue]) {
            playLoopCount = 0;
            
            [self updateItem];
            
            
        } else if(playLoopCount < [self.playListModel.count integerValue]){
            
            
            
            [_player_0 play];
            LRLog(@"重播");
        }else{
            playLoopCount = 0;
            
            [self updateItem];
        }
        
        
    } else {
        LRLog(@"第二个播放器播放完成走的");
    }
    
    
    
}



//数据
- (void)updateItem {
 
    self.localPalyCount++;
   
    if (self.localPalyCount >= self.playlistARR.count) {
        
        
        [_player_0 pause];
        _player_0 = nil;
        _playerItem = nil;
   
        [self.player_0.currentItem cancelPendingSeeks];
        [self.player_0.currentItem.asset cancelLoading];
        
        [self playEnd];
      
        return;
    }
    
    if (self.localPalyCount <=0) {
        [_player_0 pause];
        _player_0 = nil;
        _playerItem = nil;
        return;
    }
    
    self.playListModel = self.playlistARR[self.localPalyCount];
    [self runLoopTheMovie];
}

//结束页
- (void)playEnd
{
    
    AVEndViewController *avEnd = [[AVEndViewController alloc] initWithNibName:@"AVEndViewController" bundle:nil];
    avEnd.delegate = self;
    [self presentViewController:avEnd animated:YES completion:^{
        
        
    }];

    
}

- (void)playEndBtnClick:(UIButton *)send
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//播放器操作
- (void)runLoopTheMovie
{
    
    if ( _bgHeadView.hidden == NO) {
        NSString *strUrl = [NSString stringWithFormat:@"%@/%ld.mp4",_pathUrl,_playListModel.hostID];
        
        LRLog(@"%@",strUrl);
        [self.player_0 replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:strUrl]]];
    } else {
        NSString *strUrl = [NSString stringWithFormat:@"%@/%ld.mp4",_pathUrl,_playListModel.hostID];
        
        LRLog(@"%@",strUrl);
        [self.player_0 replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:strUrl]]];
        
        [_player_0 play];
    }
    

}






//开始暂停按钮
- (void)playBtnClick:(UIButton *)sender {
    
    
    [self hiddenBtnView];
    [_player_0 play];
  

}





- (void)backCourseDetail
{
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}


- (void)bgBtnViewClick
{
    [TalkingData trackEvent:@"训练视频播放页面_点击了屏幕"];
    LRLog(@"点击了全屏按钮");
   // [self play:_bgBtnView];
    [_player_0 pause];
    [self disPlayBtnView];
    
  
}


//显示
- (void)disPlayBtnView
{
    _bgHeadView.hidden = NO;
    _bgView.hidden = NO;
    _overBtn.hidden = NO;
    _playBtn.hidden = NO;
    _leftBtn.hidden = NO;
    _rightBtn.hidden = NO;
    _actionExplanationBtn.hidden = NO;
   
    
    NSString *planName = _playListModel.preview.name;
    if (([AC rangeOfString:[planName substringFromIndex:planName.length - 1]].length != 0 ||[ac rangeOfString:[planName substringFromIndex:planName.length - 1]].length != 0) && planName != nil && planName.length!= 0)
    {
        planName = [_playListModel.preview.name substringToIndex:_playListModel.preview.name.length - 1];
    }
    _nameLabel.text = planName;
    
    //计算时长
    NSInteger pastTime = 0;
    for (int i = 0; i < self.localPalyCount; i++)
    {
        PlanList *plan = self.playlistARR[i];
        pastTime += plan.length * [plan.count integerValue];
        if ([plan.type isEqualToString:@"common"])
        {
            NSLog(@"这是休息动作不计数");
        }
        else
        {
            _MainMovePlayCount++;
        }

    }
    
    //判断当前动作是不是休息
    if ([self.playListModel.type isEqualToString:@"common"])
    {
        [_rightBtn setImage:[UIImage imageNamed:@"跳过休息"] forState:UIControlStateNormal];
        [_rightBtn setTitle:@"跳过休息" forState:UIControlStateNormal];
        _rightBtn.font = [UIFont systemFontOfSize:14];

    }
    else
    {
        _MainMovePlayCount++;
        [_rightBtn setImage:[UIImage imageNamed:@"视频播放暂停页-前进"] forState:UIControlStateNormal];
        [_rightBtn setTitle:nil forState:UIControlStateNormal];

    }

    
    if ((_AvplayerAllTimes - pastTime) / 60 == 0)
    {
        _afterTime.text = [NSString stringWithFormat:@"%ld/%ld 训练剩余不到1分钟",(long)_MainMovePlayCount,(unsigned long)_MainCount];
    }
    else
    {
        _afterTime.text = [NSString stringWithFormat:@"%ld/%ld 训练剩约%ld分钟",(long)_MainMovePlayCount,(unsigned long)_MainCount,(long)(_AvplayerAllTimes - pastTime) / 60];
    }
    
    _MainMovePlayCount = 0;

    if (_localPalyCount != 0)
    {
        
        for (int i = 0; i <= _localPalyCount - 1; i++)
        {
            PlanList *plan = _playlistARR[i];
            UIView *view = [_ProgressBarView viewWithTag:200 + i];
            
            if ([plan.type isEqualToString:@"common"])
            {
                view.backgroundColor = RestColor;
            }
            else
            {
                view.backgroundColor = ZhuYao;
            }
  
        }
        
    }
    
    
    
    
    
    
    
    
}


//隐藏
- (void)hiddenBtnView
{
    [UIView animateWithDuration:0.3 animations:^{
       
        _bgHeadView.hidden = YES;
        _bgView.hidden = YES;
        
        _overBtn.hidden = YES;
        _playBtn.hidden = YES;
        _leftBtn.hidden = YES;
        _rightBtn.hidden = YES;
        _actionExplanationBtn.hidden = YES;
    } completion:^(BOOL finished) {

        
    }];
    
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
            
            [self.stateArr removeAllObjects];
            
            self.view = nil;
        }
    }
    
}



@end

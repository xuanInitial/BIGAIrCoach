//
//  VideoDetailViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/16.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "CommonUtil.h"
#import "clickClientPro.h"
#import "RootTabBarController.h"
@interface VideoDetailViewController ()<clickClientProtocol>
@property(nonatomic,strong)AVPlayerItem *VideoPlayerItem;
@property(nonatomic,strong)AVPlayer *VideoPlayer;
@property(nonatomic,strong)AVPlayerLayer *VideoPlayerLayer;

@property(nonatomic,strong)UIScrollView *MainScroll;
@property(nonatomic,strong)UILabel *Videolab;
@property(nonatomic,strong)UILabel *VideoDetailLab;

@property(nonatomic,strong)NSString *OtherUrl;//用于更换下载好的url
@property (nonatomic, strong) UIVisualEffectView *maoboliView;

@end

@implementation VideoDetailViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self pauseTheMV];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)pauseTheMV
{
    [_VideoPlayer pause];
    _VideoPlayer = nil;
    _VideoPlayerItem = nil;
    
    [_VideoPlayer.currentItem cancelPendingSeeks];
    [_VideoPlayer.currentItem.asset cancelLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_细线.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;

    
    self.titleLabel.text = @"怎样使用";
    self.titleLabel.textColor = ZhuYao;
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    
    _OtherUrl = _VideoUrl;
    
    [self CreatAVplayer];
    
    [self CreatDetail];
    
    [self iOS8blurAction];
    
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([delegete.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        RootTabBarController *rootBar =(RootTabBarController*)delegete.window.rootViewController;
        rootBar.clientDelegate = self;
    }
    
    //添加轻扫手势
    UIScreenEdgePanGestureRecognizer *swipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture)];
    //设置轻扫的方向
    swipeGesture.edges = MASAttributeLeft; //默认向右
    [self.view addGestureRecognizer:swipeGesture];
    

}
-(void)swipeGesture
{
    [self leftItemClick];
}
- (void)iOS8blurAction {
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _maoboliView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    _maoboliView.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
    _maoboliView.alpha = 1;
    [self.view addSubview:_maoboliView];
    
    UIView *bottomBlackView = [[UIView alloc]init];
    bottomBlackView.frame = CGRectMake(0, 63.5, SCREENWIDTH, 0.5);
    bottomBlackView.backgroundColor = BottomlineColor;
    
    [_maoboliView addSubview:bottomBlackView];
    
}

-(void)leftItemClick
{
   [self.navigationController popViewControllerAnimated:YES];
}
-(void)CreatAVplayer
{
    
    //路径拼接
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *archivingPath = [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@KnowUserVideo",[BusinessAirCoach getTel]]];
    NSLog(@"%@",archivingPath);
    //拼接文件全路径
    NSString *fullpath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.mp4",(long)_videoId]];
    //NSURL *filePathUrl = [NSURL fileURLWithPath:fullpath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //首先判断检查本地文件是否已存在
    if ([fileManager fileExistsAtPath:fullpath])
    {
        //已经下载完成直接播
        _VideoUrl = fullpath;
        _VideoPlayerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:_VideoUrl]];
    }
    else
    {
        _VideoPlayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_VideoUrl]];
        //没有下载完成 一边下载一边播
        [CommonUtil KownSessionDownloadWithUrl:_VideoUrl fileName:_videoId success:^(NSDictionary *allHeaders, NSURL *fileURL) {
            //下载成功 赋值
            _VideoUrl = fullpath;
            NSLog(@"下载成功");
            
        } fail:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //下载失败
            if (error != nil)
            {
                PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
                [[UIApplication sharedApplication].keyWindow addSubview:prom];
            }
        }];
    }
    
    _VideoPlayer = [AVPlayer playerWithPlayerItem:_VideoPlayerItem];
    _VideoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_VideoPlayer];
    _VideoPlayerLayer.backgroundColor = (__bridge CGColorRef _Nullable)([[UIColor blackColor] colorWithAlphaComponent:1]);
    _VideoPlayerLayer.frame = CGRectMake(0,64,SCREENWIDTH,(SCREENWIDTH)*(0.5625));
    _VideoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:_VideoPlayerLayer];
    [_VideoPlayer play];
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KnowVideoEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
 
}
-(void)KnowVideoEnd
{
    [_VideoPlayer seekToTime:kCMTimeZero];
    if (![_OtherUrl isEqualToString:_VideoUrl])
    {
       [_VideoPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:_VideoUrl]]];
        _OtherUrl = _VideoUrl;
        [_VideoPlayer play];
    }
    else
    {
       [_VideoPlayer play];
    }
 
}
-(void)CreatDetail
{
    _MainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (SCREENWIDTH)*9/16 + 64, SCREENWIDTH, SCREENHEIGHT - (SCREENWIDTH)*9/16)];
    _MainScroll.contentSize = CGSizeMake(0, SCREENHEIGHT -(SCREENWIDTH)*9/16);
    _MainScroll.showsVerticalScrollIndicator = NO;
    _MainScroll.backgroundColor = [UIColor whiteColor];
    [_MainScroll setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:_MainScroll];
    
    
    _Videolab = [[UILabel alloc]initWithFrame:CGRectMake(15, -42, SCREENWIDTH - 30, 22)];
    if ([_VideoName isEqualToString:@"联系护理师"])
    {
        _Videolab.text = @"与您的专属护理师保持联系";
    }
    else
    {
        _Videolab.text = _VideoName;
    }
    _Videolab.font = [UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
    _Videolab.textColor = Subcolor;
    [_MainScroll addSubview:_Videolab];
    
    
    _VideoDetailLab = [[UILabel alloc]initWithFrame:CGRectMake(15, _Videolab.y + 22 + 15, SCREENWIDTH - 30, SCREENHEIGHT - (SCREENWIDTH)*9/16 - 55)];
    _VideoDetailLab.text = _VideoDetail;
    _VideoDetailLab.font = [UIFont systemFontOfSize:16];
    _VideoDetailLab.textColor = LableColor;
    _VideoDetailLab.numberOfLines = 0;
    [_MainScroll addSubview: _VideoDetailLab];
    
    NSMutableAttributedString *attributedString = [self TheLabletext:_VideoDetail];
    _VideoDetailLab.attributedText = attributedString;
    [_VideoDetailLab sizeToFit];
    
}
//行距设置
-(NSMutableAttributedString*)TheLabletext:(NSString*)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;  //行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

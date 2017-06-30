//
//  RootTabBarController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "RootTabBarController.h"

#import "DietViewController.h"
#import "ChartViewController.h"
#import "NewTrainViewController.h"
#import "NTESSessionViewController.h"

#import "StartViewController.h"
#import "JPUSHService.h"

#import "NewMyViewController.h"

#import "AppDelegate.h"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";
@interface RootTabBarController ()<UIAlertViewDelegate,NIMChatManagerDelegate,NIMLoginManagerDelegate,NIMSessionMsgDatasourceDelegate>

@end

@implementation RootTabBarController



+ (instancetype)instance{
    
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[RootTabBarController class]]) {
        return (RootTabBarController *)vc;
    }else{
        return nil;
    }
    
}


- (BOOL)shouldAutorotate
{
    LRLog(@"让不让我旋转?");
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

-(void)setClientDelegate:(id<clickClientProtocol>)clientDelegate
{
    _clientDelegate = clientDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
     NSArray *titleNames = [NSArray arrayWithObjects:@"塑形",@"饮食方案", @"身体数据",@"我", nil];
    NSArray *tabbarNames = [NSArray arrayWithObjects:@"塑形",@"饮食方案",@"身体数据",@"我", nil];
    NSArray *imageNames = [NSArray arrayWithObjects:@"塑形-未选中", @"饮食-未选中",@"身体数据-未选中",@"我-未选中" ,nil];
    NSArray *selImageNames = [NSArray arrayWithObjects:@"塑形-选中", @"饮食-选中",@"身体数据-选中",@"我-选中" ,nil];
    NSArray *vcName = [NSArray arrayWithObjects:@"NewTrainViewController",@"DietViewController",@"ChartViewController",@"NewMyViewController",   nil];
    
    NSMutableArray *vcArr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        
        Class cl = NSClassFromString(vcName[i]);
        
        UIViewController *vc = [[cl alloc]init];
        
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
        
        vc.navigationItem.title = titleNames[i];
        
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:tabbarNames[i] image:[UIImage imageNamed:imageNames[i]] selectedImage:[UIImage imageNamed:selImageNames[i]]];
        nc.navigationItem.titleView.userInteractionEnabled = YES;
        nc.tabBarItem = item;
        [vcArr addObject:nc];
    }
    self.tabBar.tintColor = TabbarColor;
    self.tabBar.translucent = NO;
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@""];
    self.viewControllers = vcArr;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
//    //显示
//    [self.tabBarController.tabBar showBadgeOnItemIndex:1];
//    //隐藏
//    //  [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
    
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    
    
    [[[NIMSDK sharedSDK] chatManager] addDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
   
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;

    delegete.window.rootViewController = self;
    

    
    
    
}

//登录相关
//被踢
-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{

    if (self.clientDelegate && [self.clientDelegate respondsToSelector:@selector(pauseTheMV)])
    {
        [_clientDelegate pauseTheMV];
    }
    
    switch (clientType) {
        case NIMLoginClientTypeiOS:
        {
            LRLog(@"被ios机踢掉");
            
            
            
            StartViewController *sta = [[StartViewController alloc]init];
//            UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:sta];
            [UIApplication sharedApplication].keyWindow.rootViewController = sta;
            
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"另外一台设备登陆了您的账号"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];

            break;
        }
        case NIMLoginClientTypeAOS:
        { LRLog(@"被Android机踢掉");
            
            StartViewController *sta = [[StartViewController alloc]init];
            //UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:sta];
            [UIApplication sharedApplication].keyWindow.rootViewController = sta;
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"另外一台设备登陆了您的账号"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
            break;
        }
        default:
            break;
    }
    
    
}
//收到消息
-(void)onRecvMessages:(NSArray *)messages
{
   
    NIMMessage *message = messages.firstObject;
    
    //获取时间
    NSTimeInterval a = (int)(message.timestamp);
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:a];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
    NSDate *localeDate = [confromTimesp dateByAddingTimeInterval:interval];

    NSString *strtime = [NSString stringWithFormat:@"%@",localeDate];
    if (strtime.length > 16)
    {
        strtime = [strtime substringToIndex:16];
        [BusinessAirCoach setlastMessageTime:strtime];
    }
    else
    {
        strtime = @"0000-00-00 00:00";
        [BusinessAirCoach setlastMessageTime:strtime];
    }
    
    
    
    NSString *text = nil;
    //收到消息的操作
    NSString *flag = nil;
    if ([BusinessAirCoach getUserFlag:[BusinessAirCoach getTel]])
    {
        flag = [BusinessAirCoach getTel];
    }
    if ([BusinessAirCoach getUserWeixinFlag:[[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID]])
    {
        flag = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    }
    //时间文本写本地
    [BusinessAirCoach setMessagered:@"appear"];
    [BusinessAirCoach setlastMessageTime:strtime];
    switch (message.messageType)
    {
        case NIMMessageTypeText:
            text = message.text;
            [BusinessAirCoach setlastMessage:text];
            break;
        case NIMMessageTypeAudio:
            text = @"护理师发来一条语音";
            [BusinessAirCoach setlastMessage:text];
            break;
        case NIMMessageTypeImage:
            text = @"护理师发来一张图片";
            [BusinessAirCoach setlastMessage:text];
            break;
        case NIMMessageTypeVideo:
            text = @"护理师发来一个视频";
            [BusinessAirCoach setlastMessage:text];
            break;
        case NIMMessageTypeLocation:
            text = @"您有一条新的位置";
            [BusinessAirCoach setlastMessage:text];
            break;
        case NIMMessageTypeFile:
            text = @"[文件]";
            [BusinessAirCoach setlastMessage:text];
            break;
        case NIMMessageTypeTip:
            text = @"[提醒消息]";   //调整成你需要显示的文案
            [BusinessAirCoach setlastMessage:text];
            break;
        default:
            
            text = @"护理师发来一个通话";
            [BusinessAirCoach setlastMessage:text];
    }
    
    
    NSDictionary *dic = @{@"msg":text};

    //存本地 消息
    [BusinessAirCoach setlastMessage:text];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewMessage" object:nil userInfo:dic];
    //[self displayMessage];
}

//发送消息
- (void)willSendMessage:(NIMMessage *)message
{
    
    NSDictionary *contentDic;
    NSString *txt = nil;
    //收到消息的操作
    switch (message.messageType) {
        case NIMMessageTypeText:
        {
            // 收到的文字消息
            // 收到的文字消息
            txt =  message.text;
            
        }
            break;
        case NIMMessageTypeImage:
        {
            txt = @"学员发来一张图片";

        }
            break;
        case NIMMessageTypeAudio:
        {
            txt = @"学员发来一条语音";
        }
            break;
        case  NIMMessageTypeVideo:
        {
            txt = @"学员发来一段视频";

        }
            break;
        case  NIMMessageTypeLocation:
        {
            txt = @"学员发来位置信息";

        }
            break;
        case  NIMMessageTypeCustom:
        {
            txt = @"学员发来一个表情";

        }
            break;
        default:
            break;
    }
    
}


//字典转json字符串
- (NSString *)toJSONData:(id)theData
{
    NSError* error = nil;
    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] >0 &&error == nil) {
        return [[NSString alloc] initWithData:jsonData
                                     encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

//获取appKey
- (NSString *)getAppKey {
    return [appKey lowercaseString];
}

- (void)dealloc
{
    [self unObserveAllNotifications];
  
    [[[NIMSDK sharedSDK] chatManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"极光已连接");
    
}

- (void)networkDidClose:(NSNotification *)notification {
    
    NSLog(@"极光未连接");
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    
    NSLog(@"极光已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"极光已登录");
    
    
}

- (void)networkDidReceiveMessage:(NSNotification *)notification{
    
    DDLogDebug(@"Event - receivePushMessage");
    
    NSDictionary *info = notification.userInfo;
    if (info) {
        DDLogDebug(@"The message - %@", info);
    } else {
        DDLogWarn(@"Unexpected - no user info in jpush mesasge");
    }
}


- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}


- (int)zitiDefine:(int)ziti{
    
    if (SCREENWIDTH == 320) {
        if (ziti <= 13 ) {
            ziti-=2;
        }else{
            ziti-=2;
        }
    }
    return ziti;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

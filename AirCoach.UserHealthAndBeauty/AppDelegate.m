//
//  AppDelegate.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"

#import "NTESLoginViewController.h"
#import "NIMSDK.h"
#import "UIView+Toast.h"
#import "NTESService.h"
#import "NTESNotificationCenter.h"
#import "NTESLogManager.h"
#import "NTESDemoConfig.h"
#import "NTESSessionUtil.h"
#import "NTESMainTabController.h"
#import "NTESLoginManager.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESClientUtil.h"
#import "NTESNotificationCenter.h"
#import "NIMKit.h"
#import "NTESDataManager.h"
#import "LoginDeViewController.h"

#import "StartViewController.h"


#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>

#import "AppConstant.h"

#import "TalkingData.h"

#import "iflyMSC/IFlyMSC.h"

#import <Bugly/Bugly.h>


//语音控制appid
#define APPID_VALUE @"5799af57"

NSString *NTESNotificationLogout = @"NTESNotificationLogout";
@interface AppDelegate ()<NIMLoginManagerDelegate>

@property (strong, nonatomic) RootTabBarController *rootTBC;
@property (strong, nonatomic) StartViewController *loginVC;
@property (nullable, nonatomic, copy) NSArray<UIApplicationShortcutItem *> *shortcutItems NS_AVAILABLE_IOS(9_0) __TVOS_PROHIBITED;
@end

@implementation AppDelegate




- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight);
    
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
     [Bugly startWithAppId:@"188dd0e943"];
    //188dd0e943
    //正式服  db9adcf031
    
    
   // 7861be93-5179-4092-9d09-4ccc1dfa8b00cd
    
    //语音控制
    [self AudioStart];
    
    [self yunxin];
    
    [self automaticLogon];

    [self creatShortcutItem];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound|
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:@"bb04637ebf4c97f607f4fe48"
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    
    
#pragma mark---talkingData
     [TalkingData sessionStarted:@"B3DA524CE46BC5F97FF7F5B6BCC4337D" withChannelId:channel];
    
    //0BF9B84968E5FAC8F75D9BD07039B39A   正式版、
    //B3DA524CE46BC5F97FF7F5B6BCC4337D  测 试服
    
    [BusinessAirCoach setProgressBarToDownloadANumberOfLabels:nil];
    return YES;
}

-(void)AudioStart
{
    //显示SDK的版本号
   // NSLog(@"verson=%@",[IFlySetting getVersion]);
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}
- (void)automaticLogon{
    if (![BusinessAirCoach getAuthorization]) {
    
        _loginVC = [StartViewController new];
        self.window.rootViewController = _loginVC;
    }else {
       
        _rootTBC = [RootTabBarController new];
        self.window.rootViewController = _rootTBC;
    }
   
}


- (void)yunxin{
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[NIMKit sharedKit] setProvider:[NTESDataManager sharedInstance]];
    [[NTESNotificationCenter sharedCenter] start];
    //注册自定义消息
    [NIMCustomObject registerCustomDecoder:[[NTESCustomAttachmentDecoder alloc]init]];
    
    [[NIMSDK sharedSDK] registerWithAppID:@"c71ebe74734e0b16280d4740f850905a"
                                  cerName:@"iosDevelop77ts"];
   
    //Appkey:443fdee0ff5ebb18f414089d72310fa3  正式服
    //        c71ebe74734e0b16280d4740f850905a  测试服
    //iosDevelop77ts
    //iosPUSH77ts
    [self YunxinLogin];
}
#pragma mark----云信自动登录
-(void)YunxinLogin
{
//    LRLog(@"%@",[BusinessAirCoach getAcc]);
//    LRLog(@"%@",[BusinessAirCoach getyunxinToken]);
    //云信的自动登录

    
      [[[NIMSDK sharedSDK] loginManager] autoLogin:[BusinessAirCoach getAcc] token:[BusinessAirCoach getyunxinToken]];
        
    
}

- (void)onLogin:(NIMLoginStep)step{
    if (step == NIMLoginStepLoginOK) {
     
    }
}

//自动登录失败的回调
- (void)onAutoLoginFailed:(NSError *)error
{
    if (error != nil)
    {
        //自动登录失败去登录页面
        [BusinessAirCoach setUserSpeakerLab:nil];
        [BusinessAirCoach setUserStartPlan:nil];
        
        _loginVC = [StartViewController new];
        self.window.rootViewController = _loginVC;
    }
    else
    {
        
    }
}
//3dTouch设置方法
- (void)creatShortcutItem
{
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"塑形师3d"];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"开始训练3d"];
    //创建快捷选项
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:@"UserSpeak" localizedTitle:@"向护理师发起对话" localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:@"StartPlan" localizedTitle:@"开始训练" localizedSubtitle:nil icon:icon2 userInfo:nil];
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item2,item1];
    
    
}
//如果app在后台 点击按钮进入此方法
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    NSString *type = shortcutItem.type;
    
    if (![BusinessAirCoach getAuthorization]) {
        
        _loginVC = [StartViewController new];
        self.window.rootViewController = _loginVC;
    }else {
        
        if ([type isEqualToString:@"UserSpeak"])
        {
            [BusinessAirCoach setUserSpeakerLab:@"jumpYunxin"];
            
        }
        else
        {
            [BusinessAirCoach setUserStartPlan:@"jumpPlanPage"];
        }
        _rootTBC = [RootTabBarController new];
        self.window.rootViewController = _rootTBC;
        [self YunxinLogin];
        
    }

    
    if (completionHandler)
    {
        completionHandler(YES);
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"foreground"object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)registerAPNs
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
     LRLog(@"=====%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    
    //Optional极光
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error
          );
    
}


//是点击apns推送通知栏消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required,For systems with less than or equal to iOS6
    
    
    
    [JPUSHService handleRemoteNotification:userInfo];
    LRLog(@"收到通知:%@", [self logDic:userInfo]);
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


//点击本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    [[IFlySpeechUtility getUtility] handleOpenURL:url];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult
                                                          ult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


@end

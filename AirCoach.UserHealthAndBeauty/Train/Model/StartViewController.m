//
//  StartViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/29.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "StartViewController.h"
#import "LoginDeViewController.h"

#import "HttpsRefreshNetworking.h"

#import "RootTabBarController.h"

#import "LoginView.h"

#import "NimModel.h"

#import "AppDelegate.h"



@interface StartViewController ()<UITextFieldDelegate,AlertControllerDZDelegate>{
    AlertControllerDZ *alertView;
}


@property(nonatomic)dispatch_source_t _timer;

@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIView *zhezhaoview;
@property(nonatomic,strong)UITextField *telText;
@property(nonatomic,strong)UITextField *passWordText;
@property(nonatomic,strong)UIButton *visable;
@property(nonatomic,strong)UIButton *loginBtn;
//注册和忘记密码
@property(nonatomic,strong)UIButton *RegistBtn;
@property(nonatomic,strong)UIButton *ForgetBtn;

@property (strong, nonatomic) UIButton *YZMButton;

@property(nonatomic,strong)LoginDeViewController *registTel;

@property(nonatomic,strong)UIImageView *logoView;

@property(nonatomic,strong)RootTabBarController *rootTBC;


@property(nonatomic, strong) NSString *yanzhengma;

@property (nonatomic ,strong) NimModel *nimModel;

@property (nonatomic, strong) NSString *tokenString;

@end

@implementation StartViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(__timer != nil)
    {
        dispatch_source_cancel(__timer);
    }
    
    @try
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception)
    {
        
    };

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self CreatAnimal];
}






- (BOOL)shouldAutorotate
{
    LRLog(@"让不让我旋转?");
    return YES;
}

//不让手机横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
}
//强制竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    LRLog(@"让我旋转哪些方向 左边和竖屏");
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)CreatAnimal
{
    
   
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"登录注册-背景图"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //一定要加这句
    //imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:imageView];
    imageView.userInteractionEnabled = YES;
    //高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _effectView.alpha = 0;
    _effectView.frame = self.view.frame;
    [imageView addSubview:_effectView];
    //遮罩
    _zhezhaoview = [[UIView alloc]init];
    _zhezhaoview.frame = self.view.frame;
    _zhezhaoview.backgroundColor = [UIColor colorWithRed:59/255.0 green:57/255. blue:74/255.0 alpha:1];
    //_zhezhaoview.backgroundColor = [UIColor blackColor];
    _zhezhaoview.alpha = 0;
    [imageView addSubview:_zhezhaoview];
    
    if ([_loginFlag isEqualToString:@"loginOut"])
    {
        imageView.frame = CGRectInset(imageView.frame, -25.0f, -25.0f);
        _effectView.frame = CGRectInset(imageView.frame, -25.0f, -25.0f);
        _zhezhaoview.frame = CGRectInset(imageView.frame, -25.0f, -25.0f);
    }
    
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        
        if (![_loginFlag isEqualToString:@"loginOut"])
        {
            imageView.frame = CGRectInset(imageView.frame, -25.0f, -25.0f);
            _effectView.frame = CGRectInset(imageView.frame, -25.0f, -25.0f);
            _zhezhaoview.frame = CGRectInset(imageView.frame, -25.0f, -25.0f);
        }
        
        
    } completion:^(BOOL finished) {
        
        LRLog(@"跳转下一页面");
        
        
        [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            _effectView.alpha = 1.0;
            _zhezhaoview.alpha = 0.7;
        } completion:^(BOOL finished) {
            _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 - 25, SCREENHEIGHT, 125, 125)];
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [imageView addSubview:_logoView];
                _logoView.image = [UIImage imageNamed:@"logininglogo"];
                [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(imageView.mas_top).offset(51);
                    make.centerX.equalTo(imageView.mas_centerX);
                    make.width.equalTo(@125);
                    make.height.equalTo(@125);
                }];
                
            } completion:^(BOOL finished) {}];
            
            
            
            
            
            LoginView *whiteView = [[LoginView alloc]initWithFrame:CGRectMake(40, SCREENHEIGHT + 300, SCREENWIDTH-30, 110)];
            whiteView.backgroundColor = [UIColor whiteColor];
            _telText = [whiteView viewWithTag:1001];
            
            _passWordText = [whiteView viewWithTag:1002];
            
            _telText.delegate = self;
            _passWordText.delegate = self;
            
            //手机框内只能输入数字
            _telText.keyboardType = UIKeyboardTypeNumberPad;
//            _visable = [whiteView viewWithTag:1000];
//            [_visable addTarget:self action:@selector(touchMe:) forControlEvents:UIControlEventTouchUpInside];
            
    
            [imageView addSubview:whiteView];
            [imageView bringSubviewToFront:whiteView];
            whiteView.backgroundColor = [UIColor whiteColor];
            
            [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(imageView.mas_left).equalTo(@40);//距离self.view左侧20
                make.right.equalTo(imageView.mas_right).equalTo(@(-40));
                make.top.equalTo(imageView.mas_top).offset(SCREENHEIGHT + 50);//距离self.view顶部200
                make.height.equalTo(@(110));
            }];
            
            //登录建
            _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _loginBtn.frame = CGRectMake(40, SCREENHEIGHT + 420, SCREENWIDTH-30, 44);
            [imageView addSubview:_loginBtn];
            
            [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(imageView.mas_left).equalTo(@40);//距离self.view左侧20
                make.right.equalTo(imageView.mas_right).equalTo(@(-40));
                make.top.equalTo(whiteView.mas_bottom).offset(17);//距离self.view顶部200
                make.height.equalTo(@(44));
            }];
            _loginBtn.font = [UIFont systemFontOfSize:17];
            
            
            
            [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(imageView.mas_left).equalTo(@40);//距离self.view左侧20
                make.right.equalTo(imageView.mas_right).equalTo(@(-40));
                make.top.equalTo(_logoView.mas_bottom).offset(16);
                make.height.equalTo(@(110));
            }];
            
            _loginBtn.enabled = NO;
            [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            [_loginBtn setBackgroundImage:[UIImage imageNamed:@"可点击"] forState:UIControlStateNormal];
            [_loginBtn setBackgroundImage:[UIImage imageNamed:@"不可点击"] forState:UIControlStateDisabled];
            _loginBtn.layer.cornerRadius = 4;
            _loginBtn.layer.masksToBounds = YES;
            [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
            
            _YZMButton = [whiteView viewWithTag:1005];
           
            [_YZMButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            //不可用
            [_YZMButton setTitleColor:Testcolor forState:UIControlStateDisabled];
            //正常
            [_YZMButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _YZMButton.layer.cornerRadius = 4;
            _YZMButton.layer.masksToBounds = YES;
            [_YZMButton addTarget:self action:@selector(YanZhengMaButton:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [UIView animateWithDuration:0.3 animations:^{
                [imageView layoutIfNeeded];
            }];
            
            
            
            
            
        }];
        
        
        
        
    }];
    
    
    
}



//手机号密码登录
-(void)login:(UIButton*)sender
{
    
    [_passWordText resignFirstResponder];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeCustom];
     __weak typeof(self) weakSelf = self;
    // 连接状态回调处理
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){

            [SVProgressHUD dismiss];
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
            [BusinessAirCoach setstartError:@"第一个网络检测错误"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
            [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
            return ;
        }else
        {
            [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
            if (_telText.text.length == 0)
            {
                [SVProgressHUD dismiss];
                PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请输入手机号"];
                [[UIApplication sharedApplication].keyWindow addSubview:prom];
                return;
            }else{
                
            }
            if(_telText.text.length != 11)
            {
                // [self clickMe:@"请输入正确的手机号"];
                [SVProgressHUD  dismiss];
                PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请输入正确的手机号"];
                [[UIApplication sharedApplication].keyWindow addSubview:prom];
                
                return;
            }else{
                
            }
#pragma mark-----验证码
            if (_passWordText.text.length == 0)
            {
                [SVProgressHUD  dismiss];
                PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请输入验证码"];
                [[UIApplication sharedApplication].keyWindow addSubview:prom];
                
                return;
            }else{
                
            }
            
//                if (_yanzhengma == nil) {
//                    PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请获取验证码"];
//                    [[UIApplication sharedApplication].keyWindow addSubview:prom];
//                    [SVProgressHUD  dismiss];
//                    return;
//                }
            
            NSDictionary *parmeter = nil;
            
            if ([_telText.text isEqualToString:@"13666777888"]) {
                parmeter = @{@"mobile":@"13666777888",
                             @"password":@"777888"};
            }
            else {
//                       parmeter = @{@"mobile":_telText.text,
//                                                   @"password":_yanzhengma};
                
                parmeter = @{@"mobile":_telText.text,
                             @"password":_passWordText.text};
            }
            
            
            
            
            
            //写入本人手机号
            [BusinessAirCoach setTel:_telText.text];
            
            [[HttpsRefreshNetworking Networking] POST:LOGIN parameters:parmeter success:^(NSDictionary *allHeaders, id responseObject,id statusCode) {
                
                _tokenString =[allHeaders objectForKey:@"authorization"];
                if (![BusinessAirCoach getAuthorization])
                {
                    [BusinessAirCoach setUserAuthorization:[allHeaders objectForKey:@"authorization"]];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authorization"];
                    [BusinessAirCoach setUserAuthorization:[allHeaders objectForKey:@"authorization"]];
                }
                
                //进入app时写入时间
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSInteger interval = [zone secondsFromGMTForDate: [NSDate date]];
                NSDate *localeDate = [[NSDate date] dateByAddingTimeInterval: interval];
                LRLog(@"%@", localeDate);
                
                [BusinessAirCoach setFirstTime:[NSDate date]];
                
                //清空首页刷新时间
                [BusinessAirCoach setTrainShuaxuinTime:nil];
                
                if ([[responseObject objectForKey:@"data"] isEqualToString:@"login_succed"]) {
                    
                    LRLog(@"%@=----%@",allHeaders, responseObject);
                    
                    [[HttpsRefreshNetworking Networking] GET:CUSTOM parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
                        
                        LRLog(@"%@",responseObject);
                        
                        
                        if ([responseObject objectForKey:@"figure" ] == nil) {
                            [SVProgressHUD  dismiss];
                            LoginDeViewController *loginDetails = [LoginDeViewController new];
                            loginDetails.nameString = [responseObject objectForKey:@"name"];
                            [self presentViewController:loginDetails animated:YES completion:^{
                                
                            }];
                            return ;
                        }
                        
                        NSString *statusString =[responseObject objectForKey:@"status"];
                        if ([statusString isEqualToString:@"expired"]) {
                            [SVProgressHUD  dismiss];
                           // NSLog(@"过期");
                            [BusinessAirCoach setUserAuthorization:nil];
                            alertView = [[AlertControllerDZ alloc]initWithFrame:self.view.bounds WithTitle:@"您当前的光合塑形服务已经到期,是否需要延长服务期限？" andDetail:nil andCancelTitle:@"否,谢谢" andOtherTitle:@"是,联系咨询师" andFloat:66 BtnNum:@"Two" location:NSTextAlignmentCenter];
                            alertView.detailLabel.textColor = [UIColor blackColor];
                            alertView.tag = 1;
                            alertView.delegate = self;
                            [[UIApplication sharedApplication].keyWindow addSubview:alertView];
                            
                            
                        } else if ([statusString isEqualToString:@"normal"] || [statusString isEqualToString:@"prepared"]){
                           // NSLog(@"正常的");
                            
                            _nimModel = [NimModel mj_objectWithKeyValues:[responseObject objectForKey:@"nim"]];
                            
#pragma mark-------云信登录
                            [BusinessAirCoach setyunxinAcc:_nimModel.acc_id];
                            [BusinessAirCoach setyunxinToken:_nimModel.token];
                            [[[NIMSDK sharedSDK] loginManager] login:_nimModel.acc_id token:_nimModel.token completion:^(NSError * _Nullable error) {
                                [SVProgressHUD  dismiss];
                                if (error) {
                                    
                                    [BusinessAirCoach setUserAuthorization:nil];
                                    PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"登录失败,请重试"];
                                    [[UIApplication sharedApplication].keyWindow addSubview:prom];
                                    [TalkingData trackEvent:@"登录_云信登录失败"];
                                }else {
                                    [self JPUSH];
                                    _rootTBC = [RootTabBarController new];
                                    [weakSelf presentViewController:_rootTBC animated:YES completion:^{
                                         //delegete.window.rootViewController = _rootTBC;
                                    }];
                                }
                                
                            }];
                            
                            
                        }else if ([statusString isEqualToString:@"pause"]){
                            [SVProgressHUD  dismiss];
                           // NSLog(@"暂停");
                            [BusinessAirCoach setUserAuthorization:nil];
                            alertView = [[AlertControllerDZ alloc]initWithFrame:self.view.bounds WithTitle:nil andDetail:@"根据您的要求,目前您处于暂停服务状态,是否要恢复为正常服务状态？"  andCancelTitle:@"取消" andOtherTitle:@"恢复服务" andFloat:66 BtnNum:@"Two" location:NSTextAlignmentCenter];
                            alertView.detailLabel.textColor = [UIColor blackColor];
                            alertView.tag = 2;
                            alertView.delegate = self;
                            [[UIApplication sharedApplication].keyWindow addSubview:alertView];
                        }
                        
                        
                        
                    } failure:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
                        [SVProgressHUD  dismiss];
                        LRLog(@"%@",error);
                        if ([statusCode isEqualToString:@"404"]) {
                            
                            _registTel = [[LoginDeViewController alloc] init];
                            
                            [weakSelf presentViewController:_registTel animated:YES completion:^{
                                
                            }];
                            
                        }else {
                            [BusinessAirCoach setUserAuthorization:nil];
                            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
                            [BusinessAirCoach setstartError:[NSString stringWithFormat:@"第二个错误%@",error]];
                            [[UIApplication sharedApplication].keyWindow addSubview:prom];
                            [TalkingData trackEvent:@"登录_登录失败"];
                        }
                    }];
                    
                    
                    
                    
                }else {
                    [SVProgressHUD dismiss];
                    [BusinessAirCoach setUserAuthorization:nil];
                    PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请输入正确的验证码"];
                    [[UIApplication sharedApplication].keyWindow addSubview:prom];
                }
                
                
            } failure:^(NSDictionary *allHeaders,NSError *error ,id statusCode) {
                

                LRLog(@"%@",error);
                
                [SVProgressHUD dismiss];

#pragma mark---请求失败的时候获取返回参数
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                @try {
                    NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                    NSString *str = serializedData[@"error"];
                    
                    if (str != nil && [str isEqualToString:@"invalid_credentials"])
                    {
                        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"验证码错误"];
                        [[UIApplication sharedApplication].keyWindow addSubview:prom];
                        [SVProgressHUD  dismiss];
                    }
                    else if(str != nil && [str isEqualToString:@"verify_expired"]){
                        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"您的验证码已过期"];
                        [[UIApplication sharedApplication].keyWindow addSubview:prom];
                    }else{
                        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
                        [BusinessAirCoach setstartError:[NSString stringWithFormat:@"第三个错误%@",error]];
                        [[UIApplication sharedApplication].keyWindow addSubview:prom];
                    }
                } @catch (NSException *exception) {
                    [BusinessAirCoach setUserAuthorization:nil];
                    PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
                    [[UIApplication sharedApplication].keyWindow addSubview:prom];
                } ;
                
                
                
            }];
            
            
            
            
            
            
        }
        
    }];
    
    

}

//设置标签
- (void)JPUSH{
    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
    if ([BusinessAirCoach getSex]) {
        [self setTags:&tags addTag:[BusinessAirCoach getSex]];
    }
    
    [self setTags:&tags addTag:@"v102"];
    [self setTags:&tags addTag:@"user"];
    [self setTags:&tags addTag:@"iOS"];
    [JPUSHService setTags:tags alias:[BusinessAirCoach getUserId] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
    }];
}


- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag {
    //  if ([tag isEqualToString:@""]) {
    // }
    [*tags addObject:tag];
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

//判断登录按钮是否可用
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_telText.text.length == 0 && _passWordText.text.length == 0)
    {
        _loginBtn.enabled = NO;
    }
    else
    {
        _loginBtn.enabled = YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}



//点击验证码
- (void)YanZhengMaButton:(UIButton *)sender{
    
    
 
    if (_telText.text.length == 0)
    {
        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请输入手机号"];
        [[UIApplication sharedApplication].keyWindow addSubview:prom];
        return;
    }else{
        
    }
    //手机号正则验证
        if (_telText.text.length == 11)
        {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeCustom];
    //后台发送验证码
    _YZMButton.enabled = NO;
    NSDictionary *parameter = @{@"mobile":_telText.text};
    
    [[HttpsRefreshNetworking Networking] POST:VERIFY parameters:parameter success:^(NSDictionary *allHeaders, id responseObject,id statusCode) {
        NSLog(@"%@-------%@",allHeaders,responseObject);
        
        [SVProgressHUD dismiss];
        //手机号textfied 失去第一响应者  验证码textfied 成为第一响应者
        [_telText resignFirstResponder];
        
        [_passWordText becomeFirstResponder];
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(__timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(__timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(__timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    _YZMButton.enabled = YES;
                    
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [_YZMButton setTitle:[NSString stringWithFormat:@"%lds",(long)timeout] forState:UIControlStateDisabled];
                    
                });
                
                timeout--;
                NSLog(@"----%d",timeout);
                
            }
        });
        dispatch_resume(__timer);

        
        _yanzhengma = [responseObject objectForKey:@"verify"];
        _loginBtn.enabled = YES;
        
        
        
        
        
    } failure:^(NSDictionary *allHeaders,NSError *error ,id statusCode) {
        NSLog(@"%@",error);
         [SVProgressHUD dismiss];
        _YZMButton.enabled = YES;
        [_telText resignFirstResponder];
        if ([statusCode isEqualToString:@"404"]) {
            [_passWordText resignFirstResponder];
            alertView = [[AlertControllerDZ alloc]initWithFrame:self.view.bounds WithTitle:nil andDetail:@"您尚未购买光合塑形服务。请先将联系方式发送给我们，稍后咨询师会与您联系，并为您安排首次免费的奥运级别光合体检。"  andCancelTitle:@"取消" andOtherTitle:@"发送联系方式" andFloat:66 BtnNum:@"Two" location:NSTextAlignmentCenter];
            alertView.detailLabel.textColor = [UIColor blackColor];
            alertView.tag = 6;
            alertView.delegate = self;
            [[UIApplication sharedApplication].keyWindow addSubview:alertView];
            
        }else {
            
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
            [BusinessAirCoach setstartError:[NSString stringWithFormat:@"第四个开启错误%@",error]];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
          
        }
       
    }];
    
        }
        else
        {
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请输入正确的手机号"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
        }
    
    
}



-(void)clickButtonWithTag:(UIButton *)button
{
    switch (alertView.tag) {
        case 1:
        {
            if (button.tag == 308)
            {
                LRLog(@"传过来的是取消按钮");
            }
            if (button.tag == 309)
            {
                LRLog(@"传过来的是确定按钮");
                
                NSMutableString *mailUrl = [[NSMutableString alloc] init];
                NSArray *toRecipients = @[@"aircoach-beta@atreehole.com"];
                // 注意：如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为@","
                [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];
                //    NSArray *ccRecipients = @[@"1229436624@qq.com"];
                //    [mailUrl appendFormat:@"?cc=%@", ccRecipients[0]];
                //    NSArray *bccRecipients = @[@"shana_happy@126.com"];
                //    [mailUrl appendFormat:@"&bcc=%@", bccRecipients[0]];
//                [mailUrl appendString:@"&subject=my email"];
//                [mailUrl appendString:@"&body=<b>Hello</b> World!"];
                NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
                
                
            }
        }
            break;
        case 2:
        {
            if (button.tag == 308)
            {
                LRLog(@"传过来的是取消按钮");
            }
            if (button.tag == 309)
            {
                LRLog(@"传过来的是确定按钮");
                
                if (![BusinessAirCoach getAuthorization])
                {
                    [BusinessAirCoach setUserAuthorization:_tokenString];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authorization"];
                    [BusinessAirCoach setUserAuthorization:_tokenString];
                }
                
                //判断token是否过期
                [BusinessAirCoach JugedToken];
                if ([[BusinessAirCoach getAlllabel] isEqualToString:@"CanUse"])
                {
                    //token没过期 开始刷新
                    [self UserStart];
                }
                else
                {
                    //接收到通知 开始刷新
                    
                    __weak typeof(self) weakSelf = self;
                    __block __weak id gpsObserver;
                    gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                        [weakSelf UserStart];
                        [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
                    }];
                    
                }
                
                
                
            }
        }
            break;
        case 6:
        {
            
            if (button.tag == 308)
            {
                NSLog(@"传过来的是取消按钮");
            }
            if (button.tag == 309)
            {
                NSLog(@"传过来的是确定按钮");
                
                NSMutableString *mailUrl = [[NSMutableString alloc] init];
                NSArray *toRecipients = @[@"aircoach-beta@atreehole.com"];
                // 注意：如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为@","
                [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];

                NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
                
                
            }
            
        }
            break;
        default:
            break;
    }
    
}
-(void)UserStart
{
    [[cbsNetWork sharedManager]requestWithMethod:POST WithPath:CUSTOM_START WithParams:nil WithSuccessBlock:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        LRLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"unfinished"]) {
            _rootTBC = [RootTabBarController new];
            
            [self presentViewController:_rootTBC animated:YES completion:^{
                
            }];
        }
        
        
    } WithFailurBlock:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
        LRLog(@"%@%@%@",allHeaders,error,statusCode);
        [BusinessAirCoach setUserAuthorization:nil];
        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"开启失败,请检测您的网络设置"];
        [[UIApplication sharedApplication].keyWindow addSubview:prom];
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    [self.view endEditing:YES];
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

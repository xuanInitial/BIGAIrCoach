//
//  AVEndViewController.m
//  AirCoach.acUser
//
//  Created by xuan on 15/12/21.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "AVEndViewController.h"
#import "WeekPlanModel.h"
#import "CourseModel.h"
#import "HardScrollView.h"
#import "NTESSessionViewController.h"
#import "RootTabBarController.h"
@interface AVEndViewController ()<Acfeeldelegate>
{
    NSString *fenxianText;
}
@property (copy, nonatomic)NSString *type;

@property ( nonatomic) NSInteger historyID;
@property (nonatomic, strong) CourseModel *courseModel;

@property(nonatomic,strong)HardScrollView *HardScorll;

@property(nonatomic,strong)NSString *speakToNurse;

@property(nonatomic)BOOL isfeelBtn;
@property(nonatomic)CGFloat MyW;

@property(nonatomic)CGFloat MyH;
@end

@implementation AVEndViewController

- (BOOL)shouldAutorotate
{
   // LRLog(@"让不让我旋转?");
    return YES;
}
////强制竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
   // LRLog(@"让我旋转哪些方向");
    return UIInterfaceOrientationMaskPortrait;
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _bgWiterView.layer.cornerRadius = 4;
    _bgWiterView.layer.masksToBounds = YES;
    
    _yiBanBtn.selected = YES;
    _type = @"kind";
    [_yiBanLabel setTextColor:ZhuYao];
    
    _fanHuiBtn.userInteractionEnabled = YES;
     [self queryData:@"UserCourseDetails"];
    
    if (SCREENHEIGHT > SCREENWIDTH)
    {
        _MyW = SCREENWIDTH;
        _MyH = SCREENHEIGHT;
    }else
    {
        _MyW = SCREENHEIGHT;
        _MyH = SCREENWIDTH;
    }
    
    _HardScorll = [[HardScrollView alloc]initWithFrame:CGRectMake(0, 160, SCREENHEIGHT - 30, 198)];
    _HardScorll.Acfeel = self;
    [_bgWiterView addSubview:_HardScorll];
    
}


-(void)touchFeelbutton:(NSInteger)mytag
{
    NSLog(@"点击了按钮");
    switch (mytag) {
        case 1:
           _speakToNurse = @"###我现在的训练方案强度稍大，能否帮我降低一点训练难度？";
            break;
        case 2:
            _speakToNurse = @"###我现在的训练方案太简单了，能否帮我分析下动作是否标准？";
            break;
        case 3:
            _speakToNurse = @"###护理师";
            break;
        default:
            break;
    }
   //上传数据并跳转
    
    _isfeelBtn = YES;
    [self messageBtnClick];
    
    
    
}
#pragma mark ---进入云信
-(void)jumpYunxin
{
   
    
    
    [BusinessAirCoach setUserSpeaker:_speakToNurse];
    NIMSession *session = [NIMSession session:[BusinessAirCoach getCoachAcc_id] type:NIMSessionTypeP2P];
    
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    [vc.navigationController setNavigationBarHidden:NO animated:YES];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//取数据
- (void)queryData:(NSString *)sqlName{
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@%@.sqlite",sqlName,[BusinessAirCoach getTel],[BusinessAirCoach getPlancurID]]  dbHandler:^(FMDatabase *nn_db) {
        NSString *qSql = @"SELECT * FROM OLD WHERE UserID = ?";
        FMResultSet *set = [nn_db executeQuery:qSql,[BusinessAirCoach getTel]];
        
        if ([sqlName isEqualToString:@"UserCourseDetails"]) {
            while ([set next]) {
                
                NSData *CourseData = [set dataForColumn:@"UserCourseDetails"];
                
                
                _courseModel = [CourseModel mj_objectWithKeyValues:[NSKeyedUnarchiver unarchiveObjectWithData:CourseData]];
                
                
                
                MyAttributedStringBuilder *builder = [[MyAttributedStringBuilder alloc] initWithString:[NSString stringWithFormat:@"完成了第%ld/%ld次的训练",_courseModel.complete +1,(long)_courseModel.total]];
               
                NSInteger leng;
                
                    leng =  [NSString stringWithFormat:@"%ld",(long)_courseModel.complete+1].length;
            
                
                [[builder range:NSMakeRange(4,leng)] setFont:[UIFont systemFontOfSize:45]];
                self.wanchengLabel.attributedText = builder.commit;
                
                self.kechengName.text = _courseModel.name;
                
            }
        }
        
    }];
}



- (IBAction)kunNanBtnClick:(UIButton *)sender {
    _kunNanBtn.selected = YES;
    [_kunNanLabel setTextColor:ZhuYao];
    _yiBanBtn.selected = NO;
    [_yiBanLabel setTextColor:[UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1.0]];
    _qingsongBtn.selected = NO;
    [_qingSongLabel setTextColor:[UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1.0]];
    _type = @"trouble";
     [TalkingData trackEvent:@"训练视频播放页面_选择了难易度"];
}
- (IBAction)yiBanBtnClick:(UIButton *)sender {
   
    _kunNanBtn.selected = NO;
    [_kunNanLabel setTextColor:[UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1.0]];
    _yiBanBtn.selected = YES;
    [_yiBanLabel setTextColor:ZhuYao];
    _qingsongBtn.selected = NO;
    [_qingSongLabel setTextColor:[UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1.0]];
    _type = @"kind";
    [TalkingData trackEvent:@"训练视频播放页面_选择了难易度"];
}
- (IBAction)qingSongBtnClick:(UIButton *)sender {
    _kunNanBtn.selected = NO;
    [_kunNanLabel setTextColor:[UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1.0]];
    _yiBanBtn.selected = NO;
    [_yiBanLabel setTextColor:[UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1.0]];
    _qingsongBtn.selected = YES;
    [_qingSongLabel setTextColor:ZhuYao];
    _type = @"easy";
    [TalkingData trackEvent:@"训练视频播放页面_选择了难易度"];
}

#define mark  分享
//- (IBAction)fenXiangBtnClick:(UIButton *)sender {
//    
//    NSLog(@"点击了分享按钮");
//    
//    [self updateUserHistory];
//    
//    NSDictionary*contentDiction = @{@"plan_id":[NSString stringWithFormat:@"%ld",(long)_weepPlanModels.plan.hostID],
//                                    @"complete":[NSString stringWithFormat:@"%ld",[_weepPlanModels.complete integerValue]+1],
//                                    @"plan_count":_weepPlanModels.plan_count
//                                   };
//    
//    NSString *contentJsonString =  [self toJSONData:contentDiction];
//    
//    NSLog(@"%@",contentJsonString);
//    
//    NSString *shareToken = [TokenGet getTwoMinutesOfToken];
//    NSDictionary *shareDiction = @{@"userId":[BusinessAirCoach getUserId],
//                                   @"type":@"plan",
//                                   @"content":contentJsonString,
//                                   @"token":shareToken};
//    [HttpRefreeshNetworking POST:shareUrl parameters:shareDiction CacheData:^(id responseObject) {
//        
//    } success:^(id responseObject) {
//        
//        NSLog(@"%@",responseObject);
//        
//        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
//            NSString *URLString = [[responseObject objectForKey:@"data"] objectForKey:@"url"];
//            
//            NSLog(@"%@",URLString);
//            
//            
//            
//            //1、创建分享参数
//            NSArray* imageArray = @[[UIImage imageNamed:@"分享图标图片.png"]];
//            //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//            if (imageArray) {
//                
//                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//                
//                if (!_weepPlanModels.coach.name) {
//                    fenxianText = [NSString stringWithFormat:@"我刚完成了光合教练的训练计划：%@，练完巨酸爽！",_weepPlanModels.plan.name];
//                } else {
//                    fenxianText  = [NSString stringWithFormat:@"%@教练 为我量身定制了计划：%@，练完巨酸爽！",_weepPlanModels.coach.name,_weepPlanModels.plan.name];
//                }
//              
//                
//                [shareParams SSDKSetupShareParamsByText:@"光合教练-真人教练在线 定制健身服务"
//                                                 images:imageArray
//                                                    url:[NSURL URLWithString:URLString]
//                                                  title:fenxianText
//                                                   type:SSDKContentTypeAuto];
//                //  2、分享（可以弹出我们的分享菜单和编辑界面）
//                //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                
//                
//                [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                    
//                    
//                    switch (state) {
//                        case SSDKResponseStateSuccess:
//                        {
//                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                message:nil
//                                                                               delegate:nil
//                                                                      cancelButtonTitle:@"确定"
//                                                                      otherButtonTitles:nil];
//                            [alertView show];
//                            break;
//                        }
//                            
//                            
//                            
//                        case SSDKResponseStateFail:
//                        {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                            message:@"暂时只支持分享到微信。"
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"OK"
//                                                                  otherButtonTitles:nil, nil];
//                            
//                            NSLog(@"%@",error);
//                            [alert show];
//                            break;
//                        }
//                        default:
//                            break;
//                    }
//                    
//                }];
//                
//            }
//            
//            
//            
//
//        }else{
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:@"请求分享Url失败"];
//        }
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"%@",error);
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
//    }];
//    
//    
//    
//    
//    
//    
//    
//}
-(void)messageBtnClick
{
    //判断token是否过期
    [BusinessAirCoach JugedToken];
    if ([[BusinessAirCoach getAlllabel] isEqualToString:@"CanUse"])
    {
        //token没过期 开始刷新
        [self UploadVideoPlaybackAfterTheCompletionOfTheData];
    }
    else
    {
        //接收到通知 开始刷新
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RequstAllready" object:nil];
        __weak typeof(self) weakSelf = self;
        __block __weak id gpsObserver;
        gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf UploadVideoPlaybackAfterTheCompletionOfTheData];
            [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
        }];
        
    }
 
}
- (IBAction)fanHuiBtnClick:(UIButton *)sender {
    
    _fanHuiBtn.userInteractionEnabled = NO;
    if (_isfeelBtn == YES)
    {
        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:NO completion:^{
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(backCourseDetail)])
            {
                [weakSelf.delegate backCourseDetail];
            }
            
        }];
    }
    else
    {
        //判断token是否过期
        [BusinessAirCoach JugedToken];
        if ([[BusinessAirCoach getAlllabel] isEqualToString:@"CanUse"])
        {
            //token没过期 开始刷新
            [self UploadVideoPlaybackAfterTheCompletionOfTheData];
        }
        else
        {
            //接收到通知 开始刷新
            //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RequstAllready" object:nil];
            __weak typeof(self) weakSelf = self;
            __block __weak id gpsObserver;
            gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                [weakSelf UploadVideoPlaybackAfterTheCompletionOfTheData];
                [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
            }];
            
        }
 
    }
    
    
    [TalkingData trackEvent:@"训练视频播放页面_完成了一次训练"];
    

   
}

//更新数据

//-(void)updateUserHistory{
//    
//    
//    NSString *tokens = [TokenGet getTwoMinutesOfToken];
//    
//    NSDictionary *dics = @{@"id":[NSString stringWithFormat:@"%ld",_weepPlanModels.plan_id],
//                          @"count":[NSString stringWithFormat:@"%@/%@",_weepPlanModels.complete,_weepPlanModels.plan_count],
//                          @"feedback":_type};
//    NSString *jsonString =  [self toJSONData:dics];
//    NSDictionary *parameter = @{@"userId":[BusinessAirCoach getUserId],
//                                @"type":@"plan",
//                                @"content":jsonString,
//                                @"token":tokens,
//                                @"historyId":[NSString stringWithFormat:@"%ld",_historyID]
//                               };
//    [HttpRefreeshNetworking POST:Update_user_history parameters:parameter CacheData:^(id responseObject) {
//        
//    } success:^(id responseObject) {
//        
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxin" object:nil];
//        
//        NSLog(@"%@",responseObject);
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"%@",error);
//        
//        [SVProgressHUD showErrorWithStatus:@"错误"];
//        
//    }];
//}
//
//
//
//上传数据
- (void)UploadVideoPlaybackAfterTheCompletionOfTheData{
    
    __weak typeof(self) weakSelf = self;
    if (_isfeelBtn == YES)
    {
        [self jumpYunxin];
    }
    else
    {
        [self dismissViewControllerAnimated:NO completion:^{
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(backCourseDetail)])
            {
                [weakSelf.delegate backCourseDetail];
            }
            
        }];
    }

    [[cbsNetWork sharedManager]requestWithMethod:POST WithPath:[NSString stringWithFormat:PLANSHOW,(long)_courseModel.hostID] WithParams:0 WithSuccessBlock:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
      
        [[NSNotificationCenter defaultCenter] postNotificationName:@"trainRefresh" object:nil];
        
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseDetailsRefresh" object:nil];
       
        _fanHuiBtn.userInteractionEnabled = YES;
        
    } WithFailurBlock:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
         _fanHuiBtn.userInteractionEnabled = YES;
        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
        [[UIApplication sharedApplication].keyWindow addSubview:prom];
    }];
    
    

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

@end

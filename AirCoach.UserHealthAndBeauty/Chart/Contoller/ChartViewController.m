//
//  ChartViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/3.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "ChartViewController.h"
#import "MainChartTableViewCell.h"
#import "ReportTableViewCell.h"
#import "ReportModel.h"
#import "ReportCoach.h"
#import "SubReportTableViewCell.h"
#import "NNFMDBTool.h"
#import "PersonTestViewController.h"
@interface ChartViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WaitingForDelegate>
@property(nonatomic,strong)UIScrollView *MainScrollView;
@property(nonatomic,strong)UICollectionView *ChartCollectionView;
@property(nonatomic,strong)UITableView *MaintableView;
@property(nonatomic,strong)NSMutableArray *xNum;
@property(nonatomic,strong)NSMutableArray *xValue;
@property(nonatomic,strong)NSMutableArray *time;
@property(nonatomic,strong)NSMutableArray *ReportArr;
@property(nonatomic,strong)NSMutableArray *SortReportArr;//存放排序好的评论数据

@property(nonatomic,strong)NSArray *TestArr;
@property(nonatomic,strong)UIVisualEffectView *headView;

@property(nonatomic,strong)NSIndexPath *lastIndexPath;

//跳转至体测页的按钮
@property(nonatomic,strong)UIButton *jumpTestPageBtn;

//是否重新赋值标签
@property(nonatomic)BOOL isAssignment;

@property(nonatomic,strong)UIButton *rightButton;
@end

@implementation ChartViewController

- (BOOL)shouldAutorotate
{
    LRLog(@"让不让我旋转?");
    return YES;
}



-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}



-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
-(NSMutableArray *)time
{
    if (!_time)
    {
        _time = [NSMutableArray array];
    }
    return _time;
}
-(NSMutableArray *)ReportArr
{
    if (!_ReportArr)
    {
        _ReportArr = [NSMutableArray array];
    }
    return _ReportArr;
}
-(NSMutableArray *)SortReportArr
{
    if (!_SortReportArr)
    {
        _SortReportArr = [NSMutableArray array];
    }
    return _SortReportArr;
}
-(NSMutableArray *)xNum
{
    if (!_xNum)
    {
        _xNum = [NSMutableArray array];
    }
    return _xNum;
}
-(NSMutableArray *)xValue
{
    if (!_xValue)
    {
        _xValue = [NSMutableArray array];
    }
    return _xValue;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    if (_isWaitingFor != nil)
    {
       [self loadChartData];
    }    
     [TalkingData trackPageBegin:@"数据图表页面"];
    
   
    //判断填写数据按钮是否出现
    [self JugdeBtnIsAble];
}

-(void)loadChartData
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
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RequstAllready" object:nil];
        __weak typeof(self) weakSelf = self;
        __block __weak id gpsObserver;
        gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf loadData];
            [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
        }];
        
    }
 
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isWaitingFor = nil;
    [TalkingData trackPageEnd:@"数据图表页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"身体数据";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CreatUI];
    
    //创建缓存
    [self createSQLite];
    //取数据
    [self queryData];
    
    [self loadChartData];
    
}





-(void)CreatUI
{
    
    
    _MaintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49) style:UITableViewStylePlain];
    _MaintableView.delegate = self;
    _MaintableView.dataSource = self;
    [self.view addSubview:_MaintableView];
    [_MaintableView registerClass:[MainChartTableViewCell class] forCellReuseIdentifier:@"ChartCell"];
    [_MaintableView registerClass:[ReportTableViewCell class] forCellReuseIdentifier:@"ReportCell"];
    [_MaintableView registerClass:[SubReportTableViewCell class] forCellReuseIdentifier:@"SubReportCell"];
    
    _MaintableView.showsVerticalScrollIndicator = NO;
    [_MaintableView sendSubviewToBack:_MaintableView];
    
    _MaintableView.tag = 1001;
    
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _headView = [[UIVisualEffectView alloc]initWithEffect:blur];
    _headView.frame =CGRectMake(0, 0, SCREENWIDTH, 64);
    _headView.alpha = 0;
    [self.view addSubview:_headView];
    [self.view bringSubviewToFront:_headView];
    
    
    
    UILabel *ItemLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 44)];
    ItemLable.text = @"身体数据统计表";
    ItemLable.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    ItemLable.textAlignment = 1;
    ItemLable.textColor = ZhuYao;
    self.navigationItem.titleView = ItemLable;
    
    //右上角填写测试数据按钮
    UIImage *NormImage = [[UIImage imageNamed:@"icon-填写"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *diableImage = [[UIImage imageNamed:@"icon-已填写"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 44,0,44,44)];
   [_rightButton setBackgroundImage:NormImage forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(jumpTestPage) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setBackgroundImage:diableImage forState:UIControlStateDisabled];
    [self.navigationController.navigationBar addSubview:_rightButton];

    
    self.navigationItem.leftBarButtonItem = nil;
    
    
}
-(void)JugdeBtnIsAble
{
    //判断去填写按钮是否可用  通过时间
    //获取最新一次提交的时间
    if ([BusinessAirCoach getUserTestTime] != nil)
    {
        NSDictionary *dic = [BusinessAirCoach getUserTestTime];
        NSString *TestTime = dic[@"UserTime"];
        
        //需要转换的字符串
        NSString *dateString = TestTime;
        //设置转换格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //NSString转NSDate
        NSDate *date=[formatter dateFromString:dateString];
        
        
        NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
        NSTimeInterval timeNow = [zone secondsFromGMTForDate:[NSDate date]];
        NSDate *dateNow = [[NSDate date] dateByAddingTimeInterval:timeNow];
        
        
        NSTimeInterval timefir = [zone secondsFromGMTForDate:date];
        NSDate *datefir = [date dateByAddingTimeInterval:timefir];
        NSTimeInterval timeFir = [datefir timeIntervalSince1970];
        NSTimeInterval timeLNow = [dateNow timeIntervalSince1970];
        if ((int)(timeLNow / (3600 * 24)) > (int)(timeFir / (3600 * 24)))
        {
           //右键是否可点击
            self.rightButton.enabled = YES;
        }
        else
        {
            self.rightButton.enabled = NO;
        }

    }
    else
    {
       self.rightButton.enabled = YES;
    }
    
    
    
}


-(void)jumpTestPage
{
    PersonTestViewController *vc = [PersonTestViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.B_delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
//实现协议法
-(void)setValueA:(NSString *)string
{
    _isWaitingFor = string;
}
-(void)showWaiting
{
   
}
-(void)loadData
{
     [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeCustom];
    [[HttpsRefreshNetworking Networking] GET:CHECKING parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
       LRLog(@"--%@pp%@%@",allHeaders,responseObject,statusCode);
       
       
        @try
        {
            if ([statusCode isEqualToString:@"200"])
            {
                
                [self jsonMydata:responseObject];
                
                [_MaintableView reloadData];
                
                //删除数据 存数据
                [self deleteData];
                [self insertData:responseObject];
             
                [SVProgressHUD dismiss];
            }
        } @catch (NSException *exception)
        {
            //解析错误 发送talkingData
            [SVProgressHUD dismiss];
        }
        
        
        
       
   } failure:^(NSDictionary *allHeaders,NSError *error,id statusCode) {
       LRLog(@"%@",error);
       if ([allHeaders objectForKey:@"Authorization"]) {
           
           [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Authorization"];
           [BusinessAirCoach setUserAuthorization:[allHeaders objectForKey:@"Authorization"]];
       }
       PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
       [[UIApplication sharedApplication].keyWindow addSubview:prom];
       [SVProgressHUD dismiss];
   }];
    
}
-(void)jsonMydata:(id)Mydata
{
    _isAssignment = YES;
    //正式数据
    
    NSArray *weight = [Mydata objectForKey:@"weight"];
    NSArray *heart_rate = [Mydata objectForKey:@"heart_rate"];
    NSArray *hold_breath = [Mydata objectForKey:@"hold_breath"];
    NSArray *strength = [Mydata objectForKey:@"strength"];
    
        
    
    
    NSDictionary *dic = [weight firstObject];
    
    NSString *startTime = dic[@"date"];
    [BusinessAirCoach setUserStartTime:startTime];
    //时间数组
    [self.time removeAllObjects];
    for (NSDictionary *dic in weight)
    {
        
        [self.time addObject:dic[@"date"]];
    }
    
    
    
    _TestArr = @[weight,heart_rate,hold_breath,strength];
    
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd"];
    
    LRLog(@"%@",self.time);
    
    //计算日期差值 点的x坐标
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitflags = NSDayCalendarUnit;
    [self.xNum removeAllObjects];
    for (int i = 0; i < _time.count;i++)
    {
        NSDateComponents *d = [cal components:unitflags fromDate:[date dateFromString:startTime]toDate:[date dateFromString:self.time[i]] options:0];
        [d day];
        LRLog(@"%ld",(long)[d day]);
        [self.xNum addObject:[NSString stringWithFormat:@"%ld",(long)[d day]]];
    }
    LRLog(@"%@",self.xNum);
    
    //评论
    
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval timeNow = [zone secondsFromGMTForDate:[NSDate date]];
    
    NSArray *mainArr = [Mydata objectForKey:@"reviews"];
    [self.ReportArr removeAllObjects];
    for (NSDictionary *dic in mainArr)
    {
        ReportModel *model = [ReportModel mj_objectWithKeyValues:dic];
        [self.ReportArr addObject:model];
    }
    //冒泡排序 最新日期出现在前面
    if (self.ReportArr.count != 0 ||self.ReportArr.count != 1)
    {
        NSInteger m = self.ReportArr.count;
        for (int i = 0; i < self.ReportArr.count; i++)
        {
            m-=1;
            for (int j = 0; j < m; j++)
            {
                ReportModel *Firmodel = self.ReportArr[j];
                ReportModel *Secmodel = self.ReportArr[j + 1];
                if (Firmodel.created_at.length >= 10 && Secmodel.created_at.length >= 10)
                {
                    NSDate *dateS =[[formatter dateFromString:[Firmodel.created_at substringToIndex:10]] dateByAddingTimeInterval:timeNow];//开始时间
                    NSDate *dateE =[[formatter dateFromString:[Secmodel.created_at substringToIndex:10]] dateByAddingTimeInterval:timeNow];//结束时间
                    NSTimeInterval timeS = [dateS timeIntervalSince1970];
                    NSTimeInterval timeE = [dateE timeIntervalSince1970];
                    if (timeS < timeE)
                    {
                        [self.ReportArr exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                    }
                    else
                    {
                        
                    }
 
                }
            }
        }
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.ReportArr.count == 0)
    {
        return 1;
    }
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
        if (self.ReportArr.count == 0)
        {
            return 1;
        }
        else
        {
            return self.ReportArr.count;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MainChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChartCell"];
        if (!cell)
        {
            cell = [[MainChartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChartCell"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //线程一塌糊涂 学好了再回来
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"block执行");
           dispatch_async(dispatch_get_main_queue(), ^{
               if (self.xNum.count != 0&&_TestArr != nil&&_time != nil && _isAssignment == YES)
               {
                   //点的x值坐标
                   cell.CollocetionCellArr = self.xNum;
                   //四组值
                   cell.cellArr = _TestArr;
                   //时间key值
                   cell.TimeArr = _time;
                   
                   _isAssignment = NO;
                   
               }
 
           });
            
        });
        NSLog(@"开始执行");
        return cell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            ReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell"];
            if (!cell)
            {
                cell = [[ReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReportCell"];
            }
            if (self.ReportArr.count != 0)
            {
                ReportModel *model = self.ReportArr[indexPath.row];
                cell.ReportDetail = model;
            }
            else
            {
                UILabel *mylable = [UILabel new];
                cell.Mylable = mylable;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
 
        }
        else
        {
            SubReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubReportCell"];
            if (!cell)
            {
                cell = [[SubReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SubReportCell"];
            }
            
            ReportModel *model = self.ReportArr[indexPath.row];
            cell.ReportDetail = model;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
       return 546 + 124 + 20;
    }
    else
    {
        if (self.ReportArr.count != 0)
        {
            ReportModel *model = self.ReportArr[indexPath.row];
            if (indexPath.row == 0)
            {
                UILabel *mylabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 30, 50)];
                mylabel.font = [UIFont systemFontOfSize:14];
                mylabel.numberOfLines = 0;
                CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREENWIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                LRLog(@"%lf",size.height);
                
                NSMutableAttributedString *str = [self TheLabletext:model.content];
                mylabel.attributedText = str;
                mylabel.height = size.height;
                //_word.y =_head.y + 72;
                [mylabel sizeToFit];
                LRLog(@"jhsk%lf",mylabel.height);
                CGFloat myheight = mylabel.height;
                return myheight + 126;
                
            }
            else
            {
                UILabel *mylabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 30, 50)];
                mylabel.font = [UIFont systemFontOfSize:14];
                mylabel.numberOfLines = 0;
                
                CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREENWIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                LRLog(@"%lf",size.height);
                
                NSMutableAttributedString *str = [self TheLabletext:model.content];
                mylabel.attributedText = str;
                mylabel.height = size.height;
                [mylabel sizeToFit];
                LRLog(@"jhsk%lf",mylabel.height);
                CGFloat myheight = mylabel.height;
                return myheight + 52;
                
                
                
            }
  
        }
        else
        {
            return 100;
        }
    }
}
//行距设置
-(NSMutableAttributedString*)TheLabletext:(NSString*)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //paragraphStyle.maximumLineHeight = 18;  //最大的行高
    paragraphStyle.lineSpacing = 5;  //行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset=scrollView.contentOffset.y;

    if (scrollView.tag == 1001)
    {
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 85)
        {
           CGFloat alpha=1 - ((85-offset)/85);
            _headView.alpha = alpha;
        }
        else if (scrollView.contentOffset.y > 85)
        {
            _headView.alpha = 1;
        }
        else
        {
            _headView.alpha = 0;
        }
    }
    
    
    
    
}


/**存储数据**/
//创建表
- (void)createSQLite{
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"UserBodyData%@.sqlite",[BusinessAirCoach getTel]] dbHandler:^(FMDatabase *nn_db) {
        NSString *cSql = @"CREATE TABLE IF NOT EXISTS OLD (id INTEGER PRIMARY KEY, UserID TEXT NOT NULL, UserBodyData TEXT NOT NULL)";
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
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"UserBodyData%@.sqlite",[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
        NSString * sql = @"insert into OLD (UserID, UserBodyData) values(?, ?)";
        NSData *UserBodyData = [NSKeyedArchiver archivedDataWithRootObject:modelArray];
        NSString *UserID = [BusinessAirCoach getTel];
        BOOL res = [nn_db executeUpdate:sql, UserID, UserBodyData];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"OK");
        }
    }];
}
//取数据
- (void)queryData{
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"UserBodyData%@.sqlite",[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
        NSString *qSql = @"SELECT * FROM OLD WHERE UserID = ?";
        FMResultSet *set = [nn_db executeQuery:qSql,[BusinessAirCoach getTel]];
        while ([set next]) {
            
            
            NSData *StageData = [set dataForColumn:@"UserBodyData"];
           
            [self jsonMydata:[NSKeyedUnarchiver unarchiveObjectWithData:StageData]];
            
            [_MaintableView reloadData];

            
            
        }
    }];
}
//删除数据
- (void)deleteData {
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"UserBodyData%@.sqlite",[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
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
            
            [self.xNum removeAllObjects];
            [self.xValue removeAllObjects];
            [self.time removeAllObjects];
            [self.ReportArr removeAllObjects];
            self.TestArr = nil;
            self.view = nil;
        }
    }
    
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

//
//  MyPlanViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/5/30.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "MyPlanViewController.h"
#import "PlanTableViewCell.h"
#import "PlanHeaderView.h"
#import "PlanModel.h"
#import "DownLineViewController.h"
#import "TestTableViewCell.h"
#import "StageModel.h"
#import "UserPlanModel.h"
#import "NewPlanTableViewCell.h"
#import "DietPlanTableViewCell.h"
#import "OpenModel.h"
#import "UserPlanDetailViewController.h"
#import "NNFMDBTool.h"
#import "StartViewController.h"
#import "UILabel+TopAndBottom.h"
//伸缩导航栏
#import "SquareCashStyleBar.h"
#import "SquareCashStyleBehaviorDefiner.h"
#import "BLKDelegateSplitter.h"

@interface MyPlanViewController ()<UITableViewDelegate,UITableViewDataSource,HeaderViewDelegate,UIScrollViewDelegate,PlanWaitingForDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *sectionArr;
@property(nonatomic,strong)NSArray *rowArr;
@property(nonatomic,strong)NSMutableDictionary *showdic;
@property(nonatomic)NSInteger Mynum;
@property(nonatomic,strong)NSMutableArray *ItemArr;
@property(nonatomic,strong)UIImageView *header;
@property(nonatomic,strong)UILabel *userName;
@property(nonatomic,strong)UIImageView *user;

@property(nonatomic)BOOL mystage;

@property(nonatomic)NSInteger Record;

//可伸缩性导航栏
@property (nonatomic) SquareCashStyleBar *myCustomBar;
@property (nonatomic) BLKDelegateSplitter *delegateSplitter;



@end

@implementation MyPlanViewController
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
    LRLog(@"让不让我旋转?");
    return NO;
}
-(NSMutableArray *)ItemArr
{
    if (!_ItemArr)
    {
        _ItemArr = [NSMutableArray array];
    }
    return _ItemArr;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(NSMutableArray *)sectionArr
{
    if (!_sectionArr)
    {
        _sectionArr = [NSMutableArray array];
    }
    return _sectionArr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isWaiting == nil)
    {
      [self showWaiting];
    }
     [TalkingData trackPageBegin:@"计划总表页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"计划总表页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    
    
    self.tableview.contentInset = UIEdgeInsetsMake(168, 0.0, 10.0, 0.0);
    
    //设置顶部栏
    self.myCustomBar = [[SquareCashStyleBar alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 100.0)];
    SquareCashStyleBehaviorDefiner *behaviorDefiner = [[SquareCashStyleBehaviorDefiner alloc] init];
    [behaviorDefiner addSnappingPositionProgress:0.0 forProgressRangeStart:0.0 end:0.5];
    [behaviorDefiner addSnappingPositionProgress:1.0 forProgressRangeStart:0.5 end:1.0];
    behaviorDefiner.snappingEnabled = YES;
    behaviorDefiner.elasticMaximumHeightAtTop = YES;
    self.myCustomBar.behaviorDefiner = behaviorDefiner;
    
    self.delegateSplitter = [[BLKDelegateSplitter alloc] initWithFirstDelegate:behaviorDefiner secondDelegate:self];
    self.tableview.delegate = (id<UITableViewDelegate>)self.delegateSplitter;
    
    [self.view addSubview:self.myCustomBar];
    
    
    self.tableview.dataSource = self;
   
    
    [self.tableview registerClass:[PlanTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.tableview registerNib:[UINib nibWithNibName:@"TestTableViewCell" bundle:nil] forCellReuseIdentifier:@"testCell"];
    [self.tableview registerClass:[DietPlanTableViewCell class] forCellReuseIdentifier:@"DietPlan"];
    [self.tableview registerClass:[NewPlanTableViewCell class] forCellReuseIdentifier:@"NewPlan"];

    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
    
    self.tableview.backgroundColor =[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    
    //返回键
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.frame = CGRectMake(SCREENWIDTH - 30, 28, 60, 60);
    [popBtn addTarget:self action:@selector(backPlanDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.myCustomBar addSubview:popBtn];
    
    //返回图标
    UIImageView *ClearImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 36, 28, 21, 21)];
    ClearImage.image = [UIImage imageNamed:@"白关闭"];
    [self.myCustomBar addSubview:ClearImage];
    popBtn.center = ClearImage.center;
    
    
    
    //读取缓存数据
    [self createSQLite];
    [self queryData];
    

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
-(void)showWaiting
{
   [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeCustom];
}
-(void)loadData
{
    //[self performSelector:@selector(showWaiting) withObject:nil afterDelay:0.2];
    
    [[HttpsRefreshNetworking Networking] GET:STAGE parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
       
      
       @try
       {
           
           if ([statusCode isEqualToString:@"200"])
           {
               
               LRLog(@"%@",responseObject);
               
               NSArray *stageArr = [StageModel mj_objectArrayWithKeyValuesArray:responseObject];
               self.sectionArr = [NSMutableArray arrayWithArray:stageArr];
               
               [self.ItemArr removeAllObjects];
               for (int i = 0; i < self.sectionArr.count; i++)
               {
                   OpenModel *model = [OpenModel new];
                   [self.ItemArr addObject:model];
               }
               
               [_tableview reloadData];
               //删除老缓存
               [self deleteData];
               //加入新缓存
               [self insertData:responseObject];
               [SVProgressHUD dismiss];
           }

           
           
           
       } @catch (NSException *exception)
       {
           //解析错误 发送talkingData
           LRLog(@"解析出错,查找原因");
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    for (StageModel *model in self.sectionArr)
    {
       
        if (model.isopen == YES)
        {
            _mystage = YES;
            break;
        }
        else
        {
            _mystage = NO;
        }
    }
    
    return self.sectionArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    StageModel *model = self.sectionArr[section];
    NSArray *stageArr = model.plans;
    
    
    //状态
    if ([model.status isEqualToString:@"current"])
    {
        
        NSInteger count = model.isopen ? stageArr.count + 1 : 0;
        return count;
    }
    else
    {
        NSInteger count = model.isopen ? stageArr.count : 0;
        return count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    StageModel *Model = self.sectionArr[indexPath.section];
    NSArray *stageArr = [UserPlanModel mj_objectArrayWithKeyValuesArray:Model.plans];
    if ([Model.status isEqualToString:@"current"])
    {
        if (indexPath.row == stageArr.count)
        {
            
            NewPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewPlan" forIndexPath:indexPath];
            
            if (!cell)
            {
                cell = [[NewPlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewPlan"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            
            UserPlanModel *planModel = stageArr[indexPath.row];
            
            if ([planModel.type isEqualToString:@"training"])
            {
                //训练计划cell
                PlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
                
                if (!cell)
                {
                    cell = [[PlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
                    cell.selectionStyle =UITableViewCellSelectionStyleNone;
                    cell.separatorInset = UIEdgeInsetsZero;
                    cell.clipsToBounds = YES;
                }
                cell.planModel = planModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.CellbackView.mas_left).mas_offset(15);
                    make.right.equalTo(cell.CellbackView.mas_right).mas_offset(-15);
                    make.bottom.equalTo(cell.CellbackView.mas_bottom);
                    make.height.equalTo(@1);
                }];
                return cell;
            }
            else
            {
                //饮食计划cell
                DietPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DietPlan" forIndexPath:indexPath];
                
                if (!cell)
                {
                    cell = [[DietPlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DietPlan"];
                    cell.selectionStyle =UITableViewCellSelectionStyleNone;
                    cell.separatorInset = UIEdgeInsetsZero;
                    cell.clipsToBounds = YES;
                }
                cell.planModel = planModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
  
        }
        
        
        
     }
    else
    {
        
            
            UserPlanModel *planModel = stageArr[indexPath.row];
            
            if ([planModel.type isEqualToString:@"training"])
            {
                //训练计划cell
                PlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
                
                if (!cell)
                {
                    cell = [[PlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
                    cell.selectionStyle =UITableViewCellSelectionStyleNone;
                    cell.separatorInset = UIEdgeInsetsZero;
                    cell.clipsToBounds = YES;
                }
                cell.planModel = planModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.CellbackView.mas_left).mas_offset(15);
                    make.right.equalTo(cell.CellbackView.mas_right).mas_offset(-15);
                    make.bottom.equalTo(cell.CellbackView.mas_bottom);
                    make.height.equalTo(@1);
                }];
                if(indexPath.row == stageArr.count - 1)
                {
                    [cell.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.CellbackView.mas_left);
                        make.right.equalTo(cell.CellbackView.mas_right);
                        make.bottom.equalTo(cell.CellbackView.mas_bottom);
                        make.height.equalTo(@1);
                    }];
                }
                return cell;
            }
            else
            {
                //饮食计划cell
                DietPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DietPlan" forIndexPath:indexPath];
                
                if (!cell)
                {
                    cell = [[DietPlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DietPlan"];
                    cell.selectionStyle =UITableViewCellSelectionStyleNone;
                    cell.separatorInset = UIEdgeInsetsZero;
                    cell.clipsToBounds = YES;
                }
                cell.planModel = planModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
    
    return nil;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    StageModel *planHeader = self.sectionArr[section];
    if (planHeader.isopen == YES)
    {
        NSString *s = planHeader.discription.target;
        
        CGSize size = [s sizeWithFont: [UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREENWIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *detali = [[UILabel alloc]initWithFrame:CGRectMake(101, 37, SCREENWIDTH - 30, 12)];
       
    
        [detali setNumberOfLines:0];
        detali.font = [UIFont systemFontOfSize:15];
        detali.textAlignment = 0;
       
        detali.text = s;
        
        //此处注意行数不能忽略 将距离加入
        CGFloat strNum = [detali numberOfText];
        [detali sizeToFit];
        NSLog(@"标签高度%lf",size.height);
        NSLog(@"%lf---",size.height + 70 + strNum * 5 + 15 + 11);
        if (strNum == 1)
        {
           return  size.height + 70 + strNum * 5 + 13 + 11;
        }
        else
        {
           return  size.height + 70 + (strNum - 1) * 5 + 13 + 11;
        }
        
    }
    else
    {
        //固定高度
        return 81;
    }
   
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    static NSString *identifier = @"header";
    PlanHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[PlanHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    header.Itemsection = section;
    header.delegate = self;
    StageModel *planHeader = self.sectionArr[section];
    header.planHeader = planHeader;

    return header;
}
-(void)clickView
{
    [self.tableview reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 68;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    dispatch_async(dispatch_get_main_queue(), ^{
            StageModel *Model = self.sectionArr[indexPath.section];
            NSArray *stageArr = [UserPlanModel mj_objectArrayWithKeyValuesArray:Model.plans];
        
        
            if (indexPath.row < stageArr.count)
            {
                UserPlanModel *planModel = stageArr[indexPath.row];
                if ([planModel.type isEqualToString:@"training"])
                {
                    UserPlanDetailViewController *vc = [UserPlanDetailViewController new];
                    vc.planId = planModel.planId;
                    vc.planNameTs = planModel.name;
                    vc.planBackgroud = planModel.backgroud;
                    vc.C_delegate = self;
                    [self presentViewController:vc animated:YES completion:nil];
                }
  
            }
        
        
    });
    
    
}
-(void)setValueB:(NSString *)string
{
    _isWaiting = string;
}
-(void)backPlanDetail
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**存储数据**/
//创建表
- (void)createSQLite{
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"UserStage%@.sqlite",[BusinessAirCoach getTel]] dbHandler:^(FMDatabase *nn_db) {
        NSString *cSql = @"CREATE TABLE IF NOT EXISTS OLD (id INTEGER PRIMARY KEY, UserID TEXT NOT NULL, UserStage TEXT NOT NULL)";
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
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"UserStage%@.sqlite",[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
        NSString * sql = @"insert into OLD (UserID, UserStage) values(?, ?)";
        NSData *UserStage = [NSKeyedArchiver archivedDataWithRootObject:modelArray];
        NSString *UserID = [BusinessAirCoach getTel];
        BOOL res = [nn_db executeUpdate:sql, UserID, UserStage];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"OK");
        }
    }];
}
//取数据
- (void)queryData{
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"UserStage%@.sqlite",[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
        NSString *qSql = @"SELECT * FROM OLD WHERE UserID = ?";
        FMResultSet *set = [nn_db executeQuery:qSql,[BusinessAirCoach getTel]];
        while ([set next]) {
           
            NSData *StageData = [set dataForColumn:@"UserStage"];
            NSArray *stageArr = [StageModel mj_objectArrayWithKeyValuesArray:[NSKeyedUnarchiver unarchiveObjectWithData:StageData]];
            self.sectionArr = [NSMutableArray arrayWithArray:stageArr];
            
            
            for (int i = 0; i < self.sectionArr.count; i++)
            {
                OpenModel *model = [OpenModel new];
                [self.ItemArr addObject:model];
            }
            
            [_tableview reloadData];

            
        }
    }];
}
//删除数据
- (void)deleteData {
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"UserStage%@.sqlite",[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
        NSString *dSql = @"DELETE FROM OLD WHERE UserID = ?";
        BOOL res = [nn_db executeUpdate:dSql,[BusinessAirCoach getTel]];
        if (!res) {
            NSLog(@"error to DELETE data");
        } else {
            NSLog(@"succ to DELETE data");
            
        }
    }];
    
}

#pragma mark ---处理内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (!self.view.window) {
            [self.sectionArr removeAllObjects];
            [self.showdic removeAllObjects];
            [self.ItemArr removeAllObjects];
            self.rowArr = nil;
            self.view = nil;
        }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

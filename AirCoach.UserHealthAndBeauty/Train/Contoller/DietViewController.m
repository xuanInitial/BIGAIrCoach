//
//  DietViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/1.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "DietViewController.h"
#import "DietTableViewCell.h"
@interface DietViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic, strong) UIVisualEffectView *maoboliView;

@property (nonatomic) BOOL showTag;



@end

@implementation DietViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_细线.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
     [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.navigationController.navigationBar.translucent = YES;
    
    //设置电池条为白色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [TalkingData trackPageBegin:@"饮食推荐页面"];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
     [TalkingData trackPageEnd:@"饮食推荐页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _showTag = NO;
    
    
    //设置电池条为白色
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    //self.title = @"饮食计划";
    self.titleLabel.text = @"饮食推荐";
    self.titleLabel.textColor = ZhuYao;
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [self creatUI];
    
    [self iOS8blurAction];
    
   
    
    
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
-(void)creatUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.navigationController.navigationBar.tintColor= [UIColor blackColor];
           //头部图及控件
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 55*HEIGHTBASE)];
        head.backgroundColor = [UIColor whiteColor];
        
    
        //分段选择器
        NSArray *segement = [[NSArray alloc]initWithObjects:@"显示千卡(kCal)",@"显示千焦(KJ)",nil];
        UISegmentedControl *segementCon = [[UISegmentedControl alloc]initWithItems:segement];
        segementCon.frame = CGRectMake(15, 20, SCREENWIDTH - 30, 30);
        segementCon.tintColor = SegementColor;
        segementCon.segmentedControlStyle = UISegmentedControlStylePlain;
        segementCon.selectedSegmentIndex = 0;
        [head addSubview:segementCon];
        
        [segementCon addTarget:self action:@selector(choiceSegement:) forControlEvents:UIControlEventValueChanged];
        
        
        _tableView.tableHeaderView = head;

    
}

-(void)choiceSegement:(UISegmentedControl*)sege
{
    switch (sege.selectedSegmentIndex) {
        case 0:{
            LRLog(@"点击了第一个");
            _showTag = NO;
            [ self.tableView reloadData];
        }
            
            break;
        case 1:{
            LRLog(@"点击了第二个");
            _showTag = YES;
            
            [ self.tableView reloadData];
        }
            
            break;
        default:
            break;
    }
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DietTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dietCell"];
    
    if (!cell) {
        
        cell = [[DietTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dietCell"];
    }
    
    cell.Mysection = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showFlag = _showTag;
       
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 178;
}

#pragma mark ---处理内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (!self.view.window) {
            
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

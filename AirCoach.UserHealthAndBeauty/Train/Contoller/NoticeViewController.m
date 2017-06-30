//
//  NoticeViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/16.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeModel.h"
#import "NoticTableViewCell.h"
#import "VideoDetailViewController.h"
@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *NoticTableView;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)UIButton *rightButton;
@property (nonatomic, strong) UIVisualEffectView *maoboliView;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self creatUI];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_细线.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    
    [self iOS8blurAction];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_rightButton setBackgroundImage:[[UIImage imageNamed:@"提示页面关闭"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    
    self.navigationItem.leftBarButtonItem = nil;
    
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
    
    self.titleLabel.text = @"使用提示";
    self.titleLabel.textColor = ZhuYao;
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];

    

    _NoticTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_NoticTableView];
    _NoticTableView.delegate = self;
    _NoticTableView.dataSource = self;
    _NoticTableView.showsVerticalScrollIndicator = NO;
    _NoticTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataArr = [NoticeModel mj_objectArrayWithKeyValuesArray:[NoticeModel copyNoticeArr]];
    
    
    //右上角关闭按钮
    UIImage *NormImage = [[UIImage imageNamed:@"提示页面关闭"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 44,0,44,44)];
    [_rightButton setBackgroundImage:NormImage forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_rightButton];
    
    
}
-(void)backPage
{
   [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
    if (!cell)
    {
        cell = [[NoticTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoticeCell"];
    }
    
    NoticeModel *model = _dataArr[indexPath.row];
    cell.model = model;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_rightButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    NoticeModel *model = _dataArr[indexPath.row];
    VideoDetailViewController *videoVc = [VideoDetailViewController new];
    videoVc.VideoName = model.name;
    videoVc.VideoUrl = model.videoUrl;
    videoVc.VideoDetail = model.videoDetail;
    videoVc.videoId = indexPath.row;
    [self.navigationController pushViewController:videoVc animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

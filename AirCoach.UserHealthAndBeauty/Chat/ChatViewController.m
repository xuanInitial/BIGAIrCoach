//
//  ChatViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "ChatViewController.h"
#import "NTESSessionViewController.h"
#import "CTPersonTableViewCell.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *chatTableview;
@end

@implementation ChatViewController
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    //显示
//    [self.tabBarController.tabBar showBadgeOnItemIndex:1];
     [TalkingData trackPageBegin:@"聊天页面"];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     //隐藏
//      [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
     [TalkingData trackPageEnd:@"聊天页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    // Do any additional setup after loading the view.
 
 
  
   
    
    
    [self cueateUI];
}

- (void)cueateUI{
    
    _chatTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    _chatTableview.delegate = self;
    _chatTableview.dataSource = self;
    _chatTableview.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.view addSubview:_chatTableview];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTPersonTableViewCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CTPersonTableViewCell" owner:self options:nil]firstObject];
    }
    UIColor* color=[[UIColor alloc]initWithRed:1.0 green:1.0 blue:1.0 alpha:1];//通过RGB来定义颜色
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = color;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self onEnterMyComputer];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREENWIDTH, 35)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    //headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:118/255.0f green:118/255.0f blue:118/255.0f alpha:1];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.frame = CGRectMake(15, 10, 300.0, 14);
    
   
    headerLabel.text = @"与护理师的聊天";
    customView.backgroundColor =  [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
   
    [customView addSubview:headerLabel];
    
    
  
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

#pragma mark - Action
- (void)onEnterMyComputer{
    NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];

   // NIMSession *session = [NIMSession session:@"custom_14_577a1ed688c3e" type:NIMSessionTypeP2P];

    NIMSession *session = [NIMSession session:@"custom_21_5779d871b396c" type:NIMSessionTypeP2P];

    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
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

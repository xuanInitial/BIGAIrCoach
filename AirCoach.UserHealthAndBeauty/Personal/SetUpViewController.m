//
//  SetUpViewController.m
//  AirCoach.acUser
//
//  Created by xuan on 15/11/24.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "SetUpViewController.h"

#import "AboutViewController.h"
#import "BusinessAirCoach.h"

#import "StartViewController.h"

#import "PlanList.h"

#import "AppDelegate.h"
@interface SetUpViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIGestureRecognizerDelegate,AlertControllerDZDelegate>
{
    AlertControllerDZ *alertView;
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *itemArray;

@property (nonatomic, strong) NSArray *playList; //播放列表

@property (nonatomic, strong) NSMutableArray *planIdPathArray;

@property (nonatomic) long long planIdPathfolderSize;

@property (nonatomic) float planOfSize;
@end


@implementation SetUpViewController


- (NSMutableArray *)planIdPathArray{
    
    if (!_planIdPathArray) {
        
        _planIdPathArray = [[NSMutableArray alloc] init];
    }
    return _planIdPathArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
    //准备推出页面时显示导航栏
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    //设置电池条为黑色
    self.navigationController.navigationBar.barStyle = 0;
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏_底图.png"] forBarMetrics:UIBarMetricsDefault];
    
    
     [TalkingData trackPageBegin:@"设置页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

   
     [TalkingData trackPageEnd:@"设置页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.titleLabel.text = @"设置";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textColor = ZhuYao;
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    
     self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0f];
    _planIdPathfolderSize = 0;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    self.itemArray  =[NSMutableArray array];
    
    [self.itemArray addObject:[NSArray arrayWithObjects:@"关于",@"退出此账号",@"语音控制开始",nil]];
    
     self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    //添加轻扫手势
    UIScreenEdgePanGestureRecognizer *swipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture)];
    //设置轻扫的方向
    swipeGesture.edges = MASAttributeLeft; //默认向右
    [self.view addGestureRecognizer:swipeGesture];
}

-(void)swipeGesture
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ||indexPath.row == 1)
    {
       return 45;
    }
    else
    {
        if ([WYTDevicesTool iPhone4_iPhone4s]||[WYTDevicesTool iPhone5_iPhone5s_iPhone5c])
        {
            return 135;
        }
        else
        {
            return 120;
        }

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 13;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = @"setup";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.tag = indexPath.row;
    
    
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor colorWithRed:66/255.0f green:66/255.0f blue:66/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右箭头
        cell.textLabel.text = _itemArray[indexPath.section][indexPath.row];
    }
    else
    {
        CGFloat leftJuli;
        if ([WYTDevicesTool iPhone4_iPhone4s]||[WYTDevicesTool iPhone5_iPhone5s_iPhone5c])
        {
            leftJuli = 15;
        }
        else if([WYTDevicesTool iPhone6_iPhone6s])
        {
            leftJuli = 15;
        }
        else
        {
           leftJuli = 19;
        }
        UILabel *ItemExplor = [UILabel new];
        [cell.contentView addSubview:ItemExplor];
        [ItemExplor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(leftJuli);
            make.width.equalTo(@100);
            make.height.greaterThanOrEqualTo(@16);
            make.top.equalTo(cell.contentView.mas_top).offset(15);
        }];
        ItemExplor.text = @"语音控制开始";
        ItemExplor.textColor =[UIColor colorWithRed:66/255.0f green:66/255.0f blue:66/255.0f alpha:1.0f];
        ItemExplor.font = [UIFont systemFontOfSize:16];

        UISwitch* mySwitch = [[ UISwitch alloc]initWithFrame:CGRectMake(SCREENWIDTH - 60,8,0,0)];
       [cell.contentView addSubview:mySwitch];
        NSDictionary *dic = [BusinessAirCoach getUserUseAudio];
        if (dic == nil || [dic[@"isAudio"] isEqualToString:@"YesAudio"]) {
            [mySwitch setOn:YES];
        }
        else
        {
            [mySwitch setOn:NO];
        }
        [mySwitch addTarget:self action:@selector(swicthChange:) forControlEvents:UIControlEventValueChanged];
        
        //解释文字
        UILabel *explor = [UILabel new];
        [cell.contentView addSubview:explor];
        [explor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(leftJuli);
            make.right.equalTo(cell.contentView.mas_right).offset(-40);
            make.top.equalTo(mySwitch.mas_bottom).offset(15);
            make.height.greaterThanOrEqualTo(@12);
        }];
        
        explor.text = @"在播放训练视频前，您可以先做好准备姿势，然后对手机说出“开始”，训练视频即可自动播放（需要将设备连网）。";
        explor.textColor = LableColor;
        explor.numberOfLines = 0;
        explor.font = [UIFont systemFontOfSize:12];
        NSMutableAttributedString *str = [self TheLabletext:explor.text];
        explor.attributedText = str;
        [explor sizeToFit];
        
        UILabel *Xunfei = [UILabel new];
        [cell.contentView addSubview:Xunfei];
        [Xunfei mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(leftJuli);
            make.right.equalTo(cell.contentView.mas_right).offset(-40);
            make.top.equalTo(explor.mas_bottom).offset(6);
            make.height.equalTo(@12);
        }];
        
        Xunfei.text = @"*语音技术由科大讯飞提供";
        Xunfei.textColor = [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0];
        Xunfei.font = [UIFont systemFontOfSize:12];
        
    }
    
    return cell;
    
    
}
//控制器开关
-(void)swicthChange:(UISwitch*)sender
{
    if (sender.on == YES)
    {
        NSDictionary *dic = @{@"isAudio":@"YesAudio"};
        [BusinessAirCoach setUserCanUseAudio:dic];

    }
    else
    {
        NSDictionary *dic = @{@"isAudio":@"NoAudio"};
        [BusinessAirCoach setUserCanUseAudio:dic];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
      float number;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            AboutViewController *about = [[AboutViewController  alloc] init];
            about.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:about  animated:YES];
          
        } else if (indexPath.row == 1) {
            alertView = [[AlertControllerDZ alloc]initWithFrame:self.view.bounds WithTitle:@"确定退出登录" andDetail:nil  andCancelTitle:@"取消" andOtherTitle:@"确定"  andFloat:104 BtnNum:@"Two" location:NSTextAlignmentCenter];
            alertView.detailLabel.textColor = [UIColor blackColor];
            alertView.tag = 4;
            alertView.delegate = self;
            [[UIApplication sharedApplication].keyWindow addSubview:alertView];
           
            [TalkingData trackEvent:@"我设置页面_退出登录"];

        }else{
            
        }

        
        
    }else if (indexPath.section == 1){
        
    }else {
        
    }
}


-(void)clickButtonWithTag:(UIButton *)button
{
    switch (alertView.tag) {
        case 3:
        {
            if (button.tag == 308) {
                LRLog(@"取消");
            } else {
                LRLog(@"确定");
                
               
            }
        }
            break;
        case 4:
        {
            if (button.tag == 308) {
                
            } else {
                LRLog(@"退出登录");
                
                
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                //清理NSuserDefault的键值
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                
                NSString *path = [[paths lastObject] stringByAppendingPathComponent:@"Preferences"];
                
                NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
                 for (NSString *p in files) {
                     NSError *error;
                     NSString *Path = [path stringByAppendingPathComponent:p];
                     
                     if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                     
                     [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
                      
                         [SVProgressHUD dismiss];
                     }
                     
                 }
                [BusinessAirCoach setTrainShuaxuinTime:nil];
                [BusinessAirCoach setUserAuthorization:nil];
                
                [BusinessAirCoach setyunxinAcc:nil];
                [BusinessAirCoach setyunxinToken:nil];
                //云信登出
                [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error){}];
                
                StartViewController *loginVC = [StartViewController new];
                
                AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegete.window.rootViewController = loginVC;
                [self presentViewController:delegete.window.rootViewController animated:YES completion:^{
                    
                }];
                
            }
        }
            break;
        
        default:
            break;
    }
    
    
    
}
//行距设置
-(NSMutableAttributedString*)TheLabletext:(NSString*)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;  //行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
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

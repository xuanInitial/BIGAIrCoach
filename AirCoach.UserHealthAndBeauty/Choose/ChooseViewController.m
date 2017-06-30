//
//  ChooseViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "ChooseViewController.h"
#import "ChooseDetailsViewController.h"
@interface ChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *chooseTableView;
@end

@implementation ChooseViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    [TalkingData trackPageBegin:@"选购tab页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [TalkingData trackPageEnd:@"选购tab页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [self createUI];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0f];
    
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH-260)/2, SCREENHEIGHT/5, 260, 260)];
    
    img.image = [UIImage imageNamed:@"商城"];
    
    [self.view addSubview:img];
    
    
}
- (void)createUI{
    _chooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    _chooseTableView.delegate = self;
    _chooseTableView.dataSource = self;
    _chooseTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.view addSubview:_chooseTableView];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"123"];
    }
    if (indexPath.row == 0) {
       cell.textLabel.text = @"光合康复师 额外线下服务*1";
    }
    cell.textLabel.text = @"光合康复师 延长服务3个月";
    cell.backgroundColor = [UIColor greenColor];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor blueColor];
    }
    return cell;
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击； 选购cell");
    ChooseDetailsViewController *chooseDetailsVC = [[ChooseDetailsViewController alloc] init];
    chooseDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chooseDetailsVC animated:YES];
    
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

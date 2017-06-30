//
//  DownLineViewController.m
//  Orderdemo
//
//  Created by wei on 16/5/26.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "DownLineViewController.h"
#import "detailHeader.h"
#import "ResultTableViewCell.h"
@interface DownLineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@end

@implementation DownLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    detailHeader *headerView = [[detailHeader alloc]initWithFrame:CGRectMake(0, 20, 320, 150)];
    headerView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    UIButton *btn = [headerView viewWithTag:1000];
    [btn addTarget:self action:@selector(dimissmyself) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:headerView];
    
    
    [self creatUI];
    
    
    
    
}
-(void)creatUI
{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 170, 320, self.view.frame.size.height + 20) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ResultTableViewCell" owner:self options:nil]firstObject];
    }
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"项目1";
}

-(void)dimissmyself
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

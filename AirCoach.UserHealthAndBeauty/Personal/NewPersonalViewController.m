//
//  NewPersonalViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/7/18.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "NewPersonalViewController.h"

#import "SetUpViewController.h"
#import "MyProgress.h"
#import "InformationViewController.h"
#import "ChartViewController.h"
#import "UIImageView+WebCache.h"
#import "PersonalModel.h"

#import "cbsNetWork.h"
#import "MyAttributedStringBuilder.h"
#import "StartViewController.h"

#import "MyCollecCollectionViewCell.h"

@interface NewPersonalViewController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    UIView *_headerView;//头视图
    //下拉放大底图
    //    UIImageView *_backImageView;
    //上拉置顶底图
    UIImageView *_titleImageView;
    UILabel     *_titlelabel;//标题
    int hotPage;//动态的页数
    int collectPage;//收藏的页数
    
    UIView *_dontDataView;//没有数据的View
    
    AlertControllerDZ *alertView;
}
//网格视图
@property (strong, nonatomic) UICollectionView *MyCollectionView;


@property (nonatomic, strong)PersonalModel *personalModel;

@property (strong, nonatomic) UIImageView *iconImage;

@property (strong, nonatomic) UIImageView *headerImageView;
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIView *zhezhaoview;
@property(nonatomic,strong)UILabel *titleText;

@property(nonatomic,strong)UIImageView *MyheaderView;
@property (strong, nonatomic) UIButton *ChoiceBtn;
@end

@implementation NewPersonalViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //准备进入页面时隐藏导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_细线.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
  
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //准备推出页面时显示导航栏
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏_底图.png"] forBarMetrics:UIBarMetricsDefault];
    self.hidesBottomBarWhenPushed = NO;
    

}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0f];
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置"] style:UIBarButtonItemStylePlain target:self action:@selector(shopButtonClick)];
    backbutton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = backbutton;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RequstAllready" object:nil];
    }
    

    [self.view addSubview:self.MyCollectionView];//网格视图
    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    _titleImageView.image = [UIImage imageNamed:@""];
    _titleImageView.hidden = YES;
    [self.view addSubview:_titleImageView];
}

#pragma mark --- set网格视图
- (UICollectionView *)MyCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    if (!_MyCollectionView) {
        _MyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREENWIDTH,SCREENHEIGHT) collectionViewLayout:layout];
    }
    
    _MyCollectionView.backgroundColor = [UIColor clearColor];
    _MyCollectionView.dataSource = self;
    _MyCollectionView.delegate = self;
    _MyCollectionView.alwaysBounceVertical = YES;
    _MyCollectionView.showsVerticalScrollIndicator = NO;
    _MyCollectionView.contentInset=UIEdgeInsetsMake(218*WIDTHBASE, 0, 49, 0);
    [_MyCollectionView registerClass:[MyCollecCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self myTableViewHeadView];
    
    return _MyCollectionView;
    
}


- (void)myTableViewHeadView{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -218, SCREENWIDTH, 218)];
    _headerView.backgroundColor = [[UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1] colorWithAlphaComponent:0];
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 218)];
    }
    // _headerImageView.image = [UIImage imageNamed:@"背景图q"];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_personalModel.figure] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    [_headerView addSubview:_headerImageView];
    
    //高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    if (_effectView == nil)
    {
        _effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
        _effectView.frame = CGRectMake(0, 0, SCREENWIDTH, 218);
    }
    _effectView.alpha = 1.0;
    
    [_headerView addSubview:_effectView];
    //遮罩
    if (_zhezhaoview == nil)
    {
        _zhezhaoview = [[UIView alloc]init];
        _zhezhaoview.frame = CGRectMake(0, 0, SCREENWIDTH, 218);
    }
    
    
    _zhezhaoview.backgroundColor = [UIColor blackColor];
    _zhezhaoview.alpha = 0.40;
    [_headerView addSubview:_zhezhaoview];
    
    if (_titlelabel == nil)
    {
        _titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 44)];
        _titleText.textColor=[UIColor whiteColor];
        _titleText.textAlignment = NSTextAlignmentCenter;
        [_titleText setFont:[UIFont systemFontOfSize:17.0]];
        [_titleText setText: [NSString stringWithFormat:@""]];
        self.navigationItem.titleView=_titleText;
    }
    [_titleText setText: [NSString stringWithFormat:@"%@",_personalModel.name]];
    //titleText.backgroundColor = [UIColor redColor];
    
    
    
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-37, 74, 74, 74)];
    }
    if (!_MyheaderView) {
        _MyheaderView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-37, 74, 74, 74)];
    }
    //头像
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = 37;
    _iconImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_personalModel.figure] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    //一定要加这句
    _iconImage.clipsToBounds = YES;
    [_MyheaderView sd_setImageWithURL:[NSURL URLWithString:_personalModel.figure] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    [_headerView addSubview:_iconImage];
    
    //头像写本地
//    NSData *data = UIImageJPEGRepresentation(_iconImage.image,0.5);
//    
//    NSInteger i = arc4random()%10000 + 1;
    
    
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.frame = _iconImage.frame;
    iconButton.backgroundColor = [UIColor clearColor];
    
    [iconButton addTarget:self action:@selector(iconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:iconButton];
    
   
    
    
    if (!_ChoiceBtn) {
        _ChoiceBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-90*WIDTHBASE)/2,_iconImage.frame.origin.y+_iconImage.frame.size.height+10 , 90*WIDTHBASE, 30*WIDTHBASE)];
    }
    [_ChoiceBtn setTitle:@"个人资料" forState:UIControlStateNormal];
    
    [_ChoiceBtn addTarget:self action:@selector(ChoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_ChoiceBtn setBackgroundImage:[UIImage imageNamed:@"个人资料"] forState:UIControlStateNormal];
    [_headerView addSubview:_ChoiceBtn];
    
    
    [self.MyCollectionView addSubview:_headerView];
    
}


- (void)shopButtonClick{
    NSLog(@"点击了设置按钮");
    SetUpViewController *setUp = [[SetUpViewController alloc] init];
    setUp.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:setUp animated:YES];
    
}

- (void)ChoiceBtnClick:(UIButton *)sender
{
    
    
    NSLog(@"点击了个人资料");
    InformationViewController *information = [[InformationViewController alloc] init];
    information.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:information animated:YES];
    
}
-(void)iconButtonClick:(UIButton *)sender {
    
    
    NSLog(@"点击头像");
    
    
    InformationViewController *information = [[InformationViewController alloc] init];
    information.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:information animated:YES];
    
    
    
}



#pragma mark - 下拉放大和上拉置顶效果

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_MyCollectionView.contentOffset.y > -272*WIDTHBASE) {//上拉刷新
       
        _headerImageView.hidden = NO;
        _headerView.backgroundColor = [[UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1] colorWithAlphaComponent:1];
    }else{//下拉放大
        
        _headerImageView.hidden = YES;
        _headerView.backgroundColor = [[UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1] colorWithAlphaComponent:0];
       
    }
    
    if (_MyCollectionView.contentOffset.y > -64-48*WIDTHBASE) {//上拉的顶部图片是否显示
        _titleImageView.hidden = NO;
        
    }else{
        _titleImageView.hidden = YES;
        self.title = @"";
       
    }
}

- (void)loadData{
    
    [[HttpsRefreshNetworking  Networking] GET:CUSTOM parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        
        NSLog(@"%@",responseObject);
        _personalModel = [PersonalModel mj_objectWithKeyValues:responseObject];
        
        [self.MyCollectionView reloadData];
        [BusinessAirCoach setNickName:_personalModel.name];
        [BusinessAirCoach setHeadPortrait:_personalModel.figure];
       
    } failure:^(NSDictionary *allHeaders,NSError *error,id statusCode) {
        
        
        if ([statusCode isEqualToString:@"401"]) {
            
            [self.navigationController pushViewController:[StartViewController new] animated:YES];
            
        }else{
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
        }
        NSLog(@"%@",error);
    }];
    
}




#pragma mark - UICollectionView delegate dataSource
#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    MyCollecCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    
    cell.imageView.image = [UIImage imageNamed:@"暂无图片"];
    cell.machLabel.text = [NSString stringWithFormat:@"Cell %ld",indexPath.item];
    //按钮事件就不实现了……
    return cell;
}



#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择%ld",indexPath.item);
}



#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){100,100};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){50,44};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){100,22};
}

@end

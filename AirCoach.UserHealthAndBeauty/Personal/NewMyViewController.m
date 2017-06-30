//
//  NewMyViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/7/18.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "NewMyViewController.h"

#import "SetUpViewController.h"
#import "MyProgress.h"

#import "ChartViewController.h"
#import "UIImageView+WebCache.h"
#import "PersonalModel.h"

#import "cbsNetWork.h"
#import "MyAttributedStringBuilder.h"
#import "StartViewController.h"

#import "MyCollecCollectionViewCell.h"

#import "ChartViewController.h"
#import "MyPlanViewController.h"
#import "PlanList.h"
#import "NoticeViewController.h"


#define HeadViewHight  239
@interface NewMyViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AlertControllerDZDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIView *_headerView;//头视图
 
    UIImageView *_titleImageView;
  
    
    UIView *_dontDataView;//没有数据的View
    
    AlertControllerDZ *alertView;
}
@property(nonatomic,strong)NSString *figureStr;
@property(nonatomic,strong)UIImagePickerController *imagePicker;
//网格视图
@property (strong, nonatomic) UICollectionView *MyCollectionView;


@property (nonatomic, strong)PersonalModel *personalModel;

@property (strong, nonatomic) UIImageView *BigIconImage;
@property (strong, nonatomic) UIImageView *iconImage;



@property (strong, nonatomic) UIImageView *headerImageView;
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIView *zhezhaoview;
@property(nonatomic,strong)UILabel *titleText;

@property (nonatomic, strong) UITextField *nameTextField;


@property (strong, nonatomic) NSMutableArray *nameArray;

@property (nonatomic ,strong) NSMutableArray *imageArray;


@property (nonatomic ,strong) UIImageView *zhezhaoImage;
@property (nonatomic, strong) UILabel *shiyongtiaoshu;
@property (nonatomic, strong) UILabel *shiyongwenzi;

@property (nonatomic, strong) UILabel *shangmentijianNum;
@property (nonatomic, strong) UILabel *shangmentijianwenzi;

@property (nonatomic, strong) UIView *fengexianView;
@property (nonatomic, strong) UIButton *editImageView;


@property (nonatomic, strong) NSArray *playList; //播放列表
@property (nonatomic, strong) NSMutableArray *planIdPathArray;

@property (nonatomic) long long planIdPathfolderSize;

@property (nonatomic) float planOfSize;

@property(nonatomic,strong)NSData *MyresponseObject;
@end

@implementation NewMyViewController
-(NSMutableArray *)planIdPathArray
{
    if (!_planIdPathArray)
    {
        _planIdPathArray = [NSMutableArray array];
    }
    return _planIdPathArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //准备进入页面时隐藏导航栏
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_细线.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //设置电池条为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [TalkingData trackPageBegin:@"我tab页面"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
     [self.planIdPathArray removeAllObjects];
     [TalkingData trackPageEnd:@"我tab页面"];

}


- (NSMutableArray *)nameArray{
    
    if (!_nameArray) {
        _nameArray = [[NSMutableArray alloc ] init];
        
        [_nameArray addObjectsFromArray:[NSArray arrayWithObjects:@"我的训练规划",@"身体检测报告",@"清除缓存",@"暂停服务",@"提示", nil]];
    }
    
    return _nameArray;
}

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
        [_imageArray addObjectsFromArray:[NSArray arrayWithObjects:@"总计划表",@"身体检测报告",@"清除缓存",@"暂停服务",@"我提示", nil]];
    }
    
    return _imageArray;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
  //  _imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
  //  _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0f];
//    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置"] style:UIBarButtonItemStylePlain target:self action:@selector(shopButtonClick)];
//    backbutton.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = backbutton;
    

    
    
    _planIdPathfolderSize = 0;
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
    
    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    _titleImageView.image = [UIImage imageNamed:@""];
    _titleImageView.hidden = YES;
    [self.view addSubview:_titleImageView];
    
    [self.view addSubview:self.MyCollectionView];//网格视图
   
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
}
-(void)keyboardWillShow:(NSNotification*)sender
{
   NSDictionary* userInfo = [sender userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    self.MyCollectionView.y = -(keyboardFrame.size.height - 70);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [UIView commitAnimations];

}
-(void)keyboardWillHide:(NSNotification*)sender
{
    self.MyCollectionView.y = 0;
}
#pragma mark --- set网格视图
- (UICollectionView *)MyCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    if (!_MyCollectionView) {
        _MyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, HeadViewHight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-HeadViewHight-49) collectionViewLayout:layout];
        _MyCollectionView.backgroundColor = [UIColor clearColor];
        _MyCollectionView.dataSource = self;
        _MyCollectionView.delegate = self;
        _MyCollectionView.bounces = YES;
        _MyCollectionView.alwaysBounceVertical = YES;
        _MyCollectionView.showsVerticalScrollIndicator = NO;
       
        [_MyCollectionView registerClass:[MyCollecCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
    
        
    }
    
    [self myTableViewHeadView];
    
    
    return _MyCollectionView;
    
}

#pragma mark --- HeadView
- (void)myTableViewHeadView{
    
    if (_headerView == nil)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HeadViewHight)];
        _headerView.backgroundColor = [[UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1] colorWithAlphaComponent:0];
 
    }
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HeadViewHight)];
        _headerImageView.image = [UIImage imageNamed:@"头像-背景图"];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
        [_headerView addSubview:_headerImageView];
        _headerImageView.userInteractionEnabled = YES;
        
        UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        backbutton.frame = CGRectMake(SCREENWIDTH - 50,26,60, 60);
        [backbutton addTarget:self action:@selector(shopButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerImageView addSubview:backbutton];
        
        
        //返回图标
        UIImageView *DoctorIM = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 50,26, 28, 28)];
        DoctorIM.image = [UIImage imageNamed:@"设置"];
        [_headerImageView addSubview:DoctorIM];
        
        backbutton.center = DoctorIM.center;
        

    }
   
    
    
    if (_titleText == nil)
    {
        _titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 44)];
        _titleText.textColor=[UIColor whiteColor];
        _titleText.textAlignment = NSTextAlignmentCenter;
        [_titleText setFont:[UIFont systemFontOfSize:17.0]];
        [_titleText setText: @""];
        self.navigationItem.titleView=_titleText;
    }
    [_titleText setText: @""];
    
    
    if (!_BigIconImage) {
        _BigIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-41, 61, 82, 82)];
        _BigIconImage.layer.masksToBounds = YES;
        _BigIconImage.layer.cornerRadius = 41;
        _BigIconImage.layer.opacity = 0.5;
        _BigIconImage.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [_headerView addSubview:_BigIconImage];
    }
    
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-38, 64, 76, 76)];
        //头像
        _iconImage.layer.masksToBounds = YES;
        _iconImage.layer.cornerRadius = 38;
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        //一定要加这句
        _iconImage.clipsToBounds = YES;
        _iconImage.userInteractionEnabled = YES;
        [_headerView addSubview:_iconImage];

    }

    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[BusinessAirCoach getHeadPortrait]] placeholderImage:[UIImage imageNamed:@"用户-默认头像"]];
    
    
    
    if (_nameTextField == nil)
    {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.textColor=[UIColor whiteColor];
        _nameTextField.textAlignment = UITextAlignmentCenter;
        [_nameTextField setFont:[UIFont boldSystemFontOfSize:18.0f]];
        
        _nameTextField.delegate = self;
        _nameTextField.userInteractionEnabled = NO;
        [_headerView addSubview:_nameTextField];
        //greaterThanOrEqualTo  设置最小值 然后根据文字多少自适应
        [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_iconImage.mas_centerX);
            make.top.equalTo(_BigIconImage.mas_bottom).offset(10);
            make.height.equalTo(@18);
            make.width.greaterThanOrEqualTo(@60);
            
        }];
        
    }
   [_nameTextField setText: [BusinessAirCoach getNickName]];
 
    _nameTextField.keyboardType = UIKeyboardAppearanceDefault;
    _nameTextField.returnKeyType = UIReturnKeyDone;
    
    
    
    if (!_editImageView) {
        _editImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView addSubview:_editImageView];
        [_editImageView setBackgroundImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        [_editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nameTextField.mas_centerY);
            make.left.equalTo(_nameTextField.mas_right).offset(0);
            make.height.equalTo(@25);
            make.width.equalTo(@25);
        }];

    }
    
    [_editImageView addTarget:self action:@selector(postUserName) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.frame = _iconImage.frame;
    iconButton.backgroundColor = [UIColor clearColor];
    
    [iconButton addTarget:self action:@selector(iconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:iconButton];
    
    
    if (!_zhezhaoImage) {
        _zhezhaoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, HeadViewHight-55, SCREENWIDTH, 55)];
        _zhezhaoImage.image = [UIImage imageNamed:@"高斯模糊"];
    }
    
    [_headerView addSubview:_zhezhaoImage];
    if (!_shiyongtiaoshu) {
        _shiyongtiaoshu = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREENWIDTH/2, 17)];
        [_shiyongtiaoshu setFont:[UIFont systemFontOfSize:17]];
        _shiyongtiaoshu.textColor=[UIColor whiteColor];
        _shiyongtiaoshu.textAlignment = NSTextAlignmentCenter;
        _shiyongtiaoshu.text = @"0/180";
    }
    _shiyongtiaoshu.text = [BusinessAirCoach getUseDays];
    
    [_zhezhaoImage addSubview:_shiyongtiaoshu];
    
    if (!_shiyongwenzi) {
        _shiyongwenzi = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH/2, 12)];
        [_shiyongwenzi setFont:[UIFont systemFontOfSize:12]];
        _shiyongwenzi.textColor=[UIColor whiteColor];
        _shiyongwenzi.textAlignment = NSTextAlignmentCenter;
        _shiyongwenzi.text = @"使用天数";
    }
    [_zhezhaoImage addSubview:_shiyongwenzi];
    
    
    if (!_shangmentijianNum) {
        _shangmentijianNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2, 12, SCREENWIDTH/2, 17)];
        [_shangmentijianNum setFont:[UIFont systemFontOfSize:12]];
        _shangmentijianNum.textColor=[UIColor whiteColor];
        _shangmentijianNum.textAlignment = NSTextAlignmentCenter;
    }
    _shangmentijianNum.text = [NSString stringWithFormat:@"请咨询护理师"];
    
    [_zhezhaoImage addSubview:_shangmentijianNum];
    
    if (!_shangmentijianwenzi) {
        _shangmentijianwenzi = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2, 35, SCREENWIDTH/2, 12)];
        [_shangmentijianwenzi setFont:[UIFont systemFontOfSize:12]];
        _shangmentijianwenzi.textColor=[UIColor whiteColor];
        _shangmentijianwenzi.textAlignment = NSTextAlignmentCenter;
        _shangmentijianwenzi.text = @"光合体检次数";
    }
    [_zhezhaoImage addSubview:_shangmentijianwenzi];
    
    
    
    if (!_fengexianView) {
        _fengexianView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2, 15, 1, 25)];
        _fengexianView.backgroundColor = [UIColor colorWithRed:125/255.0f green:129/255.0f blue:147/255.0f alpha:1.0f];
    }
    
    [_zhezhaoImage addSubview:_fengexianView];
    
    
    
    
    [self.view addSubview:_headerView];
    
}
-(void)postUserName
{
    _nameTextField.userInteractionEnabled = YES;
    [_nameTextField becomeFirstResponder];
    
}

- (void)shopButtonClick{
    LRLog(@"点击了设置按钮");
    SetUpViewController *setUp = [[SetUpViewController alloc] init];
    setUp.hidesBottomBarWhenPushed = YES;
     self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:setUp animated:YES];
    
}

#pragma mark---点击了头像
-(void)iconButtonClick:(UIButton *)sender {
    
    [TalkingData trackEvent:@"我tab页面_点击了头像"];


    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择上传图片的方式"
                                                                             message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        // 判断是否支持相机
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            UIAlertAction *CameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self camera];
            }];
            UIAlertAction *PicAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self photo];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:CameraAction];
            [alertController addAction:PicAction];
            [alertController addAction:cancelAction];
            
            [CameraAction setValue:ZhuYao forKey:@"titleTextColor"];
            [PicAction setValue:ZhuYao forKey:@"titleTextColor"];
            [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else {
            UIAlertAction *PicAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self photo];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:PicAction];
            [alertController addAction:cancelAction];
            
            [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
            [PicAction setValue:ZhuYao forKey:@"titleTextColor"];
        }
    
    
    
}


/*
 *相机
 */
- (void)camera {
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_imagePicker animated:YES completion:^{
    }];
    
}
/*
 *相册
 */
- (void)photo {
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePicker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//把图片保存到本地相册
    }
    _iconImage.image = image;
    
    //上传阿里云
    //_data = UIImagePNGRepresentation(image);
    [self sendDynamicClick];
    [picker dismissViewControllerAnimated:NO completion:^{
        /******************************/
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendDynamicClick
{
    //
    NSString *token = [TokenGet getTwoMinutesOfToken];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    //上传图片到阿里云
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGSize SIZE = CGSizeMake(450, 600);
        CGSize actualScaledSize = CGSizeMake(0, 0);
        
        UIImage *image = _iconImage.image;
        //横向图片
        if (image.size.height > image.size.width)
        {
            actualScaledSize.height = MIN(image.size.height, SIZE.height);
            actualScaledSize.width = image.size.width *(actualScaledSize.height / image.size.height);
        }
        else
        {
            //纵向图片
            actualScaledSize.width = MIN(image.size.width, SIZE.width);
            actualScaledSize.height = image.size.height *(actualScaledSize.width / image.size.width);
        }
        
        UIImage *Myimage = [BusinessAirCoach imageWithImageSimple:image scaledToSize:actualScaledSize];
        
        NSData *Mydata = UIImageJPEGRepresentation(Myimage, 0.5);
        
        
        UIImage *enImage = [UIImage imageWithData:Mydata];
        
        
        
        NSString *tel =[BusinessAirCoach getTel];
        NSInteger num = arc4random() % 100000;
        
        
        _figureStr = nil;
       
        [CTAirCoachOss addPic:enImage PicName:[NSString stringWithFormat:@"%@%ld",tel,(long)num]];
            _figureStr = [NSString stringWithFormat:@"http://image-test.aircoach.cn/image/UserHead%@%@.jpg",tel,[NSString stringWithFormat:@"%ld",(long)num]];
        
        [self postUserInformation:@"Head"];
        
        [BusinessAirCoach setHeadPortrait:_figureStr];
        
        
    });
    
}
- (void)postUserInformation:(NSString*)NameOrHead{
    
    NSDictionary *paramet = nil;
    if ([NameOrHead isEqualToString:@"Head"])
    {
        if (_figureStr != nil)
        {
            paramet= @{@"figure":_figureStr};
        }
        
    }
    else
    {
        if (_nameTextField.text.length != 0)
        {
            paramet= @{@"nickname":_nameTextField.text};
        }
    }
    
    
    
    LRLog(@"%@",paramet);
    [[HttpsRefreshNetworking Networking] POST:CUSTOM parameters:paramet success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        LRLog(@"%@",responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [BusinessAirCoach setNickName:_nameTextField.text];
            //[self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
        LRLog(@"%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        NSString *str = nil;
        if ([NameOrHead isEqualToString:@"Head"])
        {
            str = @"修改头像失败,请重试";
        }
        else
        {
            str = @"修改用户名失败,请重试";
        }

        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:str];
        [[UIApplication sharedApplication].keyWindow addSubview:prom];

    }];
    
}


#pragma mark - 下拉放大和上拉置顶效果

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
  
}

- (void)loadData{
    
    [[HttpsRefreshNetworking  Networking] GET:CUSTOM parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        
        LRLog(@"%@",responseObject);
        _personalModel = [PersonalModel mj_objectWithKeyValues:responseObject];
        
        [BusinessAirCoach setNickName:_personalModel.nickname];
        [BusinessAirCoach setHeadPortrait:_personalModel.figure];
        [BusinessAirCoach setUseDays:[NSString stringWithFormat:@"%ld / %ld",(long)_personalModel.usage,(long)_personalModel.length]];
        [self.MyCollectionView reloadData];
    } failure:^(NSDictionary *allHeaders,NSError *error,id statusCode) {
        
        
        if ([statusCode isEqualToString:@"401"]) {
            
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




#pragma mark - UICollectionView delegate dataSource
#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
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
  
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[indexPath.row]]];
    cell.machLabel.text = [NSString stringWithFormat:@"%@",self.nameArray[indexPath.row]];
  
    return cell;
}



#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.item) {
        
            case 0:{
             [TalkingData trackEvent:@"我tab页面_功能区_点击了计划总表入口"];
            [self presentViewController:[MyPlanViewController new] animated:YES completion:nil];
        }
            
            break;
        case 1:{
            [TalkingData trackEvent:@"我tab页面_功能区_点击了身体检测报告入口"];
          AlertControllerDZ *alertViewBook = [[AlertControllerDZ alloc]initWithFrame:self.view.bounds WithTitle:nil andDetail:@"功能暂未开放，您可向您的护理师预约体检时间或索要体检报告。" andCancelTitle:nil andOtherTitle:@"确定" andFloat:66 BtnNum:@"One" location:NSTextAlignmentCenter];
            alertViewBook.detailLabel.textColor = [UIColor blackColor];
            [[UIApplication sharedApplication].keyWindow addSubview:alertViewBook];

        }
            
            break;
        case 2:
        {
            
            [self.planIdPathArray removeAllObjects];
            float number;
            
            
            //判断新老路径
            if ([self queryOldData:@"UserCourseList"].count != 0 )
            {
                //[self deleteData:@"UserCourseList" type:@"New"];//防止新路径下有东西 先删掉新路径下的
                if ([BusinessAirCoach getPlancurID] == nil)
                {
                    [self createSQLite:@"UserCourseList" planId:@"88888"];
                    [self insertData:_MyresponseObject addSqlName:@"UserCourseList" planId:@"88888"];//将老路径下的内容写入新路径
                }
                else
                {
                   [self createSQLite:@"UserCourseList" planId:[BusinessAirCoach getPlancurID]];
                   [self insertData:_MyresponseObject addSqlName:@"UserCourseList" planId:[BusinessAirCoach getPlancurID]];//将老路径下的内容写入新路径
                }
                
                [self deleteData:@"UserCourseList" type:@"old"];//老路径下的没用了删除
            }
            else
            {
                
            }
            
            if ([BusinessAirCoach getPlancurID] == nil)
            {
                if ([self queryData:@"UserCourseList" planId:@"8888"].count == 0 ) {
                    
                    PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"您当前没有缓存数据"];
                    [[UIApplication sharedApplication].keyWindow addSubview:prom];
                    return;
                } else {
                    
                    _planOfSize = [self CalculateTheSizeOfTheBindingPlan];
                    LRLog(@"%f",_planOfSize);
                }
 
            }
            else
            {
                if ([self queryData:@"UserCourseList" planId:[BusinessAirCoach getPlancurID]].count == 0 ) {
                    
                    PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"您当前没有缓存数据"];
                    [[UIApplication sharedApplication].keyWindow addSubview:prom];
                    return;
                } else {
                    
                    _planOfSize = [self CalculateTheSizeOfTheBindingPlan];
                    LRLog(@"%f",_planOfSize);
                }

            }
             
                 
            //计算caches中的文件大小
            float num = [self folderSizeAtPath:nil];
            
            LRLog(@"%f",num);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                     message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            
            if (num - _planOfSize <= 0) {
                number = 0;
            }else {
                number = num - _planOfSize;
            }
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"清除旧训练视频缓存（%0.2fM）",number] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *archivingPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                NSString *path = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserVideo",[BusinessAirCoach getTel]]];
                
                [self clearCache:path addArray:self.planIdPathArray.count];
                [self.MyCollectionView reloadData];
                
                
                [TalkingData trackEvent:@"我tab页面_功能区_点击了清除缓存_清除了旧计划缓存"];
            }];
            
            
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"清除全部缓存（%0.2fM）",num] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                
                NSString *archivingPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                NSString *path = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserVideo",[BusinessAirCoach getTel]]];

                
                NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
                
                for (NSString *p in files) {
                    
                    NSError *error;
                    
                    NSString *Path = [path stringByAppendingPathComponent:p];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            
                    [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
                    
                    [SVProgressHUD dismiss];
                    [self.MyCollectionView reloadData];
                    
                    }
                }
                [BusinessAirCoach setProgressBarToDownloadANumberOfLabels:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseDetailsViewController" object:nil];
                
                [TalkingData trackEvent:@"我tab页面_功能区_点击了清除缓存_清除了全部计划缓存"];

            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            //修改按钮颜色
            [defaultAction setValue:ZhuYao forKey:@"titleTextColor"];
            [destructiveAction setValue:ZhuYao forKey:@"titleTextColor"];
            [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
            
            
            
            [alertController addAction:defaultAction];
            [alertController addAction:destructiveAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 3:{
            
            alertView = [[AlertControllerDZ alloc]initWithFrame:self.view.bounds WithTitle:nil andDetail:@"您即将暂停光合塑形的服务。在您下次登录时，可以选择立即开启服务。"  andCancelTitle:@"取消" andOtherTitle:@"确定" andFloat:66 BtnNum:@"Two" location:NSTextAlignmentCenter];
            alertView.detailLabel.textColor = [UIColor blackColor];
            alertView.tag = 5;
            alertView.delegate = self;
            [[UIApplication sharedApplication].keyWindow addSubview:alertView];
            
              [TalkingData trackEvent:@"我tab页面_功能区_点击了暂停服务按钮"];
        }
            break;
        case 4:
        {
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[NoticeViewController new]];
            [self.navigationController presentViewController:navi animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


-(void)clickButtonWithTag:(UIButton *)button{
    
    if (button.tag == 308)
    {
        LRLog(@"传过来的是取消按钮");
    }
    if (button.tag == 309)
    {
        LRLog(@"确定");
        
        //判断token是否过期
        [BusinessAirCoach JugedToken];
        if ([[BusinessAirCoach getAlllabel] isEqualToString:@"CanUse"])
        {
            //token没过期 开始刷新
            [self pauseUser];
        }
        else
        {
          __weak typeof(self) weakSelf = self;
          __block __weak id gpsObserver;
         gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf pauseUser];
            [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
        }];

       }
        
        
        
        
    }
}
-(void)pauseUser
{
    
    [[cbsNetWork sharedManager] requestWithMethod:POST WithPath:CUSTOM_PAUSE WithParams:0 WithSuccessBlock:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        LRLog(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"finished"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authorization"];
            StartViewController *loginVC = [StartViewController new];
            
            AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            [self presentViewController:loginVC animated:YES completion:^{
                
                delegete.window.rootViewController = loginVC;
            }];            }
    } WithFailurBlock:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
        LRLog(@"%@%@%@",allHeaders,error,statusCode);
        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"暂停失败,请检测您的网络设置"];
        [[UIApplication sharedApplication].keyWindow addSubview:prom];
    }];
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(SCREENWIDTH-1.5)/3,97};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0.5, 0.5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5f;
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={SCREENWIDTH,10};
    return size;
}



#pragma mark---清除缓存相关
//创建表
- (void)createSQLite:(NSString *)sqlName planId:(NSString *)myid{
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@%@.sqlite",sqlName,[BusinessAirCoach getTel],myid] dbHandler:^(FMDatabase *nn_db) {
        NSString *cSql = @"CREATE TABLE IF NOT EXISTS OLD (id INTEGER PRIMARY KEY, UserID TEXT NOT NULL, UserCourseList TEXT NOT NULL)";
        BOOL res = [nn_db executeUpdate:cSql];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"succ to creating db table");
        }
    }];
}
//取数据
- (NSArray *)queryData:(NSString *)sqlName planId:(NSString *)myid{
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@%@.sqlite",sqlName,[BusinessAirCoach getTel],myid]  dbHandler:^(FMDatabase *nn_db) {
        NSString *qSql = @"SELECT * FROM OLD WHERE UserID = ?";
        FMResultSet *set = [nn_db executeQuery:qSql,[BusinessAirCoach getTel]];
        _playList = nil;
        while ([set next]) {
            
            NSData *CourseList = [set dataForColumn:@"UserCourseList"];
            
            _playList = [PlanList mj_objectArrayWithKeyValuesArray:[NSKeyedUnarchiver unarchiveObjectWithData:CourseList]];
        }
        
    }];
    return _playList;
}
//取老数据
- (NSArray *)queryOldData:(NSString *)sqlName{
    
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@.sqlite",sqlName,[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
        NSString *qSql = @"SELECT * FROM OLD WHERE UserID = ?";
        FMResultSet *set = [nn_db executeQuery:qSql,[BusinessAirCoach getTel]];
        _playList = nil;
        while ([set next]) {
            
            NSData *CourseList = [set dataForColumn:@"UserCourseList"];
            
            _playList = [PlanList mj_objectArrayWithKeyValuesArray:[NSKeyedUnarchiver unarchiveObjectWithData:CourseList]];
            
            _MyresponseObject = CourseList;
        }
        
    }];
    return _playList;
}

//存数据
- (void)insertData:(NSData *)modelArray addSqlName:(NSString *)sqlName planId:(NSString *)myid{
    [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@%@.sqlite",sqlName,[BusinessAirCoach getTel],myid]  dbHandler:^(FMDatabase *nn_db) {
        
        NSString *sql = @"insert into OLD (UserID, UserCourseList) values(?, ?)";
        
        
        NSData *UserCourseList = modelArray;
        NSString *UserID = [BusinessAirCoach getTel];
        BOOL res = [nn_db executeUpdate:sql,UserID, UserCourseList];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"OK");
        }
    }];
}
//删除数据
- (void)deleteData:(NSString *)sqlName type:(NSString*)oldOrNew{
    
    if ([oldOrNew isEqualToString:@"old"])
    {
        [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@.sqlite",sqlName,[BusinessAirCoach getTel]]  dbHandler:^(FMDatabase *nn_db) {
            NSString *dSql = @"DELETE FROM OLD WHERE UserID = ?";
            BOOL res = [nn_db executeUpdate:dSql,[BusinessAirCoach getTel]];
            if (!res) {
                NSLog(@"error to DELETE data");
            } else {
                NSLog(@"succ to DELETE data");
                
            }
        }];
    }
    else
    {
        [[NNFMDBTool sharedInstance] execSqlInFmdb:@"tmp" dbFileName:[NSString stringWithFormat:@"%@%@%@.sqlite",sqlName,[BusinessAirCoach getTel],[BusinessAirCoach getPlancurID]]  dbHandler:^(FMDatabase *nn_db) {
            NSString *dSql = @"DELETE FROM OLD WHERE UserID = ?";
            BOOL res = [nn_db executeUpdate:dSql,[BusinessAirCoach getTel]];
            if (!res) {
                NSLog(@"error to DELETE data");
            } else {
                NSLog(@"succ to DELETE data");
                
            }
        }];
 
    }
    
    
    
    
    
}


- (float)CalculateTheSizeOfTheBindingPlan{
    
    NSString *archivingPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserVideo",[BusinessAirCoach getTel]]];
    _planIdPathfolderSize = 0;//一定要清空
    for (PlanList *plan in _playList) {
        
        NSString *strURL =  [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.mp4",plan.hostID]];
        LRLog(@"%@",strURL);
        _planIdPathfolderSize += [self fileSizeAtPath:strURL];
        [self.planIdPathArray addObject:strURL];
    }
    
    return  _planIdPathfolderSize/(1024.0 * 1024.0);
}




- (float) folderSizeAtPath:( NSString *) folderPath{
    
    NSString *archivingPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserVideo",[BusinessAirCoach getTel]]];
    
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :path]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :path] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;//一定要清空
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [path stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;

}


-(void)clearCache:(NSString *)path addArray:(NSInteger)num {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    int f =0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        
        
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *strURL =  [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
            LRLog(@"%@",strURL);

            for (NSInteger i = 0; i < num; i++) {
                
                if ([strURL isEqualToString:self.planIdPathArray[i]] == YES) {
                    
                    f++;
                    break;
                }
            }
            if (f == 0) {
                
                NSError *error;
                NSString *subPath = [path stringByAppendingPathComponent:fileName];
                [[NSFileManager defaultManager] removeItemAtPath:subPath error:&error];
                
            }else{
                f = 0;
            }
            
        }
    }
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _nameTextField.userInteractionEnabled = NO;
    if (textField.text.length == 0)
    {
        textField.text = _personalModel.nickname;
    }
    else
    {
        if ([textField.text isEqualToString:[BusinessAirCoach getNickName]])
        {
            //名字没改
        }
        else
        {
            //名字改了
             [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeCustom];
            [self postUserInformation:@"Name"];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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

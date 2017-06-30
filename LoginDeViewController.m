//
//  LoginDeViewController.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/30.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "LoginDeViewController.h"
#import "RootTabBarController.h"
@interface LoginDeViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,AlertControllerDZDelegate>


@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIView *zhezhaoview;
@property (strong, nonatomic) RootTabBarController *rootTBC;
@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSString *figureStr;

@property (nonatomic, strong) AlertControllerDZ *alertC;

@property (strong, nonatomic) UILabel *NickNameLabel;

@property (strong, nonatomic) UIImageView *iconImView;

@property (strong, nonatomic) UIButton *iconBtn;
@property (strong, nonatomic) UIButton *endBtn;

- (void)iconBtnClick:(UIButton *)sender;

@property (strong, nonatomic)  UITextField *NickNameTF;

- (void)EndBtnClick:(UIButton *)sender;

@property (nonatomic) BOOL isEndBtn;

@end

@implementation LoginDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    _isEndBtn = NO;
    
}

- (void)createUI{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    imageView.image = [UIImage imageNamed:@"登录注册-背景图"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //一定要加这句
    //imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:imageView];
    imageView.userInteractionEnabled = YES;
    //高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    _effectView.alpha = 1.0;
    _effectView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [imageView addSubview:_effectView];
    //遮罩
    _zhezhaoview = [[UIView alloc]init];
    _zhezhaoview.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    _zhezhaoview.backgroundColor = [[UIColor colorWithRed:59/255.0 green:57/255. blue:74/255.0 alpha:1] colorWithAlphaComponent:0.7];
    
    [imageView addSubview:_zhezhaoview];
    
    UIView *tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 44)];
    tabbarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tabbarView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-200)/2, 0, 200, 44)];
    titleLabel.text = @"完善个人资料";
    titleLabel.textAlignment = 1;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [tabbarView addSubview:titleLabel];
    
    UIButton *tiaoGuoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    tiaoGuoBtn.backgroundColor = [UIColor redColor];
    tiaoGuoBtn.frame = CGRectMake(SCREENWIDTH-50-15, 0, 50, 44);
    tiaoGuoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    tiaoGuoBtn.tintColor = [UIColor whiteColor];
   
    
    [tiaoGuoBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [tiaoGuoBtn setUnderlineNone:YES];
    tiaoGuoBtn.tag = 1025;
    [tiaoGuoBtn addTarget:self action:@selector(tiaoGuoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:tiaoGuoBtn];
    
    
    _imagePicker = [[UIImagePickerController alloc]init];
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    
    _iconImView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH-96*WIDTHBASE)/2, 93, 96*WIDTHBASE, 96*WIDTHBASE)];
    _iconImView.image = [UIImage imageNamed:@"默认头像"];
    _iconImView.layer.cornerRadius = 96*WIDTHBASE/2;
    _iconImView.layer.masksToBounds = YES;
    
    [self.view addSubview:_iconImView];
    
    _iconBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-96*WIDTHBASE)/2, 93, 96*WIDTHBASE, 96*WIDTHBASE)];
    
    [_iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_iconBtn];
    
    UIImageView *biaoziImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2+26*WIDTHBASE, 93+96*WIDTHBASE-30*WIDTHBASE, 30*WIDTHBASE, 30*WIDTHBASE)];
    biaoziImg.image = [UIImage imageNamed:@"上传头像1"];
    
    [self.view addSubview:biaoziImg];
    
    
    UIView *tfView = [[UIView  alloc] initWithFrame:CGRectMake(15, _iconImView.frame.size.height+_iconImView.frame.origin.y+32, SCREENWIDTH-30, 54*WIDTHBASE)];
    tfView.backgroundColor = [UIColor whiteColor];
    tfView.userInteractionEnabled = YES;
    
    tfView.layer.cornerRadius = 4;
    tfView.layer.masksToBounds = YES;
    [self.view addSubview:tfView];
    
    _NickNameTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, tfView.frame.size.width-20, 54*WIDTHBASE)];
    _NickNameTF.placeholder = @"设置昵称";

    _NickNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _NickNameTF.font = [UIFont systemFontOfSize:15];
    _NickNameTF.delegate = self;
    _NickNameTF.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0f];
    [tfView addSubview:_NickNameTF];
    
    _endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _endBtn.frame = CGRectMake(15, tfView.frame.size.height+tfView.frame.origin.y+17, SCREENWIDTH-30, 50);
    _endBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _endBtn.layer.cornerRadius = 4;
    _endBtn.layer.masksToBounds = YES;
    _endBtn.enabled = NO;
    _endBtn.tag = 1024;
    [_endBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_endBtn addTarget:self action:@selector(EndBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_endBtn setBackgroundImage:[UIImage imageNamed:@"可点击"] forState:UIControlStateNormal];
    [_endBtn setBackgroundImage:[UIImage imageNamed:@"不可点击"] forState:UIControlStateDisabled];
   
    [self.view addSubview:_endBtn];
    
}

//判断完成按钮是否可用
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_NickNameTF.text.length == 0) {
        _endBtn.enabled = NO;
    } else {
        _endBtn.enabled = YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   _endBtn.enabled = YES;
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





//头像
- (void)iconBtnClick:(UIButton *)sender {

    
    UIActionSheet *sheet;
    // 判断是否支持相机
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择上传图片的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择上传图片的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}

#pragma mark UIAction 代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        //        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    [self camera];
                    break;
                case 1:
                    // 相册
                    [self photo];
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else
        {
            switch (buttonIndex) {
                    
                case 0:
                    // 相册
                    [self photo];
                    break;
                case 1:
                    // 取消
                    return;
            }
            
        }
        
    }
    if (actionSheet.tag == 200) {
        
        if (buttonIndex == 0)
        {
            
            
        }
        else if (buttonIndex == 1)
        {
            
        }
        
        else
        {
            return;
        }
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
    _iconImView.image = image;
    
    //上传阿里云
    //_data = UIImagePNGRepresentation(image);
    
    [picker dismissViewControllerAnimated:NO completion:^{
        /******************************/
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)sendDynamicClicks
{
    //
    NSString *token = [TokenGet getTwoMinutesOfToken];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    //上传图片到阿里云
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGSize SIZE = CGSizeMake(450, 600);
        CGSize actualScaledSize = CGSizeMake(0, 0);
        
        UIImage *image = _iconImView.image;
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
        
        
        
        NSInteger num = arc4random() % 1000000;
        
        _figureStr = nil;
      
            [CTAirCoachOss addPic:enImage PicName:[NSString stringWithFormat:@"%ld",(long)num]];
            _figureStr = [NSString stringWithFormat:@"http://image-test.aircoach.cn/image/UserHead%@.jpg",[NSString stringWithFormat:@"%ld",(long)num]];
        
        [BusinessAirCoach setHeadPortrait:_figureStr];
        
        
        [BusinessAirCoach JugedToken];
        if ([[BusinessAirCoach getAlllabel] isEqualToString:@"CanUse"])
        {
            //token没过期 开始刷新
            [self upDataCustom];
        }
        else
        {
            //接收到通知 开始刷新
            //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RequstAllready" object:nil];
            __weak typeof(self) weakSelf = self;
            __block __weak id gpsObserver;
            gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                [weakSelf upDataCustom];
                [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
            }];
            
        }
        
        
        
    });
    
}


//跳过
- (void)tiaoGuoBtn:(UIButton *)sender{
    

    _isEndBtn = NO;
    //判断token是否过期
    [BusinessAirCoach JugedToken];
    if ([[BusinessAirCoach getAlllabel] isEqualToString:@"CanUse"])
    {
        //token没过期 开始刷新
        [self sendDynamicClicks];
    }
    else
    {
        //接收到通知 开始刷新
        __weak typeof(self) weakSelf = self;
        __block __weak id gpsObserver;
        gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf sendDynamicClicks];
            [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
        }];
        
    }
}

//完成
- (void)EndBtnClick:(UIButton *)sender {
    
    
    _isEndBtn = YES;
    //判断token是否过期
    [BusinessAirCoach JugedToken];
    if ([[BusinessAirCoach getAlllabel] isEqualToString:@"CanUse"])
    {
        //token没过期 开始刷新
        [self sendDynamicClicks];
    }
    else
    {
        //接收到通知 开始刷新
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RequstAllready" object:nil];
        __weak typeof(self) weakSelf = self;
        __block __weak id gpsObserver;
        gpsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RequstAllready" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf sendDynamicClicks];
            [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
        }];
        
    }
}


- (void)upDataCustom{
    
    NSDictionary *paramet = nil;
    if (_isEndBtn == NO) {
       
        if (_nameString == nil) {
            _nameString = @"未命名用户";
        }
       paramet= @{
            @"figure":_figureStr,
            @"nickname":_nameString
            };
    }else {
       paramet= @{
        @"figure":_figureStr,
        @"nickname": _NickNameTF.text
        };
    }
  
    [[HttpsRefreshNetworking  Networking] POST:CUSTOM parameters:paramet success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
        
        LRLog(@"%@",responseObject);
        
        [[HttpsRefreshNetworking Networking] GET:CUSTOM parameters:nil success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
            
            LRLog(@"%@",responseObject);
            [SVProgressHUD dismiss];
            NSString *statusString =[responseObject objectForKey:@"status"];
            if ([statusString isEqualToString:@"expired"]) {
              //  LRLog(@"过期");
                
                _alertC = [[AlertControllerDZ alloc]initWithFrame:self.view.bounds WithTitle:nil andDetail:@"已经过期了 请从新购买" andCancelTitle:@"取消" andOtherTitle:@"确定" andFloat:66 BtnNum:@"Two" location:NSTextAlignmentCenter];
                _alertC.detailLabel.textColor = [UIColor blackColor];
                _alertC.tag = 10;
                _alertC.delegate = self;
                [[UIApplication sharedApplication].keyWindow addSubview:_alertC];
                
                
            } else if ([statusString isEqualToString:@"prepared"]){
               // LRLog(@"准备");
                [SVProgressHUD showSuccessWithStatus:@"准备中"];
                
            }else if ([statusString isEqualToString:@"normal"]){
              //  LRLog(@"正常的");
                _rootTBC = [RootTabBarController new];
                
                [self presentViewController:_rootTBC animated:YES completion:^{
                    
                }];
                
            }else if ([statusString isEqualToString:@"pause"]){
               // LRLog(@"暂停");
                _alertC = [[AlertControllerDZ alloc]initWithFrame:self.view.bounds WithTitle:nil andDetail:@"您已经暂停服务了，确定要开启吗？"  andCancelTitle:@"取消" andOtherTitle:@"确定" andFloat:66 BtnNum:@"Two" location:NSTextAlignmentCenter];
                _alertC.detailLabel.textColor = [UIColor blackColor];
                _alertC.tag = 11;
                _alertC.delegate = self;
                [[UIApplication sharedApplication].keyWindow addSubview:_alertC];                }
            
            
            
            
            
        } failure:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
            LRLog(@"%@",error);
            [SVProgressHUD dismiss];
            PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
            [[UIApplication sharedApplication].keyWindow addSubview:prom];
        }];
        
    } failure:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
        LRLog(@"%@",error);
        [SVProgressHUD dismiss];
        PromptBoxView *prom = [[PromptBoxView  alloc] initWithFrame:self.view.bounds WithTitle:@"请检测您的网络设置"];
        [[UIApplication sharedApplication].keyWindow addSubview:prom];
    }];
    
}

-(void)clickButtonWithTag:(UIButton *)button
{
    switch (_alertC.tag) {
        case 10:
        {
            if (button.tag == 308)
            {
                LRLog(@"传过来的是取消按钮");
            }
            if (button.tag == 309)
            {
                LRLog(@"传过来的是确定按钮");
                
            }
        }
            break;
        case 11:
        {
            if (button.tag == 308)
            {
                LRLog(@"传过来的是取消按钮");
            }
            if (button.tag == 309)
            {
                LRLog(@"传过来的是确定按钮");
                
                
                
                
                
            }
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
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
@end

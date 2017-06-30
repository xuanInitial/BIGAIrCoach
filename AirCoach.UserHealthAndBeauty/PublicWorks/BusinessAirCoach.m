//
//  BusinessLogic.m
//  UNIQ
//
//  Created by on 15/10/8.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "BusinessAirCoach.h"
#import "HttpsRefreshNetworking.h"
@implementation BusinessAirCoach
/**   设置label的高度    */
+ (void)setlabelheight:(NSString*)height
{
    [[NSUserDefaults standardUserDefaults] setObject:height forKey:@"labelheight"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**   获取label的高度 */
+ (NSString*)getlabelheight
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"labelheight"];
}
/**   设置全局标签    */
+ (void)setAlllabel:(NSString*)Alllabel
{
    [[NSUserDefaults standardUserDefaults] setObject:Alllabel forKey:@"Alllabel"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**  获取全局标签 */
+ (NSString*)getAlllabel
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Alllabel"];
}


/**   设置authorization   */
+ (void)setUserAuthorization:(NSString*)authorization
{
    [[NSUserDefaults standardUserDefaults] setObject:authorization forKey:@"authorization"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**   获取authorization */
+ (NSString*)getAuthorization
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"authorization"];
}

/**   存入用户开始服务的时间   */
+ (void)setUserStartTime:(NSString*)mytime
{
    [[NSUserDefaults standardUserDefaults] setObject:mytime forKey:@"StartTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**   获取用户开始服务的时间 */
+ (NSString*)getStartTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"StartTime"];
}

//首页刷新时间
+ (void)setTrainShuaxuinTime:(NSDate*)mytime
{
    [[NSUserDefaults standardUserDefaults] setObject:mytime forKey:@"UserShuaxinTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 获得首页刷新时间 */
+ (NSDate*)GetTrainShuaxuin
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserShuaxinTime"];
}




+(void)JugedToken
{    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //计算日期差值
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *fir = [BusinessAirCoach getFirstTime];
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval time = [zone secondsFromGMTForDate:fir];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSTimeInterval timeNow = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *datefir = [fir dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
    NSDate *dateNow = [[NSDate date] dateByAddingTimeInterval:timeNow];
    
    
    NSDateComponents *d = [cal components:unitFlags fromDate:datefir toDate:dateNow options:0];

    if ([d minute] >= 1||[d minute] <= -1 ||[d hour] >= 1)
    {
        //加锁
        [self setAlllabel:@"NoUse"];
        @synchronized (self)
        {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authorization"] == nil)
            {
                
            }
            else
            {
                
                NSDictionary *dic = @{@"haha":@"wode"};
                [[HttpsRefreshNetworking Networking] POST:Refresh parameters:dic success:^(NSDictionary *allHeaders, id responseObject, id statusCode) {
                    //写入新的token

                    
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authorization"];

                  //  LRLog(@"%@",responseObject);

                    [self setUserAuthorization:[allHeaders objectForKey:@"Authorization"]];
                   
                    [BusinessAirCoach setFirstTime:[NSDate date]];
                    
                    [self setAlllabel:@"CanUse"];
                    
                    //发通知 通知刷新数据
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RequstAllready" object:nil];
                    
                } failure:^(NSDictionary *allHeaders, NSError *error, id statusCode) {
                   
                    [self setAlllabel:@"CanUse"];
                    //发通知 通知刷新数据
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RequstAllready" object:nil];
                   
                }];
                
                
                
                
                
            }
            
        }
        
    }
    else
    {
        LRLog(@"没过期");
        [self setAlllabel:@"CanUse"];
    }
 
}
+(NSDate *)BeijngTime:(NSDate*)firstDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:firstDate];
    NSDate *localeDate = [firstDate dateByAddingTimeInterval:interval];
    LRLog(@"%@", localeDate);
    return localeDate;
}

/**   设置云信的acc_id    */
+ (void)setyunxinAcc:(NSString*)acc
{
    [[NSUserDefaults standardUserDefaults] setObject:acc forKey:@"acc_id"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**   获取云信的acc_id  */
+ (NSString*)getAcc
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"acc_id"];
}
/**   设置云信的token    */
+ (void)setyunxinToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"yun_token"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**   获取云信的token  */
+ (NSString*)getyunxinToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"yun_token"];
}


/**   设置使用天数    */
+ (void)setUseDays:(NSString*)days{
    [[NSUserDefaults standardUserDefaults] setObject:days forKey:@"UseDays"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**   获取使用天数  */
+ (NSString*)getUseDays{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UseDays"];
}


/**   设置type    */
+ (void)setUserType:(NSString*)type
{
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"type"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**   获取type */
+ (NSString*)getType
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"type"];
}
/**
 *  存储手机号  不能删(新)
 */
+ (void)setTel:(NSString *)tel
{
    [[NSUserDefaults standardUserDefaults] setObject:tel forKey:@"tel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getTel
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"tel"];
}





/**   设置登录状态  @param type BOOL值  */
+ (void)setLoginState:(BOOL)type
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:type] forKey:@"login"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**   获取当前登录状态 */
+ (BOOL)isLogin
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] boolValue];
}

/**  存储token值 */
+ (void)setToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 获取token  */
+ (NSString *)getToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

/**  存储环信用户名 */
+ (void)setUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**   获取环信用户名  */
+ (NSString *)getUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}

/**   存储密码 */
+ (void)setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**  获取密码  */
+ (NSString *)getPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

/**
 *  存储密码
*/
+ (void)setUA:(NSString *)UA
{
    [[NSUserDefaults standardUserDefaults] setObject:UA forKey:@"User-Agent"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setPhoneNumber:(NSString *)phoneNumber
{
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getPhoneNumber
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
}

+ (void)setUserId:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"User-Agent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"User-Agent"];
}

/**
 * 存储性别
 */
+ (void)setSex:(NSString *)Sex
{
    [[NSUserDefaults standardUserDefaults] setObject:Sex forKey:@"Sex"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
/**
 * 获取性别
 */

+ (NSString *)getSex
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Sex"];
}

/**
 *  存储用户手机标示信息
 */
+(void)setUserFlag:(NSDictionary*)dic myTel:(NSString*)myflag;
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"UserTelflag"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserTelflag%@.plist",myflag]];
    LRLog(@"%@",strPath);
    [dic writeToFile:strPath atomically:YES];
    
    
    
    
}
+(NSDictionary *)getUserFlag:(NSString*)myflag
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"UserTelflag"];
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserTelflag%@.plist",myflag]];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:strPath];
    return dic;
}
/**
 *  存储用户点击标示信息
 */
+(void)setUserTestLa:(NSDictionary*)dic myTel:(NSString*)myflag;
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"TestLa"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserTestLa%@.plist",myflag]];
   
    [dic writeToFile:strPath atomically:YES];
    
    
    
    
}
+(NSDictionary *)getUserTestLa:(NSString*)myflag
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"TestLa"];
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserTestLa%@.plist",myflag]];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:strPath];
    return dic;
}
/**
 *  存储用户微信标示信息
 */
+(void)setUserWeixinFlag:(NSDictionary*)dic myTel:(NSString*)myflag
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"UserWeiXinflag"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserWeiXinflag%@.plist",myflag]];
    
    [dic writeToFile:strPath atomically:YES];
}

+(NSDictionary *)getUserWeixinFlag:(NSString*)myflag
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"UserWeiXinflag"];
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserWeiXinflag%@.plist",myflag]];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:strPath];
    return dic;
}
/**
 *  存储是否可以运动提示框信息
 */
+(void)setUserCanMove:(NSDictionary*)dic
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"UserCanMove"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserCanMove%@.plist",[BusinessAirCoach getTel]]];
    
    [dic writeToFile:strPath atomically:YES];
}

+(NSDictionary *)getUserCanMove
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"UserCanMove"];
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserCanMove%@.plist",[BusinessAirCoach getTel]]];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:strPath];
    return dic;
}
/**
 *  存储是否可以使用语音系统
 */
+(void)setUserCanUseAudio:(NSDictionary*)dic
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"UseAudio"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UseAudio%@.plist",[BusinessAirCoach getTel]]];
    
    [dic writeToFile:strPath atomically:YES];
}

+(NSDictionary *)getUserUseAudio
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"UseAudio"];
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UseAudio%@.plist",[BusinessAirCoach getTel]]];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:strPath];
    return dic;
}


/**
 *  存储第一次请求的时间
 */
+ (void)setFirstTime:(NSDate *)time{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"FirstTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate *)getFirstTime{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstTime"];
}

/**
 *  存储体侧时间
 */
+(void)setUserTestTime:(NSDictionary*)time
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"UserTestTime"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserTestTime%@.plist",[BusinessAirCoach getTel]]];
   
    [time writeToFile:strPath atomically:YES];
}

+(NSDictionary *)getUserTestTime
{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"UserTestTime"];
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserTestTime%@.plist",[BusinessAirCoach getTel]]];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:strPath];
    return dic;
}

/**
 * 存储身高
 */
+ (void)setheight:(NSString *)height{
    [[NSUserDefaults standardUserDefaults] setObject:height forKey:@"height"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取身高
 */

+ (NSString *)getheight{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"height"];
}


/**
 * 存储体重
 */
+ (void)setweight:(NSString *)weight{
    [[NSUserDefaults standardUserDefaults] setObject:weight forKey:@"weight"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取体重
 */

+ (NSString *)getweight{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"weight"]; 
}





/**
 * 存储认证状态
 */
+ (void)setCertify:(NSString *)State
{
    [[NSUserDefaults standardUserDefaults] setObject:State forKey:@"Certify-State"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取认证状态
 */

+ (NSString *)getState
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Certify-State"];
}


+ (void)setBMI:(NSString *)State{
    [[NSUserDefaults standardUserDefaults] setObject:State forKey:@"BMI-api"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取BMI
 */

+ (NSString *)getBMI{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"BMI-api"];
}
/**
 * 存储年龄
 */
+ (void)setAge:(NSString *)age{
    
    [[NSUserDefaults standardUserDefaults] setObject:age forKey:@"User-age"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取年龄
 */

+ (NSString *)getAge{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"User-age"];
}


/**
 * 存储头像
 */
+ (void)setHeadPortrait:(NSString *)HeadPortrait{
    [[NSUserDefaults standardUserDefaults] setObject:HeadPortrait forKey:@"HeadPortrait"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取头像
 */

+ (NSString *)getHeadPortrait{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"HeadPortrait"];
}
/**
 * 存储教练头像
 */
+ (void)setCoachHeadPortrait:(NSString *)HeadPortrait{
    [[NSUserDefaults standardUserDefaults] setObject:HeadPortrait forKey:@"CoachHeadPortrait"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取教练头像
 */

+ (NSString *)getCoachHeadPortrait{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CoachHeadPortrait"];
}
/**
 * 存储教练云信id
 */
+ (void)setCoachAcc_id:(NSString *)acc_id{
    [[NSUserDefaults standardUserDefaults] setObject:acc_id forKey:@"Coachacc_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取教练云信id
 */

+ (NSString *)getCoachAcc_id{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Coachacc_id"];
}

/**
 * 存储昵称
 */
+ (void)setNickName:(NSString *)nickname{
    [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"NickName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取昵称
 */

+ (NSString *)getNickName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"NickName"];
}

/**
 * 存储推荐教练
 */
+ (void)setCoachName:(NSString *)CoachName{
    [[NSUserDefaults standardUserDefaults] setObject:CoachName forKey:@"CoachName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取推荐教练
 */

+ (NSString *)getCoachName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CoachName"];
}

/**
 * 存储护理师头像
 */
+ (void)setCoachFigure:(NSString *)CoachFigure{
    [[NSUserDefaults standardUserDefaults] setObject:CoachFigure forKey:@"CoachFigure"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 * 获取护理师头像
 */

+ (NSString *)getCoachFigure{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CoachFigure"];
}








/**   存储是否点击了下载*/
+ (void)setWhetherToClickOnTheDownload:(NSString * )type{
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"Download"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**   获取是否点击了下载 */
+ (NSString*)getWhetherToClickOnTheDownload{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Download"];
}


/**
 * 存储课程详情页面进度条标签下载个数
 */
+ (void)setProgressBarToDownloadANumberOfLabels:(NSString *)NumberOfLabels{
    [[NSUserDefaults standardUserDefaults] setObject:NumberOfLabels forKey:@"NumberOfLabels"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 * 获取课程详情页面进度条标签下载个数
 */

+ (NSString *)getProgressBarToDownloadANumberOfLabels{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"NumberOfLabels"];
}



/**
 * 存储推荐计划
 */
+ (void)setPlanName:(NSString *)PlanName{
    [[NSUserDefaults standardUserDefaults] setObject:PlanName forKey:@"PlanName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取推荐教练
 */

+ (NSString *)getPlanName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"PlanName"];
}

/**
 * 存储当前计划id
 */
+ (void)setcurID:(NSString *)PlanID{
    [[NSUserDefaults standardUserDefaults] setObject:PlanID forKey:[NSString stringWithFormat:@"%@PlanID",[BusinessAirCoach getTel]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取当前计划id
 */

+ (NSString *)getPlancurID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@PlanID",[BusinessAirCoach getTel]]];
}

/**
 * 存储前一个计划id
 */
+ (void)setLastcurID:(NSString *)PlanID{
    [[NSUserDefaults standardUserDefaults] setObject:PlanID forKey:[NSString stringWithFormat:@"%@LastPlanID",[BusinessAirCoach getTel]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取前一个计划id
 */

+ (NSString *)getLastPlancurID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@LastPlanID",[BusinessAirCoach getTel]]];
}



/**
 * 存储推荐计划url
 */
+ (void)setPlanUrl:(NSString *)PlanUrl{
    [[NSUserDefaults standardUserDefaults] setObject:PlanUrl forKey:@"Planurl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取推荐计划url
 */

+ (NSString *)getPlanUrl{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Planurl"];
}

/**
 * 获取UUID
 */

+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[KeyChainStore load:@"com.company.app.usernamepassword"];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}

/**
 * 存储时间戳
 */

+ (void)setTime:(NSString *)time{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取时间戳
 */

+(NSString *)getTime{
    
     return [[NSUserDefaults standardUserDefaults] objectForKey:@"time"];
}



#pragma mark 电话号码验证
+ (BOOL)isValidateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278]|7[0-9])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark 邮箱验证
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 密码验证
+(BOOL)isValidatePassword:(NSString *)password
{
    if(password != nil || password.length != 0)
    {
        //设置密码位数
        if (password.length >= 6 && password.length <= 20) {
            return YES;
        }else
        {
            return NO;
        }
        
    }else
    {
        return NO;
    }
}

//身份证号
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark 护照号
+ (BOOL)isValidatePassport: (NSString *)passport
{
    BOOL flag;
    if (passport.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"(P\\d{7})|(G\\d{8})";
    NSPredicate * passportTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [passportTest evaluateWithObject:passport];
}


//照片压缩
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


/**
 * 存储总千卡数
 */

+ (void)setTotalKcal:(NSString *)Kcal{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"TotalKcal"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    NSString *strPath = nil;
    
    strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"TotalKcal%@.plist",[BusinessAirCoach getTel]]];
    
   
    NSDictionary *dic = @{@"TotalKcal":Kcal};
    [dic writeToFile:strPath atomically:YES];
}
/**
 * 获取总千卡数
 */

+ (NSString *)getTotalKcal:(NSString*)Kcal{
    
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"TotalKcal"];
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"TotalKcal%@.plist",Kcal]];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:strPath];
    return dic[@"TotalKcal"];
}

//用户要说的话
+ (void)setUserSpeaker:(NSString *)speak
{
    [[NSUserDefaults standardUserDefaults] setObject:speak forKey:@"Myspeak"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取用户要说的话
 */

+(NSString *)getUserSpeak{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Myspeak"];
}

//获得当前计划背景图
+ (void)setCruteBackgroudImage:(NSString *)figure
{
    [[NSUserDefaults standardUserDefaults] setObject:figure forKey:@"BackgroudImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取当前计划背景图
 */

+(NSString *)getCruteBackgroudImage{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"BackgroudImage"];
}


//存入云信最后一条消息
+ (void)setlastMessage:(NSString *)message{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"lastMessage"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    NSString *strPath = nil;
    
    strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lastMessage%@.plist",[BusinessAirCoach getTel]]];

   
    NSDictionary *dic = @{@"message":message};
    [dic writeToFile:strPath atomically:YES];
}

/**
 * 获取云信最后一条信息
 */

+ (NSString *)getlastMessage:(NSString*)myflag{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"lastMessage"];
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lastMessage%@.plist",myflag]];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:strPath];
    return dic[@"message"];
}
//存入云信最后一条消息
+ (void)setlastMessageTime:(NSString *)time{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"MessageTime"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    NSString *strPath = nil;
    if ([BusinessAirCoach getUserFlag:[BusinessAirCoach getTel]])
    {
        strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"MessageTime%@.plist",[BusinessAirCoach getTel]]];
    }
    if ([BusinessAirCoach getUserWeixinFlag:[[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID]])
    {
        strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"MessageTime%@.plist",[[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID]]];
    }
    
    
    NSDictionary *dic = @{@"messageTime":time};
    [dic writeToFile:strPath atomically:YES];
}

/**
 * 获取云信最后一条信息时间
 */

+ (NSString *)getlastMessageTime:(NSString*)myflag{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"MessageTime"];
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"MessageTime%@.plist",myflag]];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:strPath];
    return dic[@"messageTime"];
}

//小红点控制
+ (void)setMessagered:(NSString*)red{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"red"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
    }
    NSString *strPath = nil;
    if ([BusinessAirCoach getUserFlag:[BusinessAirCoach getTel]])
    {
        strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"red%@.plist",[BusinessAirCoach getTel]]];
    }
    if ([BusinessAirCoach getUserWeixinFlag:[[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID]])
    {
        strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"red%@.plist",[[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID]]];
    }
    
   
    NSDictionary *dic = @{@"redappear":red};
    [dic writeToFile:strPath atomically:YES];
 
}

/**
 * 小红点控制
 */

+ (NSString *)getMessagered:(NSString*)red{
    NSString *archivingPath = [kDocumentPath stringByAppendingPathComponent:@"red"];
    NSString *strPath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"red%@.plist",red]];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:strPath];
    return dic[@"redappear"];
    
}

/**
 * 进入聊天页面的标签
 */
+ (void)setUserSpeakerLab:(NSString *)speak
{
    [[NSUserDefaults standardUserDefaults] setObject:speak forKey:@"MyUserSpeak"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取聊天页面的标签
 */
+(NSString *)getUserSpeakerLab{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserSpeak"];
}

/**
 * 进入计划训练页面的标签
 */
+ (void)setUserStartPlan:(NSString *)StartPlan
{
    [[NSUserDefaults standardUserDefaults] setObject:StartPlan forKey:@"MyStartPlan"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取计划页面的标签
 */
+(NSString *)getUserStartPlan{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"MyStartPlan"];
}

/**
 * 存储非工作日期标签
 */
+ (void)setrestDay:(NSString *)restday
{
    [[NSUserDefaults standardUserDefaults] setObject:restday forKey:@"doctorRestDay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取非工作日期标签
 */
+(NSString *)getrestDay{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"doctorRestDay"];
}

/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=9，toHour=18时，即为判断当前时间是否在8:00-23:00之间
 */
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *date9 = [self getCustomDateWithHour:fromHour];
    NSDate *date18 = [self getCustomDateWithHour:toHour];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date9]==NSOrderedDescending && [currentDate compare:date18]==NSOrderedAscending)
    {
        NSLog(@"该时间在 %d:00-%d:00 之间！", fromHour, toHour);
        return YES;
    }
    return NO;
}
/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}
//判断周几的方法 使着可以 可以用
+(NSInteger)jugdeTagTime:(NSDate*)weekDate
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:weekDate];
    NSLog(@"%ld",(long)[comps weekday]);
    
    return [comps weekday];
}


/**
 * 记录首页登录的标签
 */
+ (void)setstartError:(NSString *)LoginError
{
    [[NSUserDefaults standardUserDefaults] setObject:LoginError forKey:@"UerLoginError"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}






@end







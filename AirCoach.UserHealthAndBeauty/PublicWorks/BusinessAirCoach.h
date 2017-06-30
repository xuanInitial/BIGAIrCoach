//
//  BusinessLogic.h
//  UNIQ
//
//  Created by  on 15/10/8.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyChainStore.h"
#import "Header.h"
#import <UIKit/UIKit.h>

@interface BusinessAirCoach : NSObject

+(void)JugedToken;
+ (void)setlabelheight:(NSString*)height;
+ (NSString*)getlabelheight;
+(NSDate *)BeijngTime:(NSDate*)firstDate;
#pragma mark 手机号验证
+ (BOOL)isValidateMobile:(NSString *)mobileNum;

#pragma mark 邮箱验证
+(BOOL)isValidateEmail:(NSString *)email;

#pragma mark 密码验证 (6~16位)
+(BOOL)isValidatePassword:(NSString *)password;

#pragma mark 身份证号
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard;

#pragma mark 护照号
+ (BOOL)isValidatePassport: (NSString *)identityCard;
/** 
 * 获取authorization 
 */
+ (void)setUserAuthorization:(NSString*)authorization;
/**
 * 获取authorization
 */
+ (NSString*)getAuthorization;

/**
 *  存储手机号
 */
+ (void)setTel:(NSString *)tel;
+(NSString*)getTel;


/**
 *  设置登录状态
 *
 *  @param type BOOL值
 */
+ (void)setLoginState:(BOOL)type;
/**
 *  获取当前登录状态
 */
+ (BOOL)isLogin;

/**
 *  存储token
 */
+ (void)setToken:(NSString *)token;

//7ad4ce75d9cf15af716031ec2e28ef13

/**
 *  获取token
 */
+ (NSString *)getToken;

/**
 *  存储环信用户名
 */
+ (void)setUserName:(NSString *)userName;

/**
 * 获取环信用户名
 */
+ (NSString *)getUserName;
/**
 *  存储密码
 */
+ (void)setPassword:(NSString *)password;

/**
 *  获取密码
 */
+ (NSString *)getPassword;

/**
 *  存储密码
 */
+ (void)setUA:(NSString *)UA;


/**
 * 存储用户id
 */
+ (void)setUserId:(NSString *)userId;

/**
 * 生成用户id
 */
+ (NSString *)getUserId;

/**
 * 存储手机号
 */
+ (void)setPhoneNumber:(NSString *)phoneNumber;

/**
 * 获取手机号
 */

+ (NSString *)getPhoneNumber;
/**
 * 存储性别
 */
+ (void)setSex:(NSString *)Sex;

/**
 * 获取性别
 */

+ (NSString *)getSex;

/**
 * 存储认证状态
 */
+ (void)setCertify:(NSString *)State;

/**
 * 获取认证状态
 */

+ (NSString *)getState;

/**
 * 存储BMI
 */
+ (void)setBMI:(NSString *)State;

/**
 * 获取BMI
 */

+ (NSString *)getBMI;

/**
 * 存储年龄
 */
+ (void)setAge:(NSString *)age;

/**
 * 获取年龄
 */

+ (NSString *)getAge ;




/**
 * 存储头像
 */
+ (void)setHeadPortrait:(NSString *)HeadPortrait;

/**
 * 获取头像
 */

+ (NSString *)getHeadPortrait;


/**
 * 存储昵称
 */
+ (void)setNickName:(NSString *)nickname;

/**
 * 获取昵称
 */

+ (NSString *)getNickName;


/**
 * 存储身高
 */
+ (void)setheight:(NSString *)height;

/**
 * 获取身高
 */

+ (NSString *)getheight;

/**
 * 存储体重
 */
+ (void)setweight:(NSString *)weight;

/**
 * 获取体重
 */

+ (NSString *)getweight;



/**
 * 存储护理师云信id
 */
+ (void)setCoachAcc_id:(NSString *)acc_id;
/**
 * 获取护理师云信id
 */
+ (NSString *)getCoachAcc_id;
/**
 * 存储推荐护理师
 */
+ (void)setCoachName:(NSString *)CoachName;
/**
 * 获取推荐护理师
 */

+ (NSString *)getCoachName;


/**
 * 存储护理师头像
 */
+ (void)setCoachFigure:(NSString *)CoachFigure;
/**
 * 获取护理师头像
 */

+ (NSString *)getCoachFigure;






/**
 * 存储推荐计划
 */
+ (void)setPlanName:(NSString *)PlanName;
/**
 * 获取推荐教练
 */


/**
 * 获取UUID
 */

+(NSString *)getUUID;


/**
 * 存储时间戳
 */

+ (void)setTime:(NSString *)time;

/**
 * 获取时间戳
 */

+(NSString *)getTime;



+ (NSString *)getPlanName;


+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;



/**
 * 存储总千卡数
 */

+ (void)setTotalKcal:(NSString *)Kcal;
/**
 * 获取总千卡数
 */

+ (NSString *)getTotalKcal:(NSString*)Kcal;



+ (void)setlastMessage:(NSString *)message;
/**
 * 获取环信最后一条信息
 */

+ (NSString *)getlastMessage:(NSString*)myflag;

//存入环信最后一条消息时间
+ (void)setlastMessageTime:(NSString *)time;
 
/**
 * 获取环信最后一条信息时间
 */
+ (NSString *)getlastMessageTime:(NSString*)myflag;
//小红点控制
+ (void)setMessagered:(NSString*)red;
/**
 * 小红点控制
 */
+ (NSString *)getMessagered:(NSString*)red;

/**
 * 存储推荐计划url
 */
+ (void)setPlanUrl:(NSString *)PlanUrl;

+ (NSString *)getPlanUrl;

+(void)setUserFlag:(NSDictionary*)dic myTel:(NSString*)myflag;
+(NSDictionary *)getUserFlag:(NSString*)myflag;

+(void)setUserWeixinFlag:(NSDictionary*)dic myTel:(NSString*)myflag;
+(NSDictionary *)getUserWeixinFlag:(NSString*)myflag;

/**   设置type    */
+ (void)setUserType:(NSString*)type;

/**   获取type */
+ (NSString*)getType;


+ (void)setCoachHeadPortrait:(NSString *)HeadPortrait;
+ (NSString *)getCoachHeadPortrait;


/**   设置云信的acc_id    */
+ (void)setyunxinAcc:(NSString*)acc;

/**   获取云信的acc_id  */
+ (NSString*)getAcc;

/**   设置云信的token    */
+ (void)setyunxinToken:(NSString*)token;


/**   获取云信的token  */
+ (NSString*)getyunxinToken;

/**   设置使用天数    */
+ (void)setUseDays:(NSString*)days;


/**   获取使用天数  */
+ (NSString*)getUseDays;


/**
 * 获取用户是否可以运动
 */
+(void)setUserCanMove:(NSDictionary*)dic;

+(NSDictionary *)getUserCanMove;

/**
 * 获取用户体侧时间
 */

+(void)setUserTestTime:(NSDictionary*)time;

+(NSDictionary *)getUserTestTime;

+ (void)setFirstTime:(NSDate *)time;
+ (NSDate*)getFirstTime;

+ (void)setAlllabel:(NSString*)Alllabel;
/**  获取全局标签 */
+ (NSString*)getAlllabel;

+(void)setUserTestLa:(NSDictionary*)dic myTel:(NSString*)myflag;

+(NSDictionary *)getUserTestLa:(NSString*)myflag;


/**   存入用户开始服务的时间   */
+(void)setUserStartTime:(NSString*)mytime;
/**   获取用户开始服务的时间 */
+(NSString*)getStartTime;
+ (void)setTrainShuaxuinTime:(NSDate*)mytime;
/** 获得首页刷新时间 */
+ (NSDate*)GetTrainShuaxuin;





/**   存储是否点击了下载*/
+ (void)setWhetherToClickOnTheDownload:(NSString * )type;

/**   获取是否点击了下载 */
+ (NSString*)getWhetherToClickOnTheDownload;

/**
 *  存储是否可以使用语音系统
 */
+(void)setUserCanUseAudio:(NSDictionary*)dic;
+(NSDictionary *)getUserUseAudio;




/**
 * 存储课程详情页面进度条标签下载个数
 */
+ (void)setProgressBarToDownloadANumberOfLabels:(NSString *)NumberOfLabels;
/**
 * 获取课程详情页面进度条标签下载个数
 */

+ (NSString *)getProgressBarToDownloadANumberOfLabels;
+ (void)setUserSpeaker:(NSString *)speak;

/**
 * 获取用户要说的话
 */
+(NSString *)getUserSpeak;

+(void)setUserSpeakerLab:(NSString *)speak;
+(NSString *)getUserSpeakerLab;

/**
 * 进入计划训练页面的标签
 */
+(void)setUserStartPlan:(NSString *)StartPlan;
+(NSString *)getUserStartPlan;

/**
 * 获取非工作日期标签
 */
+(void)setrestDay:(NSString *)restday;
+(NSString *)getrestDay;

+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;
+(NSInteger)jugdeTagTime:(NSDate*)weekDate;


//获得当前计划背景图
+(void)setCruteBackgroudImage:(NSString *)figure;
+(NSString *)getCruteBackgroudImage;

+ (void)setcurID:(NSString *)PlanID;
+ (NSString *)getPlancurID;

/**
 * 存储前一个计划id
 */
+ (void)setLastcurID:(NSString *)PlanID;
+ (NSString *)getLastPlancurID;

+ (void)setstartError:(NSString *)LoginError;
@end

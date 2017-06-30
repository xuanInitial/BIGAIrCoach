//
//  Header.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/5/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define  KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"

#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"
#define WX_UNION_ID @"unionid"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"

//颜色
#define SegementColor [UIColor colorWithRed:241/255.f green:80/255.f blue:133/255.f alpha:1]
#define XYLineColor [UIColor colorWithRed:229/255.f green:187/255.f blue:201/255.f alpha:1]
#define InterXYLineColor [UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1]
#define XYLableColor [UIColor colorWithRed:200/255.f green:129/255.f blue:152/255.f alpha:1]
#define LableColor [UIColor colorWithRed:118/255.f green:118/255.f blue:118/255.f alpha:1]
#define speLineColor [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1]
#define ZiTiColor [UIColor colorWithRed:255/255.f green:82/255.f blue:0/255.f alpha:1]
#define specolor [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0]
#define Subcolor [UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1.0]
#define Reportcolor [UIColor colorWithRed:66.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0]
#define DottedLinecolor [UIColor colorWithRed:241.0/255.0 green:220.0/255.0 blue:227.0/255.0 alpha:1.0]
#define HorLinecolor [UIColor colorWithRed:241.0/255.0 green:220.0/255.0 blue:227.0/255.0 alpha:1.0]
#define TestLinecolor [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]

#define BgBlock [UIColor colorWithRed:43/255.0 green:46/255.0 blue:51/255.0 alpha:1.0]
#define Testcolor [UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:1.0]
#define JinduLinecolor [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]
#define Heidiancolor [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]


#define BgBlock [UIColor colorWithRed:43/255.0 green:46/255.0 blue:51/255.0 alpha:1.0]
#define Testcolor [UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:1.0]

#define JinduLinecolor [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]
#define Heidiancolor [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0]

#define MessageBlock [UIColor colorWithRed:66.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0]

#define ZhuYao [UIColor colorWithRed:241/255.0 green:80/255.0 blue:133/255.0 alpha:1]
#define TabbarColor [UIColor colorWithRed:247/255.0 green:80/255.0 blue:133/255.0 alpha:1]
#define xiLine [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.0]

#define planTextColor [UIColor colorWithRed:91.0/255.0 green:91.0/255.0 blue:91.0/255.0 alpha:1.0]
#define BodyColor [UIColor colorWithRed:245.0/255.0 green:132.0/255.0 blue:169.0/255.0 alpha:1.0]
#define tableViewColor [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]

#define AudioBtnColor [UIColor colorWithRed:75.0/255.0 green:74.0/255.0 blue:81.0/255.0 alpha:1.0]
#define AudioLabColor [UIColor colorWithRed:195.0/255.0 green:195.0/255.0 blue:195.0/255.0 alpha:1.0]
#define MyStageLabColor [UIColor colorWithRed:186.0/255.0 green:187.0/255.0 blue:197.0/255.0 alpha:1.0]
#define RestColor [UIColor colorWithRed:211.0/255.0 green:111.0/255.0 blue:217.0/255.0 alpha:1.0]
#define afterColor [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0]
#define BottomlineColor [UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0]
#define TrainZhezhaoColor [UIColor colorWithRed:29/255.0 green:24/255.0 blue:78/255.0 alpha:1.0]
#define TrainProgressTopColor [UIColor colorWithRed:255/255.0 green:228/255.0 blue:239/255.0 alpha:1.0]


//Docment文件夹目录
#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

/**
 屏幕宽度
 */
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

/**
 屏幕高度
 */
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

/**
 获得视图底部的坐标y
 */
#define QTFRAMEBUTTOMY(view) (view.frame.size.height+view.frame.origin.y)

/**
 获得视图上部的坐标y
 */
#define QTFRAMETOPY(view) view.frame.origin.y

/**
 获得视图左边的坐标x
 */
#define QTFRAMELEFTX(view) view.frame.origin.x
/**
 获得视图右边的坐标x
 */
#define QTFRAMERIGHTX(view) (view.frame.size.width+view.frame.origin.x)

/**
 适配用的
 */
#define WIDTHBASE (SCREENWIDTH/320)
#define HEIGHTBASE (SCREENHEIGHT/568)

#define WID320 (SCREENHEIGHT/320)

#define HEIGHTBASETWO ((SCREENHEIGHT - 113)/(568 - 113))



#ifdef DEBUG
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define LRLog(...) printf(" %s 第%d行: %s\n\n", [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define LRLog(...)
#endif



//测试
/*
 以下是接口部分
 */
#define TEST @"http://alpha.v2.aircoach.cn"


//正式服
//#define TEST @"http://beta.v2.aircoach.cn"

//验证码 POST
#define  VERIFY TEST@"/auth/verify"
//登录 POST
#define LOGIN TEST@"/auth/login"
//刷新token
#define Refresh TEST@"/auth/refresh"

/**
 *  以下是需要设置请求头的
 */

//当前用户基本信息 GET
#define CUSTOM TEST@"/v20/custom"

//提交用户基本信息 POST
#define CUSTOM TEST@"/v20/custom"

//当前用户 护工信息 GET
#define NURSE TEST@"/v20/nurse"

//当前用户 体能师信息 GET

#define COACH TEST@"/v20/coach"

//总体计划信息  GET
#define STAGE TEST@"/v20/stage"


#define PLAN TEST@"/v20/plan"
//饮食计划 GET

#define DIET TEST@"/v20/plan/diet"

//训练计划信息 GET
#define TRAINING TEST@"/v20/plan/training"

//提交数据图表信息 POST
#define CHECKING TEST@"/v20/checking"

//拉取用户图表信息 GET
#define CHECKING TEST@"/v20/checking"


//获取计划详情
#define PLANSHOW TEST@"/v20/plan/show/%ld"
//获取播放list get
#define PLANLIST TEST@"/v20/plan/play-list/%ld"
//开始使用服务

#define CUSTOM_START @"/v20/custom/start"

//暂停使用服务

#define CUSTOM_PAUSE @"/v20/custom/pause"


/*
 
 //阿里云上传
 **/
#define Get_aliyun_oss_token @"http://apibeta.aircoach.cn/v2/get_aliyun_oss_token?token=%@"

#endif /* Header_h */

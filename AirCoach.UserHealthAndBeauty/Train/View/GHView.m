//
//  GHView.m
//  shouyeDemo
//
//  Created by wei on 16/10/24.
//  Copyright © 2016年 Aircoach. All rights reserved.
//

#import "GHView.h"
#import "UserPlanModel.h"
#import "BusinessAirCoach.h"
#define kGCCardRatio 0.8
#define kGCCardWidth [UIScreen mainScreen].bounds.size.width - 50
#define kGCCardHeight 200
#define CardRatio 254/315 //卡片高度比例
#define PlanImageRatio 185/315 //计划图高度比例

@interface GHView ()

@property(nonatomic,strong) UIScrollView *myscrollview;
@property(nonatomic,strong) NSMutableArray *cards;
@property(nonatomic)NSInteger TotalNumberOfCards;
@property(nonatomic,strong)NSArray *planArr;
@property(nonatomic)NSInteger curPlanNum;//当前计划记录数
@property(nonatomic)NSInteger CardVideoUrl;
@property(nonatomic)NSInteger curIndex;//记录当前计划的位置

@end


@implementation GHView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}
-(void)setup
{
    self.myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(25, 0, kGCCardWidth,(kGCCardWidth - 11) * CardRatio)];
    //self.myscrollview.center = self.center;
    self.myscrollview.showsHorizontalScrollIndicator = NO;
    self.myscrollview.pagingEnabled = YES;
    self.myscrollview.clipsToBounds = NO;
    [self addSubview:self.myscrollview];
    [self.myscrollview setContentOffset:[self contentOffsetWithIndex:0]];
    self.cards = [NSMutableArray array];
    _curIndex = 0;
    _curPlanNum = 0;
    _CardVideoUrl = 0;
}
-(void)loadCard
{
    //重新刷新 删掉页面上的view
    for (UIView *card in self.cards)
    {
        [card removeFromSuperview];
    }
    
    self.TotalNumberOfCards = [self.cardDataSource numberOfCards];
    if (self.TotalNumberOfCards == 0)
    {
        return;
    }
    
    //设置滑动范围和偏移量
    [self.myscrollview setContentSize:CGSizeMake((SCREENWIDTH - 50) * self.TotalNumberOfCards, 0)];
    
    [self.cards removeAllObjects];
    for (int index = 0; index < self.TotalNumberOfCards; index++)
    {
        
        UIView *card = [self.cardDataSource cardReuseView:nil atIndex:index];
        card.center = [self centerForCardWithIndex:index];
        card.tag = index;
        [self.myscrollview addSubview:card];
        [self.cards addObject:card];
        
        [self.cardDataDelegate updateCard:card withProgress:1 direction:CardMoveDirectionNone];
    }
    
    [self reloadCard];
    
}
-(void)reloadCard
{
    
    self.TotalNumberOfCards = [self.cardDataSource numberOfCards];
    self.planArr = [self.cardDataSource contentOfCards];
    for (int index = 0; index < self.TotalNumberOfCards; index++)
    {
        if (self.planArr.count != 0)
        {
            UserPlanModel *planModel = self.planArr[index];
            if (planModel.is_cur == YES)
            {
                _curPlanNum = index;
                
            }
        }
    }
    
    if (self.TotalNumberOfCards == 0 )
    {
        return;
    }
    for (int index = 0; index < self.TotalNumberOfCards; index++)
    {
        UIView *card = self.cards[index];
        UILabel *progressLab = [card viewWithTag:1002];
        UILabel *planName = [card viewWithTag:1003];
        UILabel *planTime = [card viewWithTag:1004];
        UIImageView *cardbackGroud = [card viewWithTag:1001];
        UIImageView *shadowImage = [card viewWithTag:1005];
        UIImageView *lockImage = [card viewWithTag:1006];
        if (self.planArr.count != 0)
        {
            UserPlanModel *planModel = self.planArr[index];
            NSLog(@"-------%@",planModel.backgroud);
            [cardbackGroud sd_setImageWithURL:[NSURL URLWithString:planModel.backgroud] placeholderImage:[UIImage imageNamed:@"加载中"]];
            progressLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)planModel.complete,(long)planModel.total];
            progressLab.hidden = NO;
            shadowImage.hidden = NO;
            planName.text = planModel.name;
            
            //处理开始时间和结束时间 格式为9月1日周四
            NSString *startStr = [NSString stringWithFormat:@"%@日",[self DateChange:planModel.start]];
            NSString *endStr = [NSString stringWithFormat:@"%@日",[self DateChange:planModel.end]];
            NSString *startWeek = [self dateToweek:[BusinessAirCoach jugdeTagTime:[self stringTodate:planModel.start]]];
            NSString *endWeek = [self dateToweek:[BusinessAirCoach jugdeTagTime:[self stringTodate:planModel.end]]];
            
            planTime.text = [NSString stringWithFormat:@"%@·%@ ~ %@·%@",startStr,startWeek,endStr,endWeek];
            
            if (index < _curPlanNum)
            {
                lockImage.hidden = NO;
                lockImage.image = [UIImage imageNamed:@"计划已完成"];
                card.tag = index + 200;
                //加手势
                UITapGestureRecognizer *firTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpPastPlan:)];
                firTap.numberOfTapsRequired = 1;
                firTap.numberOfTouchesRequired = 1;
                [card addGestureRecognizer:firTap];
            }
            else if(index == _curPlanNum)
            {
                //三种情况 第一当前计划处于此阶段第一个计划 第二此阶段没有计划 _curPlanNum都为0 第三种为当前计划 加手势
                lockImage.hidden = YES;
                [UIView animateWithDuration:0.6 animations:^{
                    [self.myscrollview setContentOffset:[self contentOffsetWithIndex:_curPlanNum]];
                }];
                
                
                _CardVideoUrl = planModel.planId;
                //加手势
                UITapGestureRecognizer *firTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpVideo)];
                firTap.numberOfTapsRequired = 1;
                firTap.numberOfTouchesRequired = 1;
                [card addGestureRecognizer:firTap];
                
                //存入当前计划背景图
                [BusinessAirCoach setCruteBackgroudImage:planModel.backgroud];
                if([BusinessAirCoach getPlancurID] == nil)
                {
                   [BusinessAirCoach setcurID:[NSString stringWithFormat:@"%ld",(long)planModel.planId]];
                    [BusinessAirCoach setLastcurID:[NSString stringWithFormat:@"%ld",(long)planModel.planId]];
                }
            }
            else
            {
                lockImage.hidden = NO;
                lockImage.image = [UIImage imageNamed:@"计划未开始"];
                card.tag = index + 200;
                //加手势
                UITapGestureRecognizer *firTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpFuturePlan:)];
                firTap.numberOfTapsRequired = 1;
                firTap.numberOfTouchesRequired = 1;
                [card addGestureRecognizer:firTap];
            }
            
            
        }
        else
        {
            shadowImage.hidden = YES;
            progressLab.hidden = YES;
            cardbackGroud.image = [UIImage imageNamed:@"暂无计划背景图"];
            planName.text = @"暂无训练方案";
            planTime.text = @"护理师正为您定制训练方案，请稍等";
            lockImage.hidden = YES;
            [self.myscrollview setContentOffset:[self contentOffsetWithIndex:0]];
        }
        
        
        
        
        
    }
    //此处要清0,防止下次刷新
    _curPlanNum = 0;

}
-(void)jumpPastPlan:(UITapGestureRecognizer*)tap
{
    UserPlanModel *planModel = self.planArr[tap.view.tag - 200];
    [self.cardDataSource jumpPastPlanAndFuturePlan:planModel.planId type:PlanPast];
}
-(void)jumpFuturePlan:(UITapGestureRecognizer*)tap
{
    UserPlanModel *planModel = self.planArr[tap.view.tag - 200];
    [self.cardDataSource jumpPastPlanAndFuturePlan:planModel.planId type:PlanFutrue];
}
-(void)jumpVideo
{
    [self.cardDataSource jumpTraining:_CardVideoUrl];
}
-(CGPoint)contentOffsetWithIndex:(NSInteger)index
{
    return CGPointMake((SCREENWIDTH - 50) * index, 0);
}

- (CGPoint)centerForCardWithIndex:(NSInteger)index {
 //中心坐标为scroll宽度的一半
    return CGPointMake((SCREENWIDTH - 50)*(index + 0.5), self.myscrollview.center.y);
}
//处理时间格式
-(NSString*)dateToweek:(NSInteger)date
{
    NSString *weekDayStr = nil;
    switch (date) {
        case 1:
            weekDayStr = @"周日";
            break;
        case 2:
            weekDayStr = @"周一";
            break;
        case 3:
            weekDayStr = @"周二";
            break;
        case 4:
            weekDayStr = @"周三";
            break;
        case 5:
            weekDayStr = @"周四";
            break;
        case 6:
            weekDayStr = @"周五";
            break;
        case 7:
            weekDayStr = @"周六";
            break;
        default:break;
    }
    return weekDayStr;
}
-(NSDate*)stringTodate:(NSString*)str
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:str];
    return inputDate;
}
-(NSString*)DateChange:(NSString*)startAndEndTime
{
    NSString *changeDate = nil;
    if (startAndEndTime.length == 0)
    {
        
    }
    else
    {
        changeDate = [startAndEndTime substringFromIndex:5];
        changeDate = [changeDate stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    }
    return changeDate;
}




@end

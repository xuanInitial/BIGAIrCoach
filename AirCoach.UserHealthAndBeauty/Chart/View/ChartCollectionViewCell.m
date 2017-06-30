//
//  ChartCollectionViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/3.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "ChartCollectionViewCell.h"
#import "UUChart.h"

@interface ChartCollectionViewCell()<UUChartDataSource>
{
    NSIndexPath *path;
    UUChart *chartview;
    NSInteger month;
    NSInteger day;
    NSInteger year;
    NSDate *date;
    NSInteger presentMonth;
}
@end


@implementation ChartCollectionViewCell



//图表初始化
-(void)configUI:(NSIndexPath *)indexPath
{
    if (chartview)
    {
        [chartview removeFromSuperview];
        chartview = nil;
    }
    path = indexPath;
    
    chartview = [[UUChart alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 10, 310 + 124) dataSource:self style: UUChartStyleLine Path:path];
    chartview.backgroundColor = [UIColor clearColor];
    [chartview showInView:self.contentView];
    
    
}
-(NSDate *)BeijngTime:(NSDate*)firstDate
{
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:firstDate];
    NSDate *localeDate = [firstDate dateByAddingTimeInterval:interval];
    LRLog(@"%@", localeDate);
    return localeDate;
    
}
//x轴数据数组
-(NSArray *)getXtitles:(int)num
{
    NSString *str = [BusinessAirCoach getStartTime];

    //需要转换的字符串
    NSString *dateString = str;
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    
    
    //计算日期差值
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval timeNow = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *dateNow = [[NSDate date] dateByAddingTimeInterval:timeNow];
    NSTimeInterval timefir = [zone secondsFromGMTForDate:date];
    NSDate *datefir = [date dateByAddingTimeInterval:timefir];
    
    
    //计算天数、时、分、秒
    NSDateComponents *d1 = [cal components:unitFlags fromDate:date];
    month = [d1 month];
    day = [d1 day];
    year = [d1 year];
    
    //天数分隔
    NSDateComponents *d = [cal components:unitFlags fromDate:datefir toDate:dateNow options:0];
    NSInteger daysss = [d day] + [d month] * 30 + [d year] * 360;

    NSTimeInterval time = [[self BeijngTime:[NSDate date]] timeIntervalSinceDate:[self BeijngTime:date]];
    NSInteger days = time /(3600 * 24);
    if (daysss >= 1 && days < 1)
    {
        days = days + 1;
    }
 
    LRLog(@"-----%@",[self BeijngTime:[NSDate date]]);
    LRLog(@"%ld/%ld",(long)month,(long)day);
    presentMonth = month;
    
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i = 0; i < days + 1; i++)
    {
        NSString *str = nil;
        
        //月份判断
        if (presentMonth == 1||presentMonth == 3||presentMonth == 5||presentMonth == 7||presentMonth == 8||presentMonth == 10||presentMonth == 12) {
           //31天的情况
            if (day == 1 && presentMonth == month)
            {
               //当月的1号
                str = [NSString stringWithFormat:@"%ld/%ld",(long)presentMonth,(long)day];
                day += 1;
            }
            else if(day == 31)
            {
                str = [NSString stringWithFormat:@"%ld/%ld",(long)presentMonth,(long)day];
                presentMonth += 1;
                if (presentMonth > 12)
                {
                    presentMonth = 1;
                    year++;
                }
                day = 1;
            }
            else
            {
               str = [NSString stringWithFormat:@"%ld/%ld",(long)presentMonth,(long)day];
               day += 1;
            }
            
            
            
        }
        else if (presentMonth == 2)
        {
            //28天的情况
            if (day == 1 && presentMonth == month)
            {
                //当月的1号
                str = [NSString stringWithFormat:@"%ld/%ld",(long)presentMonth,(long)day];
                day += 1;
            }
            else if(day == 28)
            {
                str = [NSString stringWithFormat:@"%ld/%ld",(long)presentMonth,(long)day];
                
                if ((year%4==0 && year %100 !=0) || year%400==0)
                {
                    day++;
                }else
                {
                 presentMonth += 1;
                 day = 1;
                }
            }
            else if (day == 29)
            {
               str = [NSString stringWithFormat:@"%ld/%ld",(long)presentMonth,(long)day];
               presentMonth += 1;
               day = 1;
            }
            else
            {
                str = [NSString stringWithFormat:@"%ld/%ld",(long)presentMonth,(long)day];
                day += 1;
            }
 
        }
        else
        {
            //30天的情况
            if (day == 1 && presentMonth == month)
            {
                //当月的1号
                str = [NSString stringWithFormat:@"%ld/%ld",(long)presentMonth,(long)day];
                day += 1;
            }
            else if(day == 30)
            {
                str = [NSString stringWithFormat:@"%ld/%ld",(long)presentMonth,(long)day];
                presentMonth += 1;
                day = 1;
            }
            else
            {
                str = [NSString stringWithFormat:@"%ld/%ld",(long)presentMonth,(long)day];
                day += 1;
            }
 
        }
        
        
        
        
        [xTitles addObject:str];
        
        
    }
    
    return xTitles;
}
-(void)setCollectCellArr:(NSArray *)CollectCellArr
{
    _CollectCellArr = CollectCellArr;
}
-(void)setCellXArr:(NSArray *)CellXArr
{
    _CellXArr = CellXArr;
}
#pragma mark -@required
//横坐标标题数组
-(NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    return [self getXtitles:18];
}
//纵坐标标题数组
-(NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    return self.CellXArr;
}
-(NSArray *)chartConfigAxisXValue:(UUChart *)chart
{
    return self.CollectCellArr;
}
#pragma mark -@optional
//颜色数组
-(NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[[UUColor green],[UUColor red],[UUColor brown]];
}
//显示数据范围
-(CGRange)chartRange:(UUChart *)chart
{
    return CGRangeMake(60, 10);
}
#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
{
        return CGRangeMake(25, 75);

  
}

//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}
//显示最大值和最小值
-(BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index
{
    return YES;
}



@end

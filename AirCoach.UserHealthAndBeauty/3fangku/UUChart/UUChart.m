//
//  UUChart.m
//  UUChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUChart.h"

@interface UUChart ()

@property (strong, nonatomic) UULineChart * lineChart;



@property (assign, nonatomic) id<UUChartDataSource> dataSource;

@end

@implementation UUChart

- (id)initWithFrame:(CGRect)rect dataSource:(id<UUChartDataSource>)dataSource style:(UUChartStyle)style Path:(NSIndexPath *)path
{
    self.dataSource = dataSource;
    self.chartStyle = style;
    self.Mypath = path;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)setUpChart{
	if (self.chartStyle == UUChartStyleLine) {
        if(!_lineChart){
            _lineChart = [[UULineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_lineChart];
        }
        //选择标记范围
        if ([self.dataSource respondsToSelector:@selector(chartHighlightRangeInLine:)]) {
            [_lineChart setMarkRange:[self.dataSource chartHighlightRangeInLine:self]];
        }
        //选择显示范围
        if ([self.dataSource respondsToSelector:@selector(chartRange:)]) {
            [_lineChart setChooseRange:[self.dataSource chartRange:self]];
        }
        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(chartConfigColors:)]) {
            [_lineChart setColors:[self.dataSource chartConfigColors:self]];
        }
//        //显示横线 为了柱状图服务 我们这里只用折线图 
//        if ([self.dataSource respondsToSelector:@selector(chart:showHorizonLineAtIndex:)]) {
//            NSMutableArray *showHorizonArray = [[NSMutableArray alloc]init];
//            for (int i=0; i<5; i++) {
//                if ([self.dataSource chart:self showHorizonLineAtIndex:i]) {
//                    [showHorizonArray addObject:@"1"];
//                }else{
//                    [showHorizonArray addObject:@"0"];
//                }
//            }
//            [_lineChart setShowHorizonLine:showHorizonArray];
//
//        }
        //判断显示最大最小值
//        if ([self.dataSource respondsToSelector:@selector(chart:showMaxMinAtIndex:)]) {
//            NSMutableArray *showMaxMinArray = [[NSMutableArray alloc]init];
//            NSArray *y_values = [self.dataSource chartConfigAxisYValue:self];
//            if (y_values.count>0){
//                for (int i=0; i<y_values.count; i++) {
//                    if ([self.dataSource chart:self showMaxMinAtIndex:i]) {
//                        [showMaxMinArray addObject:@"1"];
//                    }else{
//                        [showMaxMinArray addObject:@"0"];
//                    }
//                }
//                _lineChart.showMaxMinArray = showMaxMinArray;
//            }
//        }
        _lineChart.cellPath = self.Mypath;
        //x,y轴的数组
        
        [_lineChart setXLabels:[self.dataSource chartConfigAxisXLabel:self]];//日期的数组
		[_lineChart setYValues:[self.dataSource chartConfigAxisYValue:self]];//体侧数据实际值
        [_lineChart setXValues:[self.dataSource chartConfigAxisXValue:self]];//时间间隔
		[_lineChart strokeChart];

	}
}

- (void)showInView:(UIView *)view
{
    [self setUpChart];
    [view addSubview:self];
}

-(void)strokeChart
{
	[self setUpChart];
	
}



@end

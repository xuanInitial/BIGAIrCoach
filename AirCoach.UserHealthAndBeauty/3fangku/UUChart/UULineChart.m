//
//  UULineChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UULineChart.h"
#import "UUChartConst.h"
#import "UUChartLabel.h"
#import "Header.h"
@interface UULineChart()

@property(nonatomic)NSInteger index;
@property(nonatomic)NSInteger TheSame;
@property(nonatomic)NSInteger DataRow;
//没有数据时的y轴分类数组
@property(nonatomic,strong)NSArray *yArr;
@end

@implementation UULineChart {
    NSHashTable *_chartLabelsForX;
    UIScrollView *myScrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, SCREENWIDTH-UUYLabelwidth, frame.size.height)];
        myScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}
-(void)setXValues:(NSArray *)xValues
{
    _xValues = xValues;
}
-(void)setCellPath:(NSIndexPath *)cellPath
{
    _cellPath = cellPath;
}
-(void)setYLabels:(NSArray *)yLabels
{
    _yLabels = yLabels;
    double max = 0;
    double min = 1000000000;
    NSInteger grade = 0;
    if (self.cellPath.row == 0 || self.cellPath.row == 3)
    {
        grade = 6;
    }
    else
    {
        grade = 10;
    }
    
   
    
    //看清数据
    if (yLabels.count == 1)
    {
        NSString  *str = yLabels[0];
        
        _yArr = @[[NSString stringWithFormat:@"%d",str.integerValue - 1 *(grade / 2) - 2 * grade],
                     [NSString stringWithFormat:@"%d",str.integerValue - 1 *(grade / 2) - 1 * grade],
                     [NSString stringWithFormat:@"%d",str.integerValue - 1 *(grade / 2)],
                     [NSString stringWithFormat:@"%d",str.integerValue + 1 *(grade / 2)],
                     [NSString stringWithFormat:@"%d",str.integerValue + 1 *(grade / 2) + 1 * grade],
                     [NSString stringWithFormat:@"%d",str.integerValue + 1 *(grade / 2) + 2 * grade]
                     ];
        NSLog(@"%@",_yLabels);
        _DataRow = 2;
  
    }
    else if (yLabels.count >= 2)
    {
        NSString  *str = yLabels[0];
        for (NSString *sed in yLabels)
        {
            if (![[NSString stringWithFormat:@"%@",str] isEqual:[NSString stringWithFormat:@"%@",sed]])
            {
                NSLog(@"有个元素不相同");
                _TheSame = 1;
               break;
            }
        }
        if (_TheSame == 1)
        {
            NSLog(@"元素不相同,最少两个不同的");
            //_TheSame = 0;
        }
        else
        {
            _yArr = @[[NSString stringWithFormat:@"%d",str.integerValue - 1 *(grade / 2) - 2 * grade],
                         [NSString stringWithFormat:@"%d",str.integerValue - 1 *(grade / 2) - 1 * grade],
                         [NSString stringWithFormat:@"%d",str.integerValue - 1 *(grade / 2)],
                         [NSString stringWithFormat:@"%d",str.integerValue + 1 *(grade / 2)],
                         [NSString stringWithFormat:@"%d",str.integerValue + 1 *(grade / 2) + 1 * grade],
                         [NSString stringWithFormat:@"%d",str.integerValue + 1 *(grade / 2) + 2 * grade]];
            _DataRow = 2;
        }
    }
    else
    {
        _DataRow = 3;
        if (self.cellPath.row == 0)
        {
            //体重
            _yArr = @[[NSString stringWithFormat:@"%d",40],
                         [NSString stringWithFormat:@"%d",48],
                         [NSString stringWithFormat:@"%d",56],
                         [NSString stringWithFormat:@"%d",64],
                         [NSString stringWithFormat:@"%d",72],
                         [NSString stringWithFormat:@"%d",80]];
 
        }
        else if(self.cellPath.row == 1)
        {
            //平静心率
            _yArr = @[[NSString stringWithFormat:@"%d",0],
                         [NSString stringWithFormat:@"%d",24],
                         [NSString stringWithFormat:@"%d",48],
                         [NSString stringWithFormat:@"%d",72],
                         [NSString stringWithFormat:@"%d",96],
                         [NSString stringWithFormat:@"%d",120]];
        }
        else if (self.cellPath.row == 2)
        {
            //屏息时间
            _yArr = @[[NSString stringWithFormat:@"%d",30],
                         [NSString stringWithFormat:@"%d",42],
                         [NSString stringWithFormat:@"%d",54],
                         [NSString stringWithFormat:@"%d",66],
                         [NSString stringWithFormat:@"%d",78],
                         [NSString stringWithFormat:@"%d",90]];
        }
        else
        {
            //仰卧起坐
            _yArr = @[[NSString stringWithFormat:@"%d",0],
                         [NSString stringWithFormat:@"%d",10],
                         [NSString stringWithFormat:@"%d",20],
                         [NSString stringWithFormat:@"%d",30],
                         [NSString stringWithFormat:@"%d",40],
                         [NSString stringWithFormat:@"%d",50]];
        }
            
        
        
    }
    
    for (NSString * valueString in _yLabels) {
            double value = [valueString doubleValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
    
    }
    _yValueMin = (double)min;
    _yValueMax = (double)max;
    
    
    
    
    //y轴的刻度计算
    double level = 0;
    int Danlevel = 0;
    
    
    if (_DataRow == 3)
    {
       //没有数据
        switch (self.cellPath.row) {
            case 0:
                level = 6;
                break;
            case 1:
                Danlevel = 24;
                break;
            case 2:
                Danlevel = 12;
                break;
            case 3:
                Danlevel = 10;
                break;
            default:
                break;
        }
        
    }
    else if (_DataRow == 2)
    {
       //所有数据一样 或者一个数据
        if (self.cellPath.row == 0)
        {
            _yValueMin = [[_yArr firstObject] doubleValue];
            _yValueMax = [[_yArr lastObject] doubleValue];
        }
        else
        {
            _yValueMin = [[_yArr firstObject] intValue];
            _yValueMax = [[_yArr lastObject] intValue];
        }

    }
    else
    {
     level = (_yValueMax-_yValueMin) /5.0 + 0.1;
     if (self.cellPath.row != 0)
     {
       Danlevel = (int)(_yValueMax-_yValueMin) /5.0 + 1;
     }
    }
    //网格总高度
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*5;
    //小网格高度
    CGFloat levelHeight = chartCavanHeight / 7.0;

    //y轴刻度的标签
    for (int i=0; i<6; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-(i + 1)*levelHeight+5, UUYLabelwidth, UULabelHeight)];
        if (self.cellPath.row == 0)
        {
            if (_DataRow == 2||_DataRow == 3)
            {
               label.text = _yArr[i];
                _yNormal =[_yArr[i] doubleValue];
            }
            else
            {
               label.text = [NSString stringWithFormat:@"%.1f",(double)(level * i+_yValueMin)];
               _yNormal = level * i + _yValueMin;
            }
        }
        else
        {
            if (_DataRow == 2||_DataRow == 3)
            {
               label.text = _yArr[i];
               _yNormal =[_yArr[i] doubleValue];
            }
            else
            {
              label.text = [NSString stringWithFormat:@"%d",(int)(Danlevel * i+_yValueMin)];
              _yNormal = Danlevel * i + _yValueMin;
            }
        }
        
        label.textColor = XYLableColor;
        label.font = [UIFont systemFontOfSize:12];
        NSLog(@"%@",label.text);
		[self addSubview:label];
    }

    NSLog(@"--------%ld",(unsigned long)self.xLabels.count);
    //画方格横线
    CGFloat MyJuli = 0;
    for (int i=1; i < 8; i++) {
        
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0,UULabelHeight+i*levelHeight)];
        if (self.xLabels.count * 42 < SCREENWIDTH - UUYLabelwidth - 15)
        {
            MyJuli = SCREENWIDTH - UUYLabelwidth - 15;
        }
        else
        {
            MyJuli = self.xLabels.count * 42;
        }
            [path addLineToPoint:CGPointMake(MyJuli,UULabelHeight+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
        if (i == 7)
        {
            shapeLayer.strokeColor = [XYLineColor CGColor];
        }
        else
        {
            shapeLayer.strokeColor = [HorLinecolor CGColor];
        }
            shapeLayer.lineWidth = 1;
            [myScrollView.layer addSublayer:shapeLayer];
        
    }
    
    
}

-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xLabels = xLabels;
    CGFloat num = 0;
    num = xLabels.count;
    
    //_xLabelWidth = (self.frame.size.width - UUYLabelwidth)/num;
    _xLabelWidth = 42;
    for (int i=0; i < xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth + _xLabelWidth / 2, self.frame.size.height - UULabelHeight * 3, _xLabelWidth, UULabelHeight)];
        label.text = labelText;
        NSString *str = [self.xValues lastObject];
        NSLog(@"----%@",str);
        label.textColor = XYLableColor;
        label.font = [UIFont systemFontOfSize:12];
        [myScrollView addSubview:label];
        
        [_chartLabelsForX addObject:label];
    }
    
    UIView *yView = [[UIView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 10, 1, self.frame.size.height-5*UULabelHeight)];
    yView.backgroundColor = XYLineColor;
    [self addSubview:yView];
   
    
    myScrollView.contentSize = CGSizeMake(_xLabels.count * _xLabelWidth + _xLabelWidth / 2 + 5, 0);
    
    

}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setshowHorizonLine:(NSMutableArray *)showHorizonLine
{
    _showHorizonLine = showHorizonLine;
}


-(void)strokeChart
{
    _index = 0;
    if (self.xValues.count != 0&&self.yValues.count != 0)
    {
        NSString *singlValue = self.xValues[0];
        CGFloat xPosition = singlValue.integerValue * (_xLabelWidth) + _xLabelWidth;
        //scrollview移动的距离
        CGFloat scrollViewOff = 0.0;
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [SegementColor CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [myScrollView.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        NSString *strfirst = _yValues[0];
        CGFloat firstValue = [strfirst floatValue];
        //网格总高度
        CGFloat chartCavanHeight1 = self.frame.size.height - UULabelHeight*5;
        //小网格高度
        CGFloat levelHeight = chartCavanHeight1 / 7.0;
        CGFloat chartCavanHeight = myScrollView.frame.size.height - UULabelHeight * 5 -  2 * levelHeight;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yNormal-_yValueMin);
        NSLog(@"%lf",grade);
        //第一个点
        NSLog(@"%lf",chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight + levelHeight)
                 index:0
                isShow:NO
                 value:firstValue];
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight + levelHeight)];
        
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        if (grade == 0)
        {
            [self addSuperView:myScrollView MoveToxPoint:xPosition MoveToyPoint:chartCavanHeight - grade * chartCavanHeight+UULabelHeight + levelHeight + 3 AddLinexPoint:xPosition AddLineyPoint:self.frame.size.height-4*UULabelHeight isMinValue:YES];
        }
        else
        {
            [self addSuperView:myScrollView MoveToxPoint:xPosition MoveToyPoint:chartCavanHeight - grade * chartCavanHeight+UULabelHeight +levelHeight + 3 AddLinexPoint:xPosition AddLineyPoint:self.frame.size.height-4*UULabelHeight isMinValue:NO];
        }
        
        
        
        
        for (int i=0; i<_yValues.count; i++) {
            
            if (i != 0) {
                NSString *str = _yValues[i];
                CGFloat firstValue = [str floatValue];
                float grade = ((float)firstValue-_yValueMin) / ((float)_yNormal-_yValueMin);
                NSString *singlValue = self.xValues[i];
                
                //scrollview移动的距离
                scrollViewOff = singlValue.integerValue * _xLabelWidth + _xLabelWidth;
               
                
                CGPoint point = CGPointMake(singlValue.integerValue * _xLabelWidth + _xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight + levelHeight);
                
                [progressline addLineToPoint:point];
                
                if (i == _yValues.count - 1)
                {
                    [self addPoint:point
                             index:i
                            isShow:YES
                             value:[str floatValue]];
                }
                else
                {
                    
                    [self addPoint:point
                             index:i
                            isShow:NO
                             value:[str floatValue]];
                }
                [progressline moveToPoint:point];
                
                if (grade == 0)
                {
                    NSLog(@"起点y值%f",point.y + 3);
                    NSLog(@"划线的y值",self.frame.size.height-4*UULabelHeight);
                    [self addSuperView:myScrollView MoveToxPoint:point.x MoveToyPoint:point.y + 3 AddLinexPoint:singlValue.integerValue * _xLabelWidth + _xLabelWidth AddLineyPoint:self.frame.size.height-4*UULabelHeight isMinValue:YES];
                }
                else
                {
                    [self addSuperView:myScrollView MoveToxPoint:point.x MoveToyPoint:point.y + 3 AddLinexPoint:singlValue.integerValue * _xLabelWidth + _xLabelWidth AddLineyPoint:self.frame.size.height-4*UULabelHeight isMinValue:NO];
                }
                
                
                
                
            }
            if ([WYTDevicesTool iPhone5_iPhone5s_iPhone5c])
            {
                if (scrollViewOff <= 6 *_xLabelWidth)
                {
                    
                }
                else
                {
                    [myScrollView setContentOffset:CGPointMake(scrollViewOff - 6 *42, 0)];
                }
            }
            else if ([WYTDevicesTool iPhone6_iPhone6s])
            {
                if (scrollViewOff <= 7 *_xLabelWidth)
                {
                    
                }
                else
                {
                    [myScrollView setContentOffset:CGPointMake(scrollViewOff - 7 *42, 0)];
                }
            }
            else
            {
                if (scrollViewOff <= 8 *_xLabelWidth)
                {
                    
                }
                else
                {
                    [myScrollView setContentOffset:CGPointMake(scrollViewOff - 8 *42, 0)];
                }
            }
           
            _chartLine.path = progressline.CGPath;
            _chartLine.strokeColor = [UIColor redColor].CGColor;
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 0.2;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            pathAnimation.autoreverses = NO;
            [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            _chartLine.strokeEnd = 1.0;
            
            NSLog(@"一屏的偏移量%lf",myScrollView.contentOffset.x);
            
        }
    }else
    {
        
    }
    
}
-(void)addSuperView:(UIScrollView*)scoll MoveToxPoint:(CGFloat)x MoveToyPoint:(CGFloat)y AddLinexPoint:(CGFloat)x1 AddLineyPoint:(CGFloat)y1 isMinValue:(BOOL)isMin
{
    
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    [shapelayer setFillColor:[HorLinecolor CGColor]];
    [shapelayer setStrokeColor:[HorLinecolor CGColor]];
    [shapelayer setLineWidth:1];
    [shapelayer setLineJoin:kCALineJoinRound];
    [shapelayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1], nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x, y);
    CGPathAddLineToPoint(path, NULL, x1, y1);
    [shapelayer setPath:path];
    CGPathRelease(path);
    [self.layer addSublayer:shapelayer];
    [scoll.layer addSublayer:shapelayer];
    
    
    
}
- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    //圆圈
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 2;
    view.layer.borderColor = SegementColor.CGColor;
    if (isHollow) {
        view.backgroundColor = SegementColor;
    }else{
        view.backgroundColor = [UIColor whiteColor];
        }
    //标签
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    if (isHollow) {
        label.textColor = SegementColor;
    }else{
        label.textColor = LableColor;;
    }
    
    label.font = [UIFont systemFontOfSize:12];
    if (self.cellPath.row == 0)
    {
       label.text = [NSString stringWithFormat:@"%.1f",(double)value];
    }
    else
    {
       label.text = [NSString stringWithFormat:@"%d",(int)value];
    }
    [myScrollView addSubview:label];

    [myScrollView addSubview:view];
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end

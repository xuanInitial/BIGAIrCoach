//
//  detailHeader.m
//  Orderdemo
//
//  Created by wei on 16/5/26.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "detailHeader.h"

@implementation detailHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissBtn.frame = CGRectMake(320 - 30, 10, 20, 20);
        _dismissBtn.backgroundColor = [UIColor redColor];
        _dismissBtn.tag = 1000;
        [self addSubview:_dismissBtn];
        
        //时间标签
        UILabel *mylabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 320, 20)];
        mylabel.text = @"用户名线下服务反馈";
        mylabel.font = [UIFont systemFontOfSize:18];
        mylabel.textColor = [UIColor lightGrayColor];
        [self addSubview:mylabel];
        
        
        //时间
        UILabel *theTime = [[UILabel alloc]initWithFrame:CGRectMake(10, mylabel.frame.origin.y + 30, 150, 13)];
        theTime.text = @"时间:2016年9月16日";
        theTime.textColor = [UIColor blackColor];
        theTime.font = [UIFont systemFontOfSize:13];
        [self addSubview:theTime];
        
        //地点
        UILabel *didian = [[UILabel alloc]initWithFrame:CGRectMake(10, theTime.frame.origin.y + 18, 200, 13)];
        didian.text = @"地点:北京市丰台区郭公庄幸福家园";
        didian.textColor = [UIColor blackColor];
        didian.font = [UIFont systemFontOfSize:13];
        [self addSubview:didian];
        
        //地点
        UILabel *jishi = [[UILabel alloc]initWithFrame:CGRectMake(10, didian.frame.origin.y + 18, 150, 13)];
        jishi.text = @"提供服务的训练师:位大勇";
        jishi.textColor = [UIColor blackColor];
        jishi.font = [UIFont systemFontOfSize:13];
        [self addSubview:jishi];
        
        //头像
        UIImageView *headeView = [[UIImageView alloc]initWithFrame:CGRectMake(320 - 110, 45, 80, 80)];
        headeView.layer.cornerRadius = 40;
        headeView.layer.masksToBounds = YES;
        headeView.image = [UIImage imageNamed:@"1.jpg"];
        [self addSubview:headeView];
        
        
        UIView *linview = [[UIView alloc]initWithFrame:CGRectMake(10, jishi.frame.origin.y + 38, 320 - 20, 1)];
        linview.backgroundColor = [UIColor grayColor];
        [self addSubview:linview];
        
       
        
        
        
    }
    return self;
}

@end

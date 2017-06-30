//
//  UIView+CTOpenView.m
//  AirCoach2.0
//
//  Created by wei on 16/3/3.
//  Copyright © 2016年 高静. All rights reserved.
//

#import "UIView+CTOpenView.h"

@implementation UIView (CTOpenView)
+(UIView*)ViewWithFrameByCategory:(CGRect)frame MianView:(UIView *)mainView Detail:(NSString *)detail MainItem:(NSString *)item LeftBtn:(NSString *)leftbtn RightBtn:(NSString *)rightbtn
{
    CGSize titleSize = [detail sizeWithFont: [UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(110, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    // CGSize titleSize = [detail boundingRectWithSize:CGSizeMake(110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    NSLog(@"%lf",titleSize.height);
    //灰度蒙板
    UIView *PickView = [[UIView alloc]init];
    PickView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [mainView addSubview:PickView];
    [mainView bringSubviewToFront:PickView];
    [PickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView);
        make.bottom.equalTo(mainView);
        make.left.equalTo(mainView);
        make.right.equalTo(mainView);
    }];
    
    
    UIView *view1 = [[UIView alloc]init];
    [PickView addSubview:view1];
    if(titleSize.height > 133)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(PickView.mas_centerX);
            make.centerY.equalTo(PickView.mas_centerY);
            make.height.equalTo(@(titleSize.height - 60 + 141));
            make.width.equalTo(@(SCREENWIDTH - 60));
        }];
        
    }
    else if (titleSize.height > 33 && titleSize.height < 66)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(PickView.mas_centerX);
            make.centerY.equalTo(PickView.mas_centerY);
            make.height.equalTo(@(titleSize.height - 30 + 141));
            make.width.equalTo(@(SCREENWIDTH - 60));
        }];
        
    }
    else if (titleSize.height > 66 && titleSize.height < 83)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(PickView.mas_centerX);
            make.centerY.equalTo(PickView.mas_centerY);
            make.height.equalTo(@(titleSize.height - 20 + 141));
            make.width.equalTo(@(SCREENWIDTH - 60));
        }];
        
    }
    else if (titleSize.height > 83 && titleSize.height < 133)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(PickView.mas_centerX);
            make.centerY.equalTo(PickView.mas_centerY);
            make.height.equalTo(@(titleSize.height - 40 + 141));
            make.width.equalTo(@(SCREENWIDTH - 60));
        }];
        
    }
    else
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(PickView.mas_centerX);
            make.centerY.equalTo(PickView.mas_centerY);
            make.height.equalTo(@(titleSize.height + 5 + 123));
            make.width.equalTo(@(SCREENWIDTH - 60));
        }];
        
    }
    
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.cornerRadius = 5;
    view1.layer.masksToBounds = YES;
    
    UILabel *Item = [[UILabel alloc]init];
    Item.text = item;
    [view1 addSubview:Item];
    [Item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_top).offset(26);
        make.left.equalTo(view1.mas_left).offset(10);
        make.right.equalTo(view1.mas_right).offset(-10);
        make.height.equalTo(@18);
    }];
    //文字居中
    Item.textAlignment = 1;
    Item.textColor = MessageBlock;
    //字体加粗
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    Item.font = font;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = detail;
    [view1 addSubview:label];
    if(titleSize.height > 133)
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Item.mas_bottom).offset(16);
            make.left.equalTo(view1.mas_left).offset(20);
            make.right.equalTo(view1.mas_right).offset(-20);
            make.height.equalTo(@(titleSize.height-60));
        }];
    }
    else if (titleSize.height > 33 && titleSize.height < 66)
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Item.mas_bottom).offset(16);
            make.left.equalTo(view1.mas_left).offset(20);
            make.right.equalTo(view1.mas_right).offset(-20);
            make.height.equalTo(@(titleSize.height-18));
        }];
    }
    else if (titleSize.height > 66 && titleSize.height < 83)
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Item.mas_bottom).offset(16);
            make.left.equalTo(view1.mas_left).offset(20);
            make.right.equalTo(view1.mas_right).offset(-20);
            make.height.equalTo(@(titleSize.height - 30));
        }];
    }
    else if (titleSize.height > 83 && titleSize.height < 133)
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Item.mas_bottom).offset(16);
            make.left.equalTo(view1.mas_left).offset(20);
            make.right.equalTo(view1.mas_right).offset(-20);
            make.height.equalTo(@(titleSize.height-40));
        }];
    }
    else
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Item.mas_bottom).offset(16);
            make.left.equalTo(view1.mas_left).offset(20);
            make.right.equalTo(view1.mas_right).offset(-20);
            make.height.equalTo(@(titleSize.height + 5));
        }];
    }
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = 1;
    label.textColor = MessageBlock;
    label.numberOfLines = 0;
    //label.backgroundColor = [UIColor redColor];
    //下部两个按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:leftbtn forState:UIControlStateNormal];
    //[btn1 setBackgroundColor:[UIColor orangeColor]];
   // [btn1 setBackgroundImage:[UIImage imageNamed:@"确定-按钮"] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:ZhuYao];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:rightbtn forState:UIControlStateNormal];
    //[btn2 setBackgroundColor:[UIColor grayColor]];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"修改-按钮"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [view1 addSubview:btn1];
    [view1 addSubview:btn2];
    btn1.tag = 100;
    btn2.tag = 200;
    CGFloat juli = ((SCREENWIDTH - 60) - 225)/ 2;
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_left).offset(juli);
        make.top.equalTo(label.mas_bottom).offset(22);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view1.mas_right).offset(-juli);
        make.top.equalTo(label.mas_bottom).offset(22);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    
    return PickView;
    
}
@end

//
//  UIView+CTOpenView.h
//  AirCoach2.0
//
//  Created by wei on 16/3/3.
//  Copyright © 2016年 高静. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "Header.h"
@interface UIView (CTOpenView)
+ (UIView *)ViewWithFrameByCategory:(CGRect)frame MianView:(UIView*)mainView Detail:(NSString*)detail MainItem:(NSString*)item LeftBtn:(NSString*)leftbtn RightBtn:(NSString*)rightbtn;
//@property(nonatomic,strong)UIButton *btn1;
//@property(nonatomic,strong)UIButton *btn2;
@end

//
//  PlanHeaderView.h
//  Orderdemo
//
//  Created by wei on 16/5/26.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanModel.h"
#import "Header.h"
#import "UIView+XMGExtension.h"
#import "BusinessAirCoach.h"
#import "StageModel.h"
#import "Masonry.h"
#import "UIControl+BlocksKit.h"
#import "OpenModel.h"
#import "UILabel+TopAndBottom.h"
@protocol HeaderViewDelegate <NSObject>

@optional
//- (void)clickView:(NSIndexSet *)indexSet;
-(void)clickView;
@end


@interface PlanHeaderView : UITableViewHeaderFooterView
@property(nonatomic,strong)StageModel *planHeader;
@property(nonatomic)NSInteger Itemsection;
@property(nonatomic,assign)id<HeaderViewDelegate> delegate;
@property(nonatomic,strong) UILabel *jieduan;
@property(nonatomic)CGFloat lableheight;
@property(nonatomic)CGFloat addlableheight;
@property(nonatomic)CGFloat labley;

@property(nonatomic,strong)UILabel *mylabel;
@property(nonatomic,strong)UILabel *detali;
@property(nonatomic,strong)UILabel *StageStatus;
@property(nonatomic,strong)UIImageView *StageBackImage;
@property(nonatomic,strong)UILabel *order;

@property(nonatomic,strong)UIView *bottomLine;
@property(nonatomic,strong)UIImageView *openBtn;
@property(nonatomic,strong)UIView *smallView;
@property(nonatomic,strong)UIView *MyshuView;
@property(nonatomic,strong)NSIndexSet *indexSet;
@property(nonatomic,strong)OpenModel *OpenModel;


+ (instancetype)headerView:(UITableView *)tableView;


@end

//
//  PlanHeaderView.m
//  Orderdemo
//
//  Created by wei on 16/5/26.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "PlanHeaderView.h"

@implementation PlanHeaderView
+ (instancetype)headerView:(UITableView *)tableView{
    static NSString *identifier = @"header";
    PlanHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
      header = [[PlanHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    return header;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
     if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
         self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
         
         
         //底部白底
         _smallView = [UIView new];
         _smallView.backgroundColor = [UIColor whiteColor];
         _smallView.frame = CGRectMake(0, 11, SCREENWIDTH, 70);
         [self addSubview:_smallView];
         
         //左侧阶段图片
         _StageBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 22, 26, 26)];
         [_smallView addSubview:_StageBackImage];
         
         //阶段字段
         _jieduan = [[UILabel alloc]initWithFrame:CGRectMake(53, 16, SCREENWIDTH - 100, 16)];
         _jieduan.textColor = Subcolor;
         _jieduan.text = @"阶段1";
         //字体加粗
         
         _jieduan.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
         [_smallView addSubview:_jieduan];
         
         
         //时间标签
         _mylabel = [[UILabel alloc]initWithFrame:CGRectMake(53, 43, SCREENWIDTH - 100, 12)];
         _mylabel.font = [UIFont systemFontOfSize:12];
         _mylabel.textColor = LableColor;
         [_smallView addSubview:_mylabel];

         //目标文本
         _detali = [[UILabel alloc]initWithFrame:CGRectMake(15, _mylabel.y + 25, SCREENWIDTH - 30, 100)];
         [_smallView addSubview:_detali];
         [_detali setNumberOfLines:0];
         
         _detali.font = [UIFont systemFontOfSize:14];
         _detali.textAlignment = 0;
         _detali.textColor = Subcolor;
         _detali.hidden = YES;
         
         LRLog(@"%lf",_smallView.height);
        // self.frame = CGRectMake(0, 0, SCREENWIDTH, _smallView.height + 11);
        // self.backgroundColor = [UIColor redColor];
         
         //收起和隐藏按钮
         UIButton *MyopenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         [_smallView addSubview:MyopenBtn];
         [MyopenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(_smallView.mas_right);
             make.left.equalTo(_smallView.mas_left);
             make.top.equalTo(_smallView.mas_top);
             make.bottom.equalTo(_smallView.mas_bottom);
         }];
         MyopenBtn.backgroundColor = [UIColor clearColor];
         [MyopenBtn addTarget:self action:@selector(singleTip:) forControlEvents:UIControlEventTouchUpInside];
         
         
         //隐藏展开的标签
         UIImageView *openLable = [UIImageView new];
         [_smallView addSubview:openLable];
         [openLable mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(_smallView.mas_right).offset(-15);
             make.top.equalTo(_smallView.mas_top).offset(24);
             make.height.equalTo(@22);
             make.width.equalTo(@22);
         }];
         openLable.image = [UIImage imageNamed:@"阶段收起"];
         _openBtn = openLable;
         
         _bottomLine = [UIView new];
         [_smallView addSubview:_bottomLine];
         [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(_smallView.mas_left);
             make.right.equalTo(_smallView.mas_right);
             make.height.equalTo(@1);
             make.bottom.equalTo(_smallView.mas_bottom);
         }];
         _bottomLine.backgroundColor = specolor;
         
         UIView *topLine = [UIView new];
         [_smallView addSubview:topLine];
         [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(_smallView.mas_left);
             make.right.equalTo(_smallView.mas_right);
             make.height.equalTo(@1);
             make.top.equalTo(_smallView.mas_top);
         }];
         topLine.backgroundColor = specolor;
     }
    return self;
}


-(void)singleTip:(UIButton*)sender
{
   
    self.planHeader.isopen = !self.planHeader.isopen;
    if ([self.delegate respondsToSelector:@selector(clickView)])
    {
      [self.delegate clickView];
    }
}
-(void)setPlanHeader:(StageModel *)planHeader
{
    _planHeader = planHeader;
    //阶段时间实现
    _mylabel.text = [NSString stringWithFormat:@"%@日~%@日",[self DateChange:_planHeader.start],[self DateChange:_planHeader.end]];
    //目标
    _detali.text = _planHeader.discription.target;
    //状态
    if ([_planHeader.status isEqualToString:@"prepared"])
    {
        _StageBackImage.image = [UIImage imageNamed:@"阶段未进行"];
    }
    else if([_planHeader.status isEqualToString:@"current"])
    {
        _StageBackImage.image = [UIImage imageNamed:@"阶段进行中"];
    }
    else
    {
        _StageBackImage.image = [UIImage imageNamed:@"阶段已完成"];
    }
    
    if (_planHeader.isopen == YES)
    {
        _detali.hidden = NO;
        _openBtn.image = [UIImage imageNamed:@"阶段收起"];
        CGSize size = [_detali.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREENWIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        LRLog(@"%lf",size.height);
        NSMutableAttributedString *str = [self TheLabletext:_detali.text];
        _detali.attributedText = str;
        
        CGFloat strNum = [_detali numberOfText];
        
        
    
        [_detali sizeToFit];
        if (strNum == 1)
        {
            _smallView.height = size.height + 70 + strNum * 5 + 13;
            _detali.frame = CGRectMake(15, _mylabel.y + 25, SCREENWIDTH - 30, size.height + strNum * 5);
        }
        else
        {
            _smallView.height = size.height + 70 + (strNum - 1) * 5 + 13;
            _detali.frame = CGRectMake(15, _mylabel.y + 25, SCREENWIDTH - 30, size.height + (strNum - 1) * 5);
        }
        [_bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_smallView.mas_left).offset(15);
            make.right.equalTo(_smallView.mas_right).offset(-15);
            make.height.equalTo(@1);
            make.bottom.equalTo(_smallView.mas_bottom);
        }];
        
        
    }else
    {
        _detali.hidden = YES;
        _smallView.height = 70;
        _openBtn.image = [UIImage imageNamed:@"阶段展开"];
        _detali.frame = CGRectMake(15, _mylabel.y + 25, SCREENWIDTH - 30, 100);
        [_bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_smallView.mas_left);
            make.right.equalTo(_smallView.mas_right);
            make.height.equalTo(@1);
            make.bottom.equalTo(_smallView.mas_bottom);
        }];

    }
    
    
}
//行距设置
-(NSMutableAttributedString*)TheLabletext:(NSString*)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 5;  //行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}
-(void)setItemsection:(NSInteger)Itemsection
{
    _Itemsection = Itemsection;
    _jieduan.text = [NSString stringWithFormat:@"阶段%ld",(long)_Itemsection + 1];
    
    _indexSet=[[NSIndexSet alloc]initWithIndex:Itemsection];
    LRLog(@"-----------%ld",(long)Itemsection);

}
-(void)setOpenModel:(OpenModel *)OpenModel
{
    _OpenModel = OpenModel;
}
//处理时间格式
-(NSString*)DateChange:(NSString*)startAndEndTime
{
    NSString *changeDate = nil;
    if (startAndEndTime.length == 0)
    {
        
    }
    else
    {
        NSRange range1 = NSMakeRange(4, 1);
        changeDate = [startAndEndTime stringByReplacingCharactersInRange:range1 withString:@"年"];
        NSRange range2 = NSMakeRange(7, 1);
        changeDate = [changeDate stringByReplacingCharactersInRange:range2 withString:@"月"];
    }
    return changeDate;
}

@end

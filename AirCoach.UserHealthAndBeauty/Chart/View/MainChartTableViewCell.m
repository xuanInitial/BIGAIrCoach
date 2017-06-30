//
//  MainChartTableViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/7.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "MainChartTableViewCell.h"
#import "ChartCollectionViewCell.h"
#import "UIView+XMGExtension.h"
#import "BusinessAirCoach.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MainChartTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView * ChartCollectionView;

@end
@implementation MainChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        
        //个人头像
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 - 37 , 8, 74, 74)];
       [headImage sd_setImageWithURL:[NSURL URLWithString:[BusinessAirCoach getHeadPortrait]] placeholderImage:[UIImage imageNamed:@"用户-默认头像"]];
        headImage.layer.cornerRadius = 37;
        headImage.layer.masksToBounds = YES;
        headImage.contentMode = UIViewContentModeScaleAspectFill;
        headImage.clipsToBounds = YES;
        [self addSubview:headImage];
        
        
        //分段选择器
        NSArray *segement = [[NSArray alloc]initWithObjects:@"体重",@"平静心率",@"屏息时间",@"仰卧起坐",nil];
        UISegmentedControl *segementCon = [[UISegmentedControl alloc]initWithItems:segement];
        segementCon.frame = CGRectMake(15, headImage.y + 88, SCREENWIDTH - 30, 30);
        segementCon.tintColor = SegementColor;
        segementCon.segmentedControlStyle = UISegmentedControlStylePlain;
        segementCon.selectedSegmentIndex = 0;
        [self addSubview:segementCon];
        [segementCon addTarget:self action:@selector(choiceSegement:) forControlEvents:UIControlEventValueChanged];
        
        //标题
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(15, segementCon.y + 60, 42, 20)];
        name.font = [UIFont systemFontOfSize:20];
        name.text = @"体重";
        name.textColor = Subcolor;
        [self addSubview:name];
        _NameItem = name;
        
        //副标题
        UILabel *danwei = [[UILabel alloc]initWithFrame:CGRectMake(name.x + 48, segementCon.y + 66, 100, 12)];
        danwei.font = [UIFont systemFontOfSize:12];
        [self addSubview:danwei];
        danwei.textColor = Subcolor;
        danwei.text = @"单位（公斤）";
        _SedNameItem = danwei;
        
        //数据
        UILabel *big = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH  - 70, segementCon.y + 56, 70, 30)];
        big.font = [UIFont systemFontOfSize:30];
        //[self addSubview:big];
        big.text = @"52.5";
        big.textColor = SegementColor;
        _NumItem = big;
        
    
        //华丽的分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, name.y + 30, SCREENWIDTH - 30, 1)];
        lineView.backgroundColor = speLineColor;
        [self addSubview:lineView];
        
        //建议
        UILabel *jianyi = [[UILabel alloc]initWithFrame:CGRectMake(15, lineView.y + 11, SCREENWIDTH - 30, 34)];
        jianyi.font = [UIFont systemFontOfSize:12];
        [self addSubview:jianyi];
        jianyi.text = @"请在保持身体平稳的情况下测量体重";
        jianyi.numberOfLines = 0;
        NSMutableAttributedString *  attributedString = [self TheLabletext:jianyi.text];
        jianyi.attributedText = attributedString;
        jianyi.width = SCREENWIDTH - 30;
        [jianyi sizeToFit];
        
        jianyi.textColor = Subcolor;
        _propolItem = jianyi;
        //请在保持身体平稳的情况下测量体重
        
        //主图表区
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //设置滚动方向是横向滚动
        [flowLayout setItemSize:CGSizeMake(SCREENWIDTH, 310 + 124)];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _ChartCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, jianyi.y + 52, SCREENWIDTH , 310 + 124) collectionViewLayout:flowLayout];
        [self addSubview:_ChartCollectionView];
        
        [_ChartCollectionView registerClass:[ChartCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        _ChartCollectionView.delegate = self;
        _ChartCollectionView.dataSource = self;
        
        _ChartCollectionView.backgroundColor = [UIColor whiteColor];
        _ChartCollectionView.pagingEnabled = YES;
        _ChartCollectionView.bounces = NO;
        _ChartCollectionView.scrollEnabled = NO;

        _Xnum = [NSMutableArray array];
        
        
        
        
    }
    return self;
}
-(void)choiceSegement:(UISegmentedControl*)sege
{
    switch (sege.selectedSegmentIndex) {
        case 0:
        {
            _ChartCollectionView.contentOffset = CGPointMake(0, 0);
            _NameItem.text = @"体重";
            _SedNameItem.text = @"单位：公斤";
            _propolItem.text = @"请在保持身体平稳的情况下测量体重";
            _NameItem.width = 42;
            _SedNameItem.x = _NameItem.x + 48;
            NSMutableAttributedString *  attributedString = [self TheLabletext:_propolItem.text];
            _propolItem.attributedText = attributedString;
            _propolItem.width = SCREENWIDTH - 30;
            [_propolItem sizeToFit];
            break;
        }
        case 1:
        {
            _ChartCollectionView.contentOffset = CGPointMake(SCREENWIDTH, 0);
            _NameItem.text = @"心功能";
            _NameItem.width = 62;
            _SedNameItem.text = @"心功能 平静心率测试，单位：次/分";
            _SedNameItem.x = _NameItem.x + 62 + 6;
            _SedNameItem.width = 200;
            _propolItem.text = @"女性每分钟45-55次为优秀，56-66次为良好，66-75次为合格，76次以上为不合格。";
            NSMutableAttributedString *  attributedString = [self TheLabletext:_propolItem.text];
            _propolItem.attributedText = attributedString;
            
            _propolItem.width = SCREENWIDTH - 30;
            [_propolItem sizeToFit];
            break;
        }
        case 2:
        {
            _ChartCollectionView.contentOffset = CGPointMake(2 * SCREENWIDTH, 0);
            _NameItem.text = @"肺功能";
            _SedNameItem.text = @"肺功能 屏息时间测试，单位：秒";
            _propolItem.text = @"女性屏息60秒以上为优秀，40-60次为良好，31-45次为合格，低于30秒为不合格。";
            _NameItem.width = 62;
            _SedNameItem.x = _NameItem.x + 62 + 6;
            _SedNameItem.width = 200;
            NSMutableAttributedString *  attributedString = [self TheLabletext:_propolItem.text];
            _propolItem.attributedText = attributedString;
            _propolItem.width = SCREENWIDTH - 30;
            [_propolItem sizeToFit];
            break;
        }
        case 3:
        {
            _ChartCollectionView.contentOffset = CGPointMake(3 * SCREENWIDTH, 0);
            _NameItem.text = @"力量";
            _SedNameItem.text = @"力量 仰卧起坐测试，单位：个/分";
            _propolItem.text = @"女性每分钟30个以上为优秀，26-30个为良好，16-25个为一般，6-15个为稍差，低于6个为不合格。";
            _NameItem.width = 42;
            _SedNameItem.x = _NameItem.x + 48;
            _SedNameItem.width = 200;
            NSMutableAttributedString *  attributedString = [self TheLabletext:_propolItem.text];
            _propolItem.attributedText = attributedString;
            _propolItem.width = SCREENWIDTH - 30;
            [_propolItem sizeToFit];
            break;
        }
        default:
            break;
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.CollocetionCellArr != nil) {
        //x轴的值
        cell.CollectCellArr = self.CollocetionCellArr;
    
            NSMutableArray *xValue = [NSMutableArray array];
            //取出key对应得value值
            
            NSArray *arr = self.cellArr[indexPath.row];
            for (NSDictionary *dic in arr)
            {
                [xValue addObject:dic[@"value"]];
            }
    
            cell.CellXArr = xValue;
        
    }
    
    
    
    
    //背景图
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"曲线渐变背景-调整"]];
    cell.backgroundView = backImage;
    [cell configUI:indexPath];
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, 310 + 124);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(void)setCellArr:(NSArray *)cellArr
{
    _cellArr = cellArr;
    //[_ChartCollectionView reloadData];
}
-(void)setTimeArr:(NSArray *)TimeArr
{
    _TimeArr = TimeArr;
}
-(void)setCollocetionCellArr:(NSArray *)CollocetionCellArr
{
    _CollocetionCellArr = CollocetionCellArr;
    [_ChartCollectionView reloadData];
}
//行距设置
-(NSMutableAttributedString*)TheLabletext:(NSString*)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //paragraphStyle.maximumLineHeight = 18;  //最大的行高
    paragraphStyle.lineSpacing = 5;  //行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}
@end

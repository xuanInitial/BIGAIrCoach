//
//  DietTableViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/1.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "DietTableViewCell.h"
#import "DietCollectionViewCell.h"
@interface DietTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *DietCollectionView;

@end


@implementation DietTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
//初始化方法
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _whichDiet = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 30, 14)];
        _whichDiet.textAlignment = NSTextAlignmentLeft; //水平对齐
        [_whichDiet setFont:[UIFont systemFontOfSize:14]];
        [_whichDiet setTextColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0f]];
        [self.contentView addSubview:_whichDiet];

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *colle = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, SCREENWIDTH, 143) collectionViewLayout:flowLayout];
        
        colle.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [self.contentView addSubview:colle];
        colle.delegate = self;
        colle.dataSource = self;
        colle.backgroundColor = [UIColor whiteColor];
        colle.showsHorizontalScrollIndicator = NO;
        [colle registerClass:[DietCollectionViewCell class] forCellWithReuseIdentifier:@"DietCollCell"];
        _DietCollectionView = colle;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 177, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = xiLine;
        [self.contentView addSubview:lineView];
        
    }
    return self;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100,143);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 22.5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 22.5;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indeCell = @"DietCollCell";
    DietCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indeCell forIndexPath:indexPath];
    
    CGFloat num = [BusinessAirCoach getTotalKcal:[BusinessAirCoach getTel]].floatValue ;
    if (self.showFlag == YES) {
    
            if (self.Mysection == 0) {
                self.whichDiet.text = @"早餐";
                if (indexPath.row == 0)
                {
                    cell.DietNameLabel.text = @"碳水化合物";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fKJ",num*0.3*0.635*4.182];
                    cell.DietImageV.image = [UIImage imageNamed:@"碳水化合物"];
                }
                else if (indexPath.row == 1)
                {
                    cell.DietNameLabel.text = @"蛋白质";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fKJ",num*0.3*0.235*4.182];
                    cell.DietImageV.image = [UIImage imageNamed:@"蛋白质"];
                }
                else
                {
                    cell.DietNameLabel.text = @"脂肪";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fKJ",num*0.3*0.13*4.182];
                    cell.DietImageV.image = [UIImage imageNamed:@"脂肪.jpg"];
                }
                
            }else if (self.Mysection == 1) {//午
                self.whichDiet.text = @"午餐";
                if (indexPath.row == 0)
                {
                    cell.DietNameLabel.text = @"碳水化合物";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fKJ",num*0.4*0.635*4.182];
                    cell.DietImageV.image = [UIImage imageNamed:@"碳水化合物"];
                }
                else if (indexPath.row == 1)
                {
                    cell.DietNameLabel.text = @"蛋白质";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fKJ",num*0.4*0.235*4.182];
                    cell.DietImageV.image = [UIImage imageNamed:@"蛋白质"];
                }
                else
                {
                    cell.DietNameLabel.text = @"脂肪";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fKJ",num*0.4*0.13*4.182];
                    cell.DietImageV.image = [UIImage imageNamed:@"脂肪.jpg"];
                }

            }else{//晚
               self.whichDiet.text = @"晚餐";
                if (indexPath.row == 0)
                {
                    cell.DietNameLabel.text = @"碳水化合物";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fKJ",num*0.3*0.635*4.182];
                    cell.DietImageV.image = [UIImage imageNamed:@"碳水化合物"];
                }
                else if (indexPath.row == 1)
                {
                    cell.DietNameLabel.text = @"蛋白质";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fKJ",num*0.3*0.235*4.182];
                    cell.DietImageV.image = [UIImage imageNamed:@"蛋白质"];
                }
                else
                {
                    cell.DietNameLabel.text = @"脂肪";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fKJ",num*0.3*0.13*4.182];
                    cell.DietImageV.image = [UIImage imageNamed:@"脂肪.jpg"];
                }

    

    
        }
    }
        else {
    
    
            if (self.Mysection == 0) {
                self.whichDiet.text = @"早餐";
                if (indexPath.row == 0)
                {
                    cell.DietNameLabel.text = @"碳水化合物";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fkCal",num*0.3*0.635];
                    cell.DietImageV.image = [UIImage imageNamed:@"碳水化合物"];
                }
                else if (indexPath.row == 1)
                {
                    cell.DietNameLabel.text = @"蛋白质";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fkCal",num*0.3*0.235];
                    cell.DietImageV.image = [UIImage imageNamed:@"蛋白质"];
                }
                else
                {
                    cell.DietNameLabel.text = @"脂肪";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fkCal",num*0.3*0.13];
                    cell.DietImageV.image = [UIImage imageNamed:@"脂肪.jpg"];
                }
               
            }else if (self.Mysection == 1) {//午
                self.whichDiet.text = @"午餐";
                if (indexPath.row == 0)
                {
                    cell.DietNameLabel.text = @"碳水化合物";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fkCal",num*0.4*0.635];
                    cell.DietImageV.image = [UIImage imageNamed:@"碳水化合物"];
                }
                else if (indexPath.row == 1)
                {
                    cell.DietNameLabel.text = @"蛋白质";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fkCal",num*0.4*0.235];
                    cell.DietImageV.image = [UIImage imageNamed:@"蛋白质"];
                }
                else
                {
                    cell.DietNameLabel.text = @"脂肪";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fkCal",num*0.4*0.13];
                    cell.DietImageV.image = [UIImage imageNamed:@"脂肪.jpg"];
                }
            }else{//晚
                self.whichDiet.text = @"晚餐";
                if (indexPath.row == 0)
                {
                    cell.DietNameLabel.text = @"碳水化合物";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fkCal",num*0.3*0.635];
                    cell.DietImageV.image = [UIImage imageNamed:@"碳水化合物"];
                }
                else if (indexPath.row == 1)
                {
                    cell.DietNameLabel.text = @"蛋白质";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fkCal",num*0.3*0.235];
                    cell.DietImageV.image = [UIImage imageNamed:@"蛋白质"];
                }
                else
                {
                    cell.DietNameLabel.text = @"脂肪";
                    cell.DietNum.text = [NSString stringWithFormat:@"%0.fkCal",num*0.3*0.13];
                    cell.DietImageV.image = [UIImage imageNamed:@"脂肪.jpg"];
                }
            }
            
        }

    
    return cell;
    
}
-(void)setShowFlag:(BOOL)showFlag
{
    _showFlag = showFlag;
    [_DietCollectionView reloadData];
}
-(void)setMysection:(NSInteger)Mysection
{
    _Mysection = Mysection;
    [_DietCollectionView reloadData];
}
@end

//
//  CourseDetailViewController.h
//  AirCoach.acUser
//
//  Created by xuan on 15/11/24.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "ClassCell.h"
#import "ClassCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "previewModel.h"
#import "WarmModel.h"
#import "RestCollectionViewCell.h"
#import "UIView+XMGExtension.h"
#define ac @"abcdefghijklmnopqrstuvwxyz"
#define AC @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
@interface ClassCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)NSMutableArray *datas;

@end

@implementation ClassCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//初始化方法
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *colle = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 143) collectionViewLayout:flowLayout];
        
        colle.contentInset = UIEdgeInsetsMake(12, 15, 0, 15);
        [self.contentView addSubview:colle];
        colle.delegate = self;
        colle.dataSource = self;
        colle.backgroundColor = [UIColor whiteColor];
        colle.showsHorizontalScrollIndicator = NO;
        [colle registerClass:[ClassCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        [colle registerClass:[RestCollectionViewCell class] forCellWithReuseIdentifier:@"RestCell"];
        _collectionView = colle;
        

        
    }
    return self;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    previewModel *previewMod = _cellArr[indexPath.row];
    if ([previewMod.type isEqualToString:@"warm"]||[previewMod.type isEqualToString:@"stretch"])
    {
        return CGSizeMake(100, 111);
    }
    else if([previewMod.type isEqualToString:@"main"])
    {
        return CGSizeMake(100, 131);
    }
    else
    {
       
        @try {
            previewModel *previewMod1 = _cellArr[indexPath.row - 1];
            if (([previewMod1.type isEqualToString:@"warm"]||[previewMod1.type isEqualToString:@"stretch"])&&[previewMod.type isEqualToString:@"common"])
            {
                return CGSizeMake(44, 111);
            }
            else
            {
                return CGSizeMake(44, 131);
            }

        } @catch (NSException *exception) {
            return CGSizeMake(44, 111);
        }
    }

    
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 14;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _cellArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *inde = @"cellID";
    static NSString *indeCell = @"RestCell";
    previewModel *previewMod = _cellArr[indexPath.row];
    if ([previewMod.type isEqualToString:@"common"])
    {
        RestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indeCell forIndexPath:indexPath];
        cell.RestPreviewMod = previewMod;
        return cell;
    }
    else
    {
        ClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inde forIndexPath:indexPath];
        cell.previewMod = previewMod;
        return cell;
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSLog(@"点击了collectionViewcell");
        
    previewModel *previewMod = _cellArr[indexPath.row];
    
    if (![previewMod.type isEqualToString:@"common"])
    {
        if ([self.delegate respondsToSelector:@selector(TableViewCellDelsegateWithCollectionDidselection:addUrl:addAction:)]) {
            
            if (([AC rangeOfString:[previewMod.name substringFromIndex:previewMod.name.length - 1]].length != 0 ||[ac rangeOfString:[previewMod.name substringFromIndex:previewMod.name.length - 1]].length != 0) && previewMod.name != nil && previewMod.name.length!= 0)
            {
               [self.delegate TableViewCellDelsegateWithCollectionDidselection:indexPath.row addUrl:previewMod.url addAction:[previewMod.name substringToIndex:previewMod.name.length - 1]];
            }
            else
            {
                [self.delegate TableViewCellDelsegateWithCollectionDidselection:indexPath.row addUrl:previewMod.url addAction:previewMod.name];
            }
            
        }
    }
    
    
}

-(void)buttonCliced:(UIButton *)button {
    
    
    NSLog(@"点击了更多按钮");
    if ([self.delegate respondsToSelector:@selector(returnTableViewCellDelsegateIndex:)]) {
        [self.delegate returnTableViewCellDelsegateIndex:self.tag];
    }

}


#pragma mark - setupCell click ZLPhotoPickerBrowserViewController
- (void) setupPhotoBrowser:(NSInteger)indexPath{
    if (![_cellArr[indexPath] isKindOfClass:[UIImage class]])
    {
        // 图片游览器
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        // 数据源/delegate
        pickerBrowser.delegate = self;
        pickerBrowser.photos = _cellArr;
        // 是否可以删除照片
        pickerBrowser.editing = NO;
        
        pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:indexPath inSection:0];
        // 展示控制器
        [pickerBrowser showPickerVc:[self.delegate getSuperViewController]];
    }
    
    
    
}


#pragma mark ------ cell的set方法

- (void)setCellArr:(NSMutableArray *)cellArr
{
    _cellArr = cellArr;
    if (cellArr.count == 0)
    {
      //  UIImage *image = [UIImage imageNamed:@"教练详情页-无图片"];
      //  _cellArr = @[image];
    }
    previewModel *previewMod = _cellArr[0];
    if ([previewMod.type isEqualToString:@"warm"]||[previewMod.type isEqualToString:@"stretch"])
    {
        _collectionView.height = 123;
    }
    else
    {
       _collectionView.height = 143;
    }
    [_collectionView reloadData];
    
    
    
    
    
}
- (void)setCountArray:(NSMutableArray *)countArray{
    
    _countArray = countArray;
    if (countArray.count == 0) {
        NSLog(@"空的");
    }
    
    [_collectionView reloadData];
}


@end

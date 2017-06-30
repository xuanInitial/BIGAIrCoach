//
//  ChartCollectionViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/3.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessAirCoach.h"
@interface ChartCollectionViewCell : UICollectionViewCell
- (void)configUI:(NSIndexPath *)indexPath;
@property(nonatomic,copy)NSArray * CollectCellArr;
@property(nonatomic,copy)NSArray * CellXArr;

@end

//
//  RestCollectionViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/10/17.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "previewModel.h"
@interface RestCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *restCellImg;
@property (nonatomic,strong)previewModel *RestPreviewMod;
@end

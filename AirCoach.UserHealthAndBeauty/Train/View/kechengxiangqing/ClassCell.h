//
//  CourseDetailViewController.h
//  AirCoach.acUser
//
//  Created by xuan on 15/11/24.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "ZLPhoto.h"
@protocol UITableViewCellDelsegate <NSObject>

-(void)returnTableViewCellDelsegateIndex:(int)index;

- (void)TableViewCellDelsegateWithCollectionDidselection:(NSInteger)index addUrl:(NSString *)url addAction:(NSString *)action;

- (UIViewController *)getSuperViewController;

@end

@interface ClassCell : UITableViewCell<ZLPhotoPickerBrowserViewControllerDelegate>
//{
//    CALayer *layer;
//    
//}

@property(nonatomic,weak)UILabel *custLabel;
@property(nonatomic,weak)UIButton *custBit;
@property(nonatomic,weak)UILabel *smallLabel;
@property(nonatomic,weak)UIImageView *custImageV;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,strong)CALayer *luLayer;

@property(nonatomic,copy)NSArray * cellArr;

@property (nonatomic,copy)NSArray *countArray;//获取动作组数的数组


@property(nonatomic,assign)id<UITableViewCellDelsegate>delegate;

@end

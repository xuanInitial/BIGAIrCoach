//
//  RestCollectionViewCell.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/10/17.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "RestCollectionViewCell.h"

@implementation RestCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _restCellImg = [[UIImageView alloc]init];
        [_restCellImg setFrame:CGRectMake(0, 0, 44, 75)];
        [self.contentView addSubview:_restCellImg];
    }
    return self;
}
-(void)setRestPreviewMod:(previewModel *)RestPreviewMod
{
    if ([RestPreviewMod.type isEqualToString:@"common"] && [RestPreviewMod.name isEqualToString:@"休息60秒"])
    {
        _restCellImg.image = [UIImage imageNamed:@"休息-60s"];
    }
    else
    {
        _restCellImg.image = [UIImage imageNamed:@"休息-30s"];
    }
    
}

@end

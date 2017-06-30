//
//  SquareCashStyleBar.m
//  BLKFlexibleHeightBar Demo
//
//  Created by Bryan Keller on 2/19/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import "SquareCashStyleBar.h"
#import "BusinessAirCoach.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation SquareCashStyleBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self configureBar];
    }
    
    return self;
}

- (void)configureBar
{
    // Configure bar appearence
    self.maximumBarHeight = 168.0;
    self.minimumBarHeight = 65.0;
    self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.image = [UIImage imageNamed:@"阶段背景图"];
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
     // Add and configure name label
     UILabel *nameLabel = [[UILabel alloc] init];
     nameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];;
     nameLabel.textColor = [UIColor whiteColor];
     nameLabel.text = [NSString stringWithFormat:@"%@的训练规划",[BusinessAirCoach getNickName]];
    
     BLKFlexibleHeightBarSubviewLayoutAttributes *initialNameLabelLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialNameLabelLayoutAttributes.size = [nameLabel sizeThatFits:CGSizeZero];
    initialNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, self.maximumBarHeight-30.0);
    [nameLabel addLayoutAttributes:initialNameLabelLayoutAttributes forProgress:0.0];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *midwayNameLabelLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialNameLabelLayoutAttributes];
    midwayNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, (self.maximumBarHeight-self.minimumBarHeight)*0.4+self.minimumBarHeight-50.0);
    [nameLabel addLayoutAttributes:midwayNameLabelLayoutAttributes forProgress:0.6];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalNameLabelLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:midwayNameLabelLayoutAttributes];
    finalNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, self.minimumBarHeight-25.0);
    [nameLabel addLayoutAttributes:finalNameLabelLayoutAttributes forProgress:1.0];
    
    [self addSubview:nameLabel];
    
    
    // Add and configure profile image
    UIImageView *profileImageView = [[UIImageView alloc] init];
    [profileImageView sd_setImageWithURL:[NSURL URLWithString:[BusinessAirCoach getHeadPortrait]] placeholderImage:[UIImage imageNamed:@"用户-默认头像"]];
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.cornerRadius = 35.0;
    profileImageView.layer.borderWidth = 2.0;
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialProfileImageViewLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialProfileImageViewLayoutAttributes.size = CGSizeMake(70.0, 70.0);
    initialProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, self.maximumBarHeight-90.0);
    [profileImageView addLayoutAttributes:initialProfileImageViewLayoutAttributes forProgress:0.0];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *midwayProfileImageViewLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialProfileImageViewLayoutAttributes];
    midwayProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, (self.maximumBarHeight-self.minimumBarHeight)*0.8+self.minimumBarHeight-110.0);
    [profileImageView addLayoutAttributes:midwayProfileImageViewLayoutAttributes forProgress:0.2];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalProfileImageViewLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:midwayProfileImageViewLayoutAttributes];
    finalProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, (self.maximumBarHeight-self.minimumBarHeight)*0.64+self.minimumBarHeight-110.0);
    finalProfileImageViewLayoutAttributes.transform = CGAffineTransformMakeScale(0.5, 0.5);
    finalProfileImageViewLayoutAttributes.alpha = 0.0;
    [profileImageView addLayoutAttributes:finalProfileImageViewLayoutAttributes forProgress:0.5];
    
    [self addSubview:profileImageView];
}

@end

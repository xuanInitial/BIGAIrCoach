//
//  CTPersonTableViewCell.h
//  AirCoach2.0
//
//  Created by 高静 on 16/1/10.
//  Copyright © 2016年 高静. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTPersonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Header;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *state;

@property (weak, nonatomic) IBOutlet UIImageView *NewText;


@end

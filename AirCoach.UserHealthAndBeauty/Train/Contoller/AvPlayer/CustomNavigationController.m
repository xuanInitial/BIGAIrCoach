//
//  CustomNavigationController.m
//  AirCoach.acUser
//
//  Created by xuan on 16/1/7.
//  Copyright © 2016年 AirCoach2.0. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate
{
    return NO;
    
}


-(NSUInteger)supportedInterfaceOrientations{
    //return UIInterfaceOrientationMaskLandscapeRight;
    return self.orietation;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != self.orietation);
} 

@end

//
//  ViewController.m
//  BKActivityIndicatorHUD
//
//  Created by jollyColcors on 16/4/7.
//  Copyright © 2016年 BIKE. All rights reserved.
//

#import "ViewController.h"
#import "BKActivityIndicatorHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(aaa) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)aaa
{
    NSLog(@"1");
    
    [[BKActivityIndicatorHUD HUD] showActivityIndicatorWithType:BKSlideMenuViewTitleWidthStyleOpacity inView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BKActivityIndicatorHUD HUD] hideHUDInView:self.view];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
}

- (IBAction)num1:(id)sender {
    [[BKActivityIndicatorHUD HUD] showActivityIndicatorWithType:BKActivityIndicatorStyleScale];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BKActivityIndicatorHUD HUD] hideHUD];
    });
}

- (IBAction)num2:(id)sender {
    [[BKActivityIndicatorHUD HUD] showActivityIndicatorWithType:BKActivityIndicatorStyleOpacity];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BKActivityIndicatorHUD HUD] hideHUD];
    });
}

- (IBAction)num3:(id)sender {
    [[BKActivityIndicatorHUD HUD] showActivityIndicatorWithType:BKActivityIndicatorStyleLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BKActivityIndicatorHUD HUD] hideHUD];
    });
}

- (IBAction)Success:(id)sender {
    [[BKActivityIndicatorHUD HUD] successHUD];
}

- (IBAction)error:(id)sender {
    [[BKActivityIndicatorHUD HUD] errorHUD];
}

- (IBAction)remind:(id)sender {
    [[BKActivityIndicatorHUD HUD] showRemindTextHUDWithText:@"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  BKActivityIndicatorHUD.m
//  BKActivityIndicatorHUD
//
//  Created by jollyColcors on 16/4/7.
//  Copyright © 2016年 BIKE. All rights reserved.
//

#import "BKActivityIndicatorHUD.h"

@interface BKActivityIndicatorHUD()
{
    CAReplicatorLayer *replicatorLayer;
}
@end

@implementation BKActivityIndicatorHUD

+ (instancetype)HUD
{
    static BKActivityIndicatorHUD *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    
    return sharedAccountManagerInstance;
}

-(void)showActivityIndicatorWithType:(BKActivityIndicatorStyle)style
{
    UIView * view = [self getCurrentVC].view;
    view.userInteractionEnabled = NO;
    
    replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds = CGRectMake(0, 0, view.bounds.size.width/4.0f, view.bounds.size.width/4.0f);
    replicatorLayer.position = view.center;
    replicatorLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f].CGColor;
    replicatorLayer.cornerRadius = replicatorLayer.bounds.size.width/10.0f;
    replicatorLayer.masksToBounds = YES;
    [view.layer addSublayer:replicatorLayer];
    
    CALayer * dotLayer = [CALayer layer];
    dotLayer.bounds = CGRectMake(0, 0, replicatorLayer.bounds.size.width/15.0f, replicatorLayer.bounds.size.width/15.0f);
    dotLayer.position = CGPointMake(replicatorLayer.bounds.size.width/2.0f, replicatorLayer.bounds.size.width/4.0f);
    dotLayer.cornerRadius = replicatorLayer.bounds.size.width/30.0f;
    dotLayer.masksToBounds = YES;
    dotLayer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    dotLayer.borderColor = [UIColor colorWithWhite:1.0 alpha:1].CGColor;
    [replicatorLayer addSublayer:dotLayer];
    
    int count = 12;
    //    每个点的延迟时间
    replicatorLayer.instanceDelay = 1.0 / count;
    //    点的个数
    replicatorLayer.instanceCount = count;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation((2 * M_PI) / count, 0, 0, 1.0);
    
    switch (style) {
        case BKSlideMenuViewTitleWidthStyleScale:
        {
            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animation.duration = 1;
            animation.repeatCount = MAXFLOAT;
            animation.fromValue = @(1);
            animation.toValue = @(0.01);
            [dotLayer addAnimation:animation forKey:nil];
            
            dotLayer.transform = CATransform3DMakeScale(0, 0, 0);
        }
            break;
        case BKSlideMenuViewTitleWidthStyleOpacity:
        {
            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animation.duration = 1;
            animation.repeatCount = MAXFLOAT;
            animation.fromValue = @(1);
            animation.toValue = @(0.01);
            [dotLayer addAnimation:animation forKey:nil];
            
            dotLayer.opacity = 0;
        }
            break;
        default:
            break;
    }
}

-(void)hideHUD
{
    UIView * view = [self getCurrentVC].view;
    view.userInteractionEnabled = YES;
    
    [replicatorLayer removeAllAnimations];
    [replicatorLayer removeFromSuperlayer];
}

-(void)showRemindTextHUDWithText:(NSString *)text
{
    UIView * view = [self getCurrentVC].view;
    
    CATextLayer * textLary = [CATextLayer layer];
    textLary.string = text;
    textLary.fontSize = 13.0*[UIScreen mainScreen].bounds.size.width/320.0f;
    
    CGFloat width = [self sizeWithString:text UIHeight:view.bounds.size.height font:textLary.fontSize].width;
    if (width>view.bounds.size.width/4.0*3.0f) {
        width = view.bounds.size.width/4.0*3.0f;
    }
    CGFloat height = [self sizeWithString:text UIWidth:width font:textLary.fontSize].height;
    
    textLary.bounds = CGRectMake(0, 0, width, height);
    textLary.position = CGPointMake(view.bounds.size.width/2.0f, view.bounds.size.height/2.0f);
    textLary.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f].CGColor;
    textLary.cornerRadius = textLary.bounds.size.width/10.0f;
    textLary.masksToBounds = YES;
    [view.layer addSublayer:textLary];
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(CGSize)sizeWithString:(NSString *)string UIWidth:(CGFloat)width font:(CGFloat)fontSize
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options: NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}
                                       context:nil];
    
    return rect.size;
}

-(CGSize)sizeWithString:(NSString *)string UIHeight:(CGFloat)height font:(CGFloat)fontSize
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options: NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}
                                       context:nil];
    
    return rect.size;
}

@end

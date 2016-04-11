//
//  BKActivityIndicatorHUD.m
//  BKActivityIndicatorHUD
//
//  Created by jollyColcors on 16/4/7.
//  Copyright © 2016年 BIKE. All rights reserved.
//

#import "BKActivityIndicatorHUD.h"
#import <CoreText/CoreText.h>

@interface BKActivityIndicatorHUD()
{
    CAReplicatorLayer *replicatorLayer;
    CALayer * dotLayer;
    
    CALayer * shapeBgLayer;
    CAShapeLayer * circleShapeLayer;
    CAShapeLayer * textShapeLayer;
    
    CALayer * successLayer;
    CAShapeLayer * successShapeLayer;
    
    CALayer * errorLayer;
    CAShapeLayer * errorShapeLayer;
}
@end

@implementation BKActivityIndicatorHUD
@synthesize activityIndicatorStyle = _activityIndicatorStyle;

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
    
    _activityIndicatorStyle = style;
    
    switch (_activityIndicatorStyle) {
        case BKActivityIndicatorStyleScale:
        case BKActivityIndicatorStyleOpacity:
        {
            [self initReplicatorLayer];
        }
            break;
        case BKActivityIndicatorStyleLoading:
        {
            [self initShapeLayer];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ReplicatorLayer
//*********************************************************

-(void)initReplicatorLayer
{
    UIView * view = [self getCurrentVC].view;
    
    replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds = CGRectMake(0, 0, view.bounds.size.width/4.0f, view.bounds.size.width/4.0f);
    replicatorLayer.position = view.center;
    replicatorLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75f].CGColor;
    replicatorLayer.cornerRadius = replicatorLayer.bounds.size.width/10.0f;
    replicatorLayer.masksToBounds = YES;
    [view.layer addSublayer:replicatorLayer];
    
    dotLayer = [CALayer layer];
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
    
    switch (_activityIndicatorStyle) {
        case BKActivityIndicatorStyleScale:
        {
            [self scaleAnimation];
        }
            break;
        case BKActivityIndicatorStyleOpacity:
        {
            [self scaleAnimation];
        }
            break;
        default:
            break;
    }
}

-(void)scaleAnimation
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    [dotLayer addAnimation:animation forKey:nil];
    
    dotLayer.transform = CATransform3DMakeScale(0, 0, 0);
}

-(void)opacityAnimation
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    [dotLayer addAnimation:animation forKey:nil];
    
    dotLayer.opacity = 0;
}

#pragma mark - ShapeLayer
//*********************************************************

-(void)initShapeLayer
{
    UIView * view = [self getCurrentVC].view;
    
    shapeBgLayer = [CALayer layer];
    shapeBgLayer.bounds = CGRectMake(0, 0, view.bounds.size.width/4.0f, view.bounds.size.width/4.0f);
    shapeBgLayer.position = view.center;
    shapeBgLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75f].CGColor;
    shapeBgLayer.cornerRadius = shapeBgLayer.bounds.size.width/10.0f;
    shapeBgLayer.masksToBounds = YES;
    [view.layer addSublayer:shapeBgLayer];
    
    circleShapeLayer = [CAShapeLayer layer];
    circleShapeLayer.frame = CGRectMake(0, 0, shapeBgLayer.bounds.size.width, shapeBgLayer.bounds.size.height/5.0f*3);
    circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
    circleShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    circleShapeLayer.lineWidth = 2;
    [shapeBgLayer addSublayer:circleShapeLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circleShapeLayer.bounds.size.width/2.0f, circleShapeLayer.bounds.size.height/5.0f*3) radius:circleShapeLayer.bounds.size.width/4.0f startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    circleShapeLayer.path = path.CGPath;
    
    [self shapeLayerCircleAnimation];
    
    textShapeLayer = [CAShapeLayer layer];
    textShapeLayer.fillColor = [UIColor clearColor].CGColor;
    textShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    textShapeLayer.lineWidth = 0.5;
    [shapeBgLayer addSublayer:textShapeLayer];
    
    CABasicAnimation *textAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    textAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    textAnimation.fromValue = @(0);
    textAnimation.toValue = @(1);
    textAnimation.duration = 2.5;
    textAnimation.repeatCount = MAXFLOAT;
    [textShapeLayer addAnimation:textAnimation forKey:nil];
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:@"loading..."];
    CGFloat fontSize = 18.0*view.bounds.size.width/320.0f;
    [attributed addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} range:NSMakeRange(0, attributed.length)];
    textShapeLayer.path = [self coretextPath:attributed].CGPath;
}

-(void)shapeLayerCircleAnimation
{
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    circleAnimation.fromValue = @(0);
    circleAnimation.toValue = @(1);
    circleAnimation.duration = 2.5;
    circleAnimation.repeatCount = 1;
    circleAnimation.removedOnCompletion = NO;
    circleAnimation.fillMode = kCAFillModeForwards;
    [circleShapeLayer addAnimation:circleAnimation forKey:@"circleAnimation"];
    
    CABasicAnimation *disappearCircleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    disappearCircleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    disappearCircleAnimation.fromValue = @(0);
    disappearCircleAnimation.toValue = @(1);
    disappearCircleAnimation.duration = 1.5;
    disappearCircleAnimation.repeatCount = 1;
    disappearCircleAnimation.delegate = self;
    disappearCircleAnimation.beginTime = CACurrentMediaTime() + 1;
    disappearCircleAnimation.removedOnCompletion = NO;
    disappearCircleAnimation.fillMode = kCAFillModeForwards;
    [circleShapeLayer addAnimation:disappearCircleAnimation forKey:@"disappearCircleAnimation"];
}

- (UIBezierPath *)coretextPath:(NSMutableAttributedString *)text
{
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)text);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(pathRef, &t, letter);
            CGPathRelease(letter);
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:pathRef];
    CGRect boundingBox = CGPathGetBoundingBox(pathRef);
    
    CGFloat shapeLayer_width = boundingBox.size.width;
    CGFloat shapeLayer_height = boundingBox.size.height;
    CGFloat shapeLayer_X = (shapeBgLayer.bounds.size.width - shapeLayer_width)/2.0f;
    CGFloat shapeLayer_Y = shapeBgLayer.bounds.size.height/5.0f*3 + (shapeBgLayer.bounds.size.height/5.0f*2 - shapeLayer_height)/2.0f;
    
    textShapeLayer.frame = CGRectMake(shapeLayer_X, shapeLayer_Y , shapeLayer_width, shapeLayer_height);

    CFRelease(pathRef);
    CFRelease(line);
    
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    return path;
}

#pragma mark - hideHUD
//*********************************************************

-(void)hideHUD
{
    UIView * view = [self getCurrentVC].view;
    view.userInteractionEnabled = YES;
    
    switch (_activityIndicatorStyle) {
        case BKActivityIndicatorStyleScale:
        case BKActivityIndicatorStyleOpacity:
        {
            [replicatorLayer removeAllAnimations];
            [replicatorLayer removeFromSuperlayer];
        }
            break;
        case BKActivityIndicatorStyleLoading:
        {
            [circleShapeLayer removeAllAnimations];
            [circleShapeLayer removeFromSuperlayer];
            [textShapeLayer removeAllAnimations];
            [textShapeLayer removeFromSuperlayer];
            [shapeBgLayer removeFromSuperlayer];
        }
            break;
        default:
            break;
    }
}

#pragma mark - finishHUD
//*********************************************************

-(void)successHUD
{
    [self hideHUD];
    UIView * view = [self getCurrentVC].view;
    view.userInteractionEnabled = NO;
    
    successLayer = [CALayer layer];
    successLayer.bounds = CGRectMake(0, 0, view.bounds.size.width/4.0f, view.bounds.size.width/4.0f);
    successLayer.position = view.center;
    successLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75f].CGColor;
    successLayer.cornerRadius = successLayer.bounds.size.width/10.0f;
    successLayer.masksToBounds = YES;
    [view.layer addSublayer:successLayer];
    
    successShapeLayer = [CAShapeLayer layer];
    successShapeLayer.frame = successLayer.bounds;
    successShapeLayer.fillColor = [UIColor clearColor].CGColor;
    successShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    successShapeLayer.lineWidth = 2;
    [successLayer addSublayer:successShapeLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(successShapeLayer.bounds.size.width/2.0f, successShapeLayer.bounds.size.height/2.0f) radius:successShapeLayer.bounds.size.width/3.0f startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    [path moveToPoint:CGPointMake(successShapeLayer.frame.size.width/7.0f*2, successShapeLayer.frame.size.height/9.0f*5)];
    [path addLineToPoint:CGPointMake(successShapeLayer.frame.size.width/7.0f*3, successShapeLayer.frame.size.width/9.0f*6)];
    [path addLineToPoint:CGPointMake(successShapeLayer.frame.size.width/7.0f*5, successShapeLayer.frame.size.width/9.0f*3)];
    successShapeLayer.path = path.CGPath;
    
    CABasicAnimation *successAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    successAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    successAnimation.fromValue = @(0);
    successAnimation.toValue = @(1);
    successAnimation.duration = 1;
    successAnimation.repeatCount = 1;
    successAnimation.removedOnCompletion = NO;
    successAnimation.delegate = self;
    successAnimation.fillMode = kCAFillModeForwards;
    [successShapeLayer addAnimation:successAnimation forKey:@"successAnimation"];
}

#pragma mark - errorHUD
//*********************************************************

-(void)errorHUD
{
    [self hideHUD];
    UIView * view = [self getCurrentVC].view;
    view.userInteractionEnabled = NO;
    
    errorLayer = [CALayer layer];
    errorLayer.bounds = CGRectMake(0, 0, view.bounds.size.width/4.0f, view.bounds.size.width/4.0f);
    errorLayer.position = view.center;
    errorLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75f].CGColor;
    errorLayer.cornerRadius = errorLayer.bounds.size.width/10.0f;
    errorLayer.masksToBounds = YES;
    [view.layer addSublayer:errorLayer];
    
    errorShapeLayer = [CAShapeLayer layer];
    errorShapeLayer.frame = errorLayer.bounds;
    errorShapeLayer.fillColor = [UIColor clearColor].CGColor;
    errorShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    errorShapeLayer.lineWidth = 2;
    [errorLayer addSublayer:errorShapeLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(errorShapeLayer.bounds.size.width/2.0f, errorShapeLayer.bounds.size.height/2.0f) radius:errorShapeLayer.bounds.size.width/3.0f startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    [path moveToPoint:CGPointMake(errorShapeLayer.frame.size.width/3.0f, errorShapeLayer.frame.size.height/3.0f)];
    [path addLineToPoint:CGPointMake(errorShapeLayer.frame.size.width/3.0f*2, errorShapeLayer.frame.size.width/3.0f*2)];
    [path moveToPoint:CGPointMake(errorShapeLayer.frame.size.width/3.0f*2, errorShapeLayer.frame.size.height/3.0f)];
    [path addLineToPoint:CGPointMake(errorShapeLayer.frame.size.width/3.0f, errorShapeLayer.frame.size.width/3.0f*2)];
    errorShapeLayer.path = path.CGPath;
    
    CABasicAnimation *errorAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    errorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    errorAnimation.fromValue = @(0);
    errorAnimation.toValue = @(1);
    errorAnimation.duration = 1;
    errorAnimation.repeatCount = 1;
    errorAnimation.removedOnCompletion = NO;
    errorAnimation.delegate = self;
    errorAnimation.fillMode = kCAFillModeForwards;
    [errorShapeLayer addAnimation:errorAnimation forKey:@"errorAnimation"];
}

#pragma mark - RemindTextHUD
//*********************************************************

-(void)showRemindTextHUDWithText:(NSString *)text
{
    UIView * view = [self getCurrentVC].view;
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    bgView.layer.cornerRadius = 4.0f;
    bgView.clipsToBounds = YES;
    [view addSubview:bgView];
    
    UILabel * remindLab = [[UILabel alloc]init];
    remindLab.textColor = [UIColor whiteColor];
    CGFloat fontSize = 13.0*view.bounds.size.width/320.0f;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    remindLab.font = font;
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.numberOfLines = 0;
    remindLab.backgroundColor = [UIColor clearColor];
    remindLab.text = text;
    [bgView addSubview:remindLab];
    
    CGFloat width = [self sizeWithString:text UIHeight:view.bounds.size.height font:font].width;
    if (width>view.bounds.size.width/4.0*3.0f) {
        width = view.bounds.size.width/4.0*3.0f;
    }
    CGFloat height = [self sizeWithString:text UIWidth:width font:font].height;
    
    bgView.bounds = CGRectMake(0, 0, width+REMIND_TEXT_HUD_SIZE_EXPAND, height+REMIND_TEXT_HUD_SIZE_EXPAND);
    bgView.layer.position = CGPointMake(view.bounds.size.width/2.0f, view.bounds.size.height/2.0f);
    
    remindLab.bounds = CGRectMake(0, 0, width, height);
    remindLab.layer.position = CGPointMake(bgView.bounds.size.width/2.0f, bgView.bounds.size.height/2.0f);
    
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
}

#pragma mark - 获取当前界面VC
//*********************************************************

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

#pragma mark - 算高度
//*********************************************************

-(CGSize)sizeWithString:(NSString *)string UIWidth:(CGFloat)width font:(UIFont*)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}

-(CGSize)sizeWithString:(NSString *)string UIHeight:(CGFloat)height font:(UIFont*)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}

#pragma mark - CAAnimationDelegate
//*********************************************************

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([circleShapeLayer animationForKey:@"disappearCircleAnimation"] == anim) {
        
        [circleShapeLayer removeAnimationForKey:@"circleAnimation"];
        [circleShapeLayer removeAnimationForKey:@"disappearCircleAnimation"];
        
        [self shapeLayerCircleAnimation];
    }else if ([successShapeLayer animationForKey:@"successAnimation"] == anim) {
        
        CABasicAnimation *disappearSuccessAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        disappearSuccessAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        disappearSuccessAnimation.fromValue = @(1);
        disappearSuccessAnimation.toValue = @(0);
        disappearSuccessAnimation.duration = 1;
        disappearSuccessAnimation.repeatCount = 1;
        disappearSuccessAnimation.beginTime = CACurrentMediaTime() + 0.5;
        disappearSuccessAnimation.removedOnCompletion = NO;
        disappearSuccessAnimation.fillMode = kCAFillModeForwards;
        disappearSuccessAnimation.delegate = self;
        [successLayer addAnimation:disappearSuccessAnimation forKey:@"disappearSuccessAnimation"];
    }else if ([successLayer animationForKey:@"disappearSuccessAnimation"] == anim) {
        
        [successShapeLayer removeAllAnimations];
        [successLayer removeAllAnimations];
        [successLayer removeFromSuperlayer];
        
        UIView * view = [self getCurrentVC].view;
        view.userInteractionEnabled = YES;
    }else if ([errorShapeLayer animationForKey:@"errorAnimation"] == anim) {
        
        CABasicAnimation *disappearErrorAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        disappearErrorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        disappearErrorAnimation.fromValue = @(1);
        disappearErrorAnimation.toValue = @(0);
        disappearErrorAnimation.duration = 1;
        disappearErrorAnimation.repeatCount = 1;
        disappearErrorAnimation.beginTime = CACurrentMediaTime() + 0.5;
        disappearErrorAnimation.removedOnCompletion = NO;
        disappearErrorAnimation.fillMode = kCAFillModeForwards;
        disappearErrorAnimation.delegate = self;
        [errorLayer addAnimation:disappearErrorAnimation forKey:@"disappearErrorAnimation"];
    }else if ([errorLayer animationForKey:@"disappearErrorAnimation"] == anim) {
        
        [errorShapeLayer removeAllAnimations];
        [errorLayer removeAllAnimations];
        [errorLayer removeFromSuperlayer];
        
        UIView * view = [self getCurrentVC].view;
        view.userInteractionEnabled = YES;
    }
}

@end

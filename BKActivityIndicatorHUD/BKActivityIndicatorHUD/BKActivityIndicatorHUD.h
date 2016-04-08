//
//  BKActivityIndicatorHUD.h
//  BKActivityIndicatorHUD
//
//  Created by jollyColcors on 16/4/7.
//  Copyright © 2016年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BKActivityIndicatorStyle) {
    BKSlideMenuViewTitleWidthStyleScale = 0,               // 变小
    BKSlideMenuViewTitleWidthStyleOpacity                  // 变透明
};

@interface BKActivityIndicatorHUD : NSObject

+(instancetype)HUD;

-(void)showActivityIndicatorWithType:(BKActivityIndicatorStyle)style;

-(void)hideHUD;

-(void)showRemindTextHUDWithText:(NSString*)text;

@end

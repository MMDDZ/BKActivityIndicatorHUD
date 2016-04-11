//
//  BKActivityIndicatorHUD.h
//  BKActivityIndicatorHUD
//
//  Created by jollyColcors on 16/4/7.
//  Copyright © 2016年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define REMIND_TEXT_HUD_SIZE_EXPAND 15

typedef NS_ENUM(NSUInteger, BKActivityIndicatorStyle) {
    BKActivityIndicatorStyleScale = 0,                // 变小
    BKActivityIndicatorStyleOpacity,                  // 变透明
    BKActivityIndicatorStyleLoading,                  // Loading
};

@interface BKActivityIndicatorHUD : NSObject

@property (nonatomic,assign,readonly) BKActivityIndicatorStyle activityIndicatorStyle;

+(instancetype)HUD;

-(void)showActivityIndicatorWithType:(BKActivityIndicatorStyle)style;

-(void)hideHUD;

-(void)finishHUD;

-(void)errorHUD;

-(void)showRemindTextHUDWithText:(NSString*)text;

@end

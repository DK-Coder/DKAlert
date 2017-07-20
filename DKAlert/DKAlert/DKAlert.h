//
//  DKAlert.h
//  DKAlert
//
//  Created by NSLog on 2017/7/18.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import "DKBaseView.h"

typedef NS_ENUM(NSUInteger, DKImageAlertIconType) {
    DKImageAlertIconTypeNone = 0,
    DKImageAlertIconTypeSuccess,
    DKImageAlertIconTypeFailure,
    DKImageAlertIconTypeInfomation
};

@interface DKAlert : DKBaseView

#pragma mark 方法定义区
+ (void)dk_showAlertWithTitle:(NSString * _Nonnull)title message:(NSString * __nullable)message buttonTitles:(NSArray * _Nonnull)titles buttonTitleColors:(NSArray * __nullable)colors showAnimationType:(DKAlertShowAnimationType)showType dismissAnimationType:(DKAlertDismissAnimationType)dismissType action:(DKAlert_ButtonActionBlock __nullable)block;

/**
 *  显示一个alert，动画采用淡入淡出的方式
 */
+ (void)dk_showAlertWithTitle:(NSString * _Nonnull)title message:(NSString * __nullable)message buttonTitles:(NSArray * _Nonnull)titles buttonTitleColors:(NSArray * __nullable)colors action:(DKAlert_ButtonActionBlock __nullable)block;

+ (void)dk_showImageAlertWithIconType:(DKImageAlertIconType)iconType message:(NSString * __nullable)message buttonTitles:(NSArray * _Nonnull)titles buttonTitleColors:(NSArray * __nullable)colors showAnimationType:(DKAlertShowAnimationType)showType dismissAnimationType:(DKAlertDismissAnimationType)dismissType action:(DKAlert_ButtonActionBlock __nullable)block;
@end

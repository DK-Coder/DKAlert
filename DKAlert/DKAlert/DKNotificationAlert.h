//
//  DKNotificationAlert.h
//  DKAlert
//
//  Created by NSLog on 2017/7/24.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import "DKBaseView.h"

@class DKNotificationAlert;
@protocol DKNotificationAlertDelegate <NSObject>

@optional
- (void)didClickOnNotificationAlert:(DKNotificationAlert * _Nonnull)alert;

@end

@interface DKNotificationAlert : DKBaseView

@property (nullable, nonatomic, copy) NSString *alertImageName; /**< 通知的图标名称，目前暂只支持项目内部图片名称，不支持url*/
@property (nullable, nonatomic, copy) NSString *alertTitleContent; /**< 通知显示的标题内容*/
@property (nullable, nonatomic, copy) NSString *alertMessage; /**< 通知显示的信息内容*/
@property (nonatomic) NSInteger alertLastSeconds; /**< 通知显示的持续时间，默认3秒*/
@property (nullable, nonatomic, weak) id<DKNotificationAlertDelegate> dk_delegate;
@property (nonatomic) DKAlertIconType alertIconType;

@property (nullable, nonatomic, strong) UIColor *alertTitleContentColor;
@property (nullable, nonatomic, strong) UIColor *alertMessageColor;

+ (instancetype __nullable)sharedInstance;

+ (void)dk_showNotificationWithIconType:(DKAlertIconType)type imageName:(NSString * __nullable)imageName title:(NSString * __nullable)title message:(NSString * __nullable)message delegate:(id __nullable)delegate;

+ (void)dk_showInfomationNotificationWithTitle:(NSString * __nullable)title message:(NSString * __nullable)message delegate:(id __nullable)delegate;
@end

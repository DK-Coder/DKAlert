//
//  DKBaseView.h
//  DKAlert
//
//  Created by NSLog on 2017/7/18.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+DKExtension.h"

@protocol DKBaseViewDelegate <NSObject>

@optional
- (void)sharedInit;
- (CGPathRef _Nonnull)generatePathByDirection:(NSUInteger)direction;

@required
- (void)dk_layoutAlert;

@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define rgba(r, g, b, a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define rgb(r, g, b) rgba(r, g, b, 1)
#define weakifySelf() __weak typeof(self) weakSelf = self
#define strongifySelf() __strong typeof(weakSelf) strongSelf = weakSelf

typedef NS_ENUM(NSUInteger, DKAlertShowAnimationType) {
    DKAlertShowAnimationTypeFadeIn = 0,
    DKAlertShowAnimationTypeFromTop,
    DKAlertShowAnimationTypeFromBottom,
    DKAlertShowAnimationTypeFromLeft,
    DKAlertShowAnimationTypeFromRight
};

typedef NS_ENUM(NSUInteger, DKAlertDismissAnimationType) {
    DKAlertDismissAnimationTypeFadeOut = 100,
    DKAlertDismissAnimationTypeToTop,
    DKAlertDismissAnimationTypeToBottom,
    DKAlertDismissAnimationTypeToLeft,
    DKAlertDismissAnimationTypeToRight
};

typedef NS_ENUM(NSUInteger, DKAlertIconType) {
    DKAlertIconTypeNone = 0,
    DKAlertIconTypeSuccess,
    DKAlertIconTypeFailure,
    DKAlertIconTypeInfomation,
    DKAlertIconTypeSuccessCircle,
    DKAlertIconTypeFailureCircle,
    DKAlertIconTypeInfomationCircle,
    DKAlertIconTypeCustom
};

typedef void(^DKAlert_ButtonActionBlock)(NSInteger index);
typedef void(^DKAlert_AnimationEndBlock)();

static NSTimeInterval DEFAULT_ANIMATION_DURATION = .4f;
static CGFloat DEFAULT_BUTTON_HEIGHT = 50.f;
static CGFloat DEFAULT_LINE_HEIGHT_OR_WIDTH = .5f;

@interface DKBaseView : UIView <DKBaseViewDelegate>
{
    NSString *alertTitle;
    NSArray *arrayButtonTitles;
    NSArray *arrayButtonTitleColors;
    
    CGFloat padding;
}
@property (nullable, nonatomic, strong) UIWindow *userWindow;

@property (nullable, nonatomic, strong) UIView *dk_coverView;

@property (nonatomic, getter=isNeedCoverView) BOOL needCoverView;

@property (nonatomic) DKAlertShowAnimationType dk_showAnimationType;

@property (nonatomic) DKAlertDismissAnimationType dk_dismissAnimationType;

@property (nullable, nonatomic, copy) DKAlert_ButtonActionBlock actionBlock;

@property (nullable, nonatomic, copy) DKAlert_AnimationEndBlock animationEndBlock;

- (void)dk_showAlert;

- (void)dk_dismissAlert;

- (UIButton * _Nonnull)addButtonOnView:(UIView * _Nonnull)view tag:(NSInteger)tag backgroundColor:(UIColor * __nullable)bgColor title:(NSString * _Nonnull)title titleColor:(UIColor * _Nonnull)titleColor;

- (UIButton * _Nonnull)addButtonOnView:(UIView * _Nonnull)view atIndex:(NSInteger)index;

- (UIView * _Nonnull)addLineOnView:(UIView * _Nonnull)view topToView:(UIView * __nullable)topView width:(CGFloat)width marginTop:(CGFloat)top;

- (UIView * _Nonnull)addVerticalLineOnView:(UIView * _Nonnull)view leftToView:(UIView * __nullable)leftView height:(CGFloat)height marginLeft:(CGFloat)left;

- (NSArray * __nullable)getButtonsOnView;

- (NSArray * __nullable)getLinesOnView;

- (NSString * __nullable)getIconFileNameByIconType:(DKAlertIconType)type;
@end

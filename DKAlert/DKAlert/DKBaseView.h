//
//  DKBaseView.h
//  DKAlert
//
//  Created by NSLog on 2017/7/18.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DKBaseViewDelegate <NSObject>

@optional
- (void)sharedInit;
- (CGPathRef)generatePathByDirection:(NSUInteger)direction;

@required
- (void)dk_layoutAlert;

@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define rgba(r, g, b, a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define rgb(r, g, b) rgba(r, g, b, 1)

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

typedef void(^DKAlert_ButtonActionBlock)(NSInteger index);

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

@property (nonatomic, strong, readonly) NSMutableArray *arrayButtons;

@property (nonatomic) DKAlertShowAnimationType dk_showAnimationType;

@property (nonatomic) DKAlertDismissAnimationType dk_dismissAnimationType;

@property (nonatomic, copy) DKAlert_ButtonActionBlock actionBlock;

- (void)dk_showAlert;

- (void)dk_dismissAlert;

- (UIButton *)addButtonWithTag:(NSInteger)tag backgroundColor:(UIColor *)bgColor title:(NSString *)title titleColor:(UIColor *)titleColor;

- (UIButton *)addButtonAtIndex:(NSInteger)index;

- (UIView *)addLineUpToView:(UIView *)view width:(CGFloat)width marginTop:(CGFloat)top;

- (UIView *)addVerticalLineLeftToView:(UIView *)view height:(CGFloat)height marginLeft:(CGFloat)left;
@end

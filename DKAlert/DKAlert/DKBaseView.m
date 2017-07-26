//
//  DKBaseView.m
//  DKAlert
//
//  Created by NSLog on 2017/7/18.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import "DKBaseView.h"
#import "CALayer+DKAnimation.h"

@interface DKBaseView ()
{
    
}
@property (nonatomic, strong) UIColor *dk_coverViewBackgroundColor;
@property (nonatomic, strong) NSMutableArray *arrayButtons;
@property (nonatomic, strong) NSMutableArray *arrayLines;
@end


@implementation DKBaseView

- (instancetype)init
{
    NSAssert(![self isMemberOfClass:[DKBaseView class]], @"DKBaseView不能直接被使用，请使用它的子类");
    return [super init];
}

- (void)sharedInit
{
    self.backgroundColor = [UIColor whiteColor];
    
    padding = 10.f;
    
    self.dk_showAnimationType = DKAlertShowAnimationTypeFadeIn;
    self.dk_dismissAnimationType = DKAlertDismissAnimationTypeFadeOut;
    self.dk_coverViewBackgroundColor = [UIColor colorWithWhite:0.f alpha:.4f];
    self.needCoverView = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dk_showAlert
{
    if (self.isNeedCoverView) {
        [self.userWindow addSubview:self.dk_coverView];
    }
    [self.userWindow addSubview:self];
    [self.userWindow bringSubviewToFront:self];
    
    [self dk_layoutAlert];
    
    [_dk_coverView.layer addAlphaAnimationWithDuration:DEFAULT_ANIMATION_DURATION from:0.f to:1.f animationKey:@"alphaAnimation" complete:nil];
    
    if (self.dk_showAnimationType != DKAlertShowAnimationTypeFadeIn) {
        CGPathRef path = [self generatePathByDirection:self.dk_showAnimationType];
        [self.layer addKeyframeAnimationWithDuration:DEFAULT_ANIMATION_DURATION path:path animationKey:@"showAnimation" complete:nil];
    } else {
        [self.layer addAlphaAnimationWithDuration:DEFAULT_ANIMATION_DURATION from:0.f to:1.f animationKey:@"alphaAnimation" complete:nil];
    }
}

- (void)dk_dismissAlert
{
    weakifySelf();
    if (self.dk_dismissAnimationType != DKAlertDismissAnimationTypeFadeOut) {
        CGPathRef path = [self generatePathByDirection:self.dk_dismissAnimationType];
        [self.layer addKeyframeAnimationWithDuration:DEFAULT_ANIMATION_DURATION path:path animationKey:@"dismissAnimation" complete:^{
            strongifySelf();
            if (strongSelf.animationEndBlock) {
                strongSelf.animationEndBlock();
            }
            [strongSelf destroy];
        }];
    } else {
        [self.layer addAlphaAnimationWithDuration:DEFAULT_ANIMATION_DURATION from:1.f to:0.f animationKey:@"dismissAnimation" complete:^{
            strongifySelf();
            if (strongSelf.animationEndBlock) {
                strongSelf.animationEndBlock();
            }
            [strongSelf destroy];
        }];
    }
}

- (void)dk_layoutAlert
{
    _dk_coverView.frame = self.window.bounds;
    
    [self clearAllButtonsAndLines];
}

#pragma mark 内部方式实现
- (NSArray *)getButtonsOnView
{
    return [_arrayButtons copy];
}

- (NSArray *)getLinesOnView
{
    return [_arrayLines copy];
}

- (UIButton *)addButtonOnView:(UIView *)view tag:(NSInteger)tag backgroundColor:(UIColor *)bgColor title:(NSString *)title titleColor:(UIColor *)titleColor
{
    UIButton *btnAction = [[UIButton alloc] init];
    btnAction.tag = tag;
    btnAction.backgroundColor = bgColor ?: [UIColor whiteColor];
    [btnAction setTitle:title forState:UIControlStateNormal];
    [btnAction setTitleColor:titleColor forState:UIControlStateNormal];
    [btnAction setBackgroundImage:[UIImage createImageWithColor:rgb(245, 245, 245)] forState:UIControlStateHighlighted];
//    [btnAction addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [btnAction addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
//    [btnAction addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit];
    [view addSubview:btnAction];
    [self.arrayButtons addObject:btnAction];
    
    return btnAction;
}

- (UIButton *)addButtonOnView:(UIView *)view atIndex:(NSInteger)index
{
    return [self addButtonOnView:view tag:index backgroundColor:[UIColor whiteColor] title:arrayButtonTitles[index] titleColor:[self buttonTitleColorAtIndex:index]];
}

- (UIColor *)buttonTitleColorAtIndex:(NSInteger)index
{
    UIColor *titleColor = nil;
    if (arrayButtonTitleColors.count > index) {
        titleColor = arrayButtonTitleColors[index];
    } else {
        titleColor = [UIColor blackColor];
    }
    
    return titleColor;
}

- (UIView *)addLineOnView:(UIView *)view topToView:(UIView *)topView width:(CGFloat)width marginTop:(CGFloat)top
{
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake((CGRectGetWidth(self.frame) - width) / 2, CGRectGetMaxY(topView.frame) + top, width, DEFAULT_LINE_HEIGHT_OR_WIDTH);
    line.backgroundColor = rgb(186, 186, 186);
    [view addSubview:line];
    [_arrayLines addObject:line];
    
    return line;
}

- (UIView *)addVerticalLineOnView:(UIView *)view leftToView:(UIView *)leftView height:(CGFloat)height marginLeft:(CGFloat)left
{
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(CGRectGetMaxX(leftView.frame) + left, CGRectGetMinY(leftView.frame), DEFAULT_LINE_HEIGHT_OR_WIDTH, height);
    line.backgroundColor = rgb(186, 186, 186);
    [view addSubview:line];
    [_arrayLines addObject:line];
    
    return line;
}

- (void)clearAllButtonsAndLines
{
    if (self.arrayButtons) {
        for (UIButton *button in self.arrayButtons) {
            [button removeFromSuperview];
        }
    }
    if (self.arrayLines) {
        for (UIView *line in self.arrayLines) {
            [line removeFromSuperview];
        }
    }
}

- (void)handleDeviceOrientationRotateAction:(NSNotification *)notification
{
    [self dk_layoutAlert];
}

- (void)actionButtonPressed:(UIButton *)sender
{
    [self dk_dismissAlert];
    NSInteger tag = sender.tag;
    if (self.actionBlock) {
        self.actionBlock(tag);
    }
}

- (void)buttonTouched:(UIButton *)sender
{
    sender.backgroundColor = rgb(245, 245, 245);
}

- (void)buttonReleased:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
}

- (void)destroy
{
    if (self.dk_showAnimationType != DKAlertShowAnimationTypeFadeIn) {
        [self.layer removeAllAnimations];
    }
    [self.dk_coverView.layer removeAnimationForKey:@"alphaAnimation"];
    
    [self removeFromSuperview];
    [self.dk_coverView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self destroy];
}

- (NSString *)getIconFileNameByIconType:(DKAlertIconType)type
{
    NSString *fileName = nil;
    switch (type) {
        case DKAlertIconTypeSuccess:
            fileName = @"images.bundle/correct";
            break;
        case DKAlertIconTypeFailure:
            fileName = @"images.bundle/error";
            break;
        case DKAlertIconTypeInfomation:
            fileName = @"images.bundle/info";
            break;
        case DKAlertIconTypeSuccessCircle:
            fileName = @"images.bundle/correct-circle";
            break;
        case DKAlertIconTypeFailureCircle:
            fileName = @"images.bundle/error-circle";
            break;
        case DKAlertIconTypeInfomationCircle:
            fileName = @"images.bundle/info-circle";
            break;
        case DKAlertIconTypeNone:
        case DKAlertIconTypeCustom:
            break;
    }
    
    return fileName;
}
#pragma mark getter/setter
- (UIWindow *)userWindow
{
    if (!_userWindow) {
        _userWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _userWindow;
}
- (NSMutableArray *)arrayButtons
{
    if (!_arrayButtons) {
        _arrayButtons = [[NSMutableArray alloc] init];
    }
    return _arrayButtons;
}

- (NSMutableArray *)arrayLines
{
    if (!_arrayLines) {
        _arrayLines = [[NSMutableArray alloc] init];
    }
    return _arrayLines;
}

- (UIView *)dk_coverView
{
    if (!_dk_coverView) {
        _dk_coverView = [[UIView alloc] init];
        _dk_coverView.frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT);
        _dk_coverView.backgroundColor = self.dk_coverViewBackgroundColor;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dk_dismissAlert)];
        [_dk_coverView addGestureRecognizer:tapGesture];
    }
    return _dk_coverView;
}
@end

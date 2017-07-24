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
@property (nonatomic, readonly) UIView *dk_coverView;
@property (nonatomic, strong) UIColor *dk_coverViewBackgroundColor;
@property (nonatomic, strong, readonly) NSMutableArray *arrayLines;
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
    
    _arrayButtons = [[NSMutableArray alloc] init];
    _arrayLines = [[NSMutableArray alloc] init];
    
    _dk_coverView = [[UIView alloc] init];
    _dk_coverView.frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT);
    _dk_coverView.backgroundColor = self.dk_coverViewBackgroundColor;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dk_dismissAlert)];
    [_dk_coverView addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dk_showAlert
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.dk_coverView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
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
    __weak typeof(self) weakSelf = self;
    if (self.dk_dismissAnimationType != DKAlertDismissAnimationTypeFadeOut) {
        CGPathRef path = [self generatePathByDirection:self.dk_dismissAnimationType];
        [self.layer addKeyframeAnimationWithDuration:DEFAULT_ANIMATION_DURATION path:path animationKey:@"dismissAnimation" complete:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf destroy];
        }];
    } else {
        [self.layer addAlphaAnimationWithDuration:DEFAULT_ANIMATION_DURATION from:1.f to:0.f animationKey:@"dismissAnimation" complete:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf destroy];
        }];
    }
}

- (void)dk_layoutAlert
{
    self.dk_coverView.frame = self.window.bounds;
    
    [self clearAllButtonsAndLines];
}

#pragma mark 内部方式实现
- (UIButton *)addButtonWithTag:(NSInteger)tag backgroundColor:(UIColor *)bgColor title:(NSString *)title titleColor:(UIColor *)titleColor
{
    UIButton *btnAction = [[UIButton alloc] init];
    btnAction.tag = tag;
    btnAction.backgroundColor = bgColor ?: [UIColor whiteColor];
    [btnAction setTitle:title forState:UIControlStateNormal];
    [btnAction setTitleColor:titleColor forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnAction addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [btnAction addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit];
    [self addSubview:btnAction];
    [self.arrayButtons addObject:btnAction];
    
    return btnAction;
}

- (UIButton *)addButtonAtIndex:(NSInteger)index
{
    return [self addButtonWithTag:index backgroundColor:[UIColor whiteColor] title:arrayButtonTitles[index] titleColor:[self buttonTitleColorAtIndex:index]];
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

- (UIView *)addLineUpToView:(UIView *)view width:(CGFloat)width marginTop:(CGFloat)top
{
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake((CGRectGetWidth(self.frame) - width) / 2, CGRectGetMaxY(view.frame) + top, width, DEFAULT_LINE_HEIGHT_OR_WIDTH);
    line.backgroundColor = rgb(186, 186, 186);
    [self addSubview:line];
    [_arrayLines addObject:line];
    
    return line;
}

- (UIView *)addVerticalLineLeftToView:(UIView *)view height:(CGFloat)height marginLeft:(CGFloat)left
{
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(CGRectGetMaxX(view.frame) + left, CGRectGetMinY(view.frame), DEFAULT_LINE_HEIGHT_OR_WIDTH, height);
    line.backgroundColor = rgb(186, 186, 186);
    [self addSubview:line];
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
    sender.backgroundColor = [UIColor clearColor];
}

#pragma mark getter/setter
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
@end

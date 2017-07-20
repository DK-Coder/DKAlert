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

- (UIView *)addLineUpToView:(UIView *)view width:(CGFloat)width marginTop:(CGFloat)top
{
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake((CGRectGetWidth(self.frame) - width) / 2, CGRectGetMaxY(view.frame) + top, width, .5f);
    line.backgroundColor = rgb(186, 186, 186);
    [self addSubview:line];
    [_arrayLines addObject:line];
    
    return line;
}

- (UIView *)addVerticalLineLeftToView:(UIView *)view height:(CGFloat)height needMarginLeft:(BOOL)isNeed
{
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(CGRectGetMaxX(view.frame) + (isNeed ? padding : 0.f), CGRectGetMinY(view.frame), .5f, height);
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

#pragma mark getter/setter
- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.font = [UIFont boldSystemFontOfSize:18.f];
        [self addSubview:_labelTitle];
    }
    return _labelTitle;
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
@end

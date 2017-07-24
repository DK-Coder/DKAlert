//
//  CALayer+DKAnimation.m
//  DKAlert
//
//  Created by NSLog on 2017/7/19.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import "CALayer+DKAnimation.h"

@implementation CALayer (DKAnimation)

- (void)addKeyframeAnimationWithDuration:(NSTimeInterval)duration path:(CGPathRef)path animationKey:(NSString *)key complete:(void (^)())block
{
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyframeAnimation.duration = duration;
    keyframeAnimation.path = path;
    keyframeAnimation.fillMode = kCAFillModeForwards;
    keyframeAnimation.removedOnCompletion = NO;
    keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self addAnimation:keyframeAnimation forKey:key];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration - .1f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

- (void)addAlphaAnimationWithDuration:(NSTimeInterval)duration from:(CGFloat)fromValue to:(CGFloat)toValue animationKey:(NSString *)key complete:(void (^)())block
{
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.duration = duration;
    alphaAnimation.fromValue = @(fromValue);
    alphaAnimation.toValue = @(toValue);
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.removedOnCompletion = NO;
    [self addAnimation:alphaAnimation forKey:key];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration - .1f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}
@end

//
//  CALayer+DKAnimation.h
//  DKAlert
//
//  Created by NSLog on 2017/7/19.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (DKAnimation)

- (void)addKeyframeAnimationWithDuration:(NSTimeInterval)duration path:(CGPathRef)path animationKey:(NSString *)key complete:(void(^)())block;

- (void)addAlphaAnimationWithDuration:(NSTimeInterval)duration from:(CGFloat)fromValue to:(CGFloat)toValue animationKey:(NSString *)key complete:(void(^)())block;
@end

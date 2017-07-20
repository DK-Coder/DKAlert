//
//  DKActionSheet.m
//  DKAlert
//
//  Created by NSLog on 2017/7/20.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import "DKActionSheet.h"

@interface DKActionSheet ()
{
    
}
@end


@implementation DKActionSheet

- (instancetype)initWithTitle:(NSString *)title buttonTitles:(NSArray *)titles buttonTitleColors:(NSArray *)colors
{
    self = [super init];
    if (self) {
        alertTitle = title;
        arrayButtonTitles = titles;
        arrayButtonTitleColors = colors;
        
        [self sharedInit];
    }
    return self;
}

- (void)dk_layoutAlert
{
    [super dk_layoutAlert];
    
    CGFloat widthForActionSheet = SCREEN_WIDTH;
    self.frame = CGRectMake(0.f, 0.f, widthForActionSheet, 0.f);
    if (alertTitle.length != 0) {
        // 标题
        self.labelTitle.text = alertTitle;
        CGSize sizeForTitle = [self.labelTitle sizeThatFits:CGSizeMake(widthForActionSheet - padding * 2, CGFLOAT_MAX)];
        self.labelTitle.frame = CGRectMake(padding, padding, widthForActionSheet - padding * 2, sizeForTitle.height);
        [self addLineUpToView:self.labelTitle width:widthForActionSheet marginTop:padding];
    } else {
        padding = 0.f;
    }
    // 布局按钮
    CGFloat height = [self layoutButtons];
    
    CGFloat heightForActionSheet = CGRectGetMaxY(self.labelTitle.frame) + padding + height;
    self.frame = CGRectMake(0.f, SCREEN_HEIGHT - heightForActionSheet, widthForActionSheet, heightForActionSheet);
}

- (CGPathRef)generatePathByDirection:(NSUInteger)direction
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (direction) {
        case DKAlertShowAnimationTypeFromBottom:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT + CGRectGetHeight(self.frame) / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - CGRectGetHeight(self.frame) / 2)];
            break;
        case DKAlertDismissAnimationTypeToBottom:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - CGRectGetHeight(self.frame) / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT + CGRectGetHeight(self.frame) / 2)];
            break;
    }
    
    return path.CGPath;
}

#pragma mark 内部方法实现
- (CGFloat)layoutButtons
{
    // 添加一个“取消”选项
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:arrayButtonTitles];
    [tempArray addObject:@"取消"];
    arrayButtonTitles = [tempArray copy];
    
    NSInteger numberOfButtons = arrayButtonTitles.count;
    CGFloat height = DEFAULT_BUTTON_HEIGHT * numberOfButtons;
    for (NSInteger i = 0; i < numberOfButtons; i++) {
        UIButton *btnAction = [[UIButton alloc] init];
        btnAction.tag = i;
        btnAction.frame = CGRectMake(0.f, CGRectGetMaxY(self.labelTitle.frame) + padding + DEFAULT_BUTTON_HEIGHT * i, SCREEN_WIDTH, DEFAULT_BUTTON_HEIGHT);
        [btnAction setTitle:arrayButtonTitles[i] forState:UIControlStateNormal];
        if (i == numberOfButtons - 1) {
            [btnAction setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [btnAction setTitleColor:[self buttonTitleColorAtIndex:i] forState:UIControlStateNormal];
        }
        [btnAction addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnAction];
        [self.arrayButtons addObject:btnAction];
        [self addLineUpToView:btnAction width:CGRectGetWidth(btnAction.frame) marginTop:0.f];
    }
    
    return height;
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

- (void)buttonPressed:(UIButton *)sender
{
    [self dk_dismissAlert];
    NSInteger tag = sender.tag;
    if (self.actionBlock) {
        self.actionBlock(tag);
    }
}

#pragma mark 对外方法实现
+ (void)showActionSheetWithTitle:(NSString *)title buttonTitles:(NSArray *)titles buttonTitleColors:(NSArray *)colors action:(DKAlert_ButtonActionBlock)block
{
    DKActionSheet *actionSheet = [[DKActionSheet alloc] initWithTitle:title buttonTitles:titles buttonTitleColors:colors];
    actionSheet.dk_showAnimationType = DKAlertShowAnimationTypeFromBottom;
    actionSheet.dk_dismissAnimationType = DKAlertDismissAnimationTypeToBottom;
    actionSheet.actionBlock = block;
    
    [actionSheet dk_showAlert];
}
@end

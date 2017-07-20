//
//  DKAlert.m
//  DKAlert
//
//  Created by NSLog on 2017/7/18.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import "DKAlert.h"

@interface DKAlert ()
{
    NSString *alertMessage;
}
@property (nonatomic, strong) UITextView *textViewContent;
@end

@implementation DKAlert

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSArray *)titles buttonTitleColors:(NSArray *)colors
{
    self = [super init];
    if (self) {
        alertTitle = title;
        alertMessage = message;
        arrayButtonTitles = titles;
        arrayButtonTitleColors = colors;
        
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    [super sharedInit];
    
    self.layer.cornerRadius = 10.f;
    
    self.labelTitle.text = alertTitle;
    self.textViewContent.text = alertMessage;
}

- (void)dk_layoutAlert
{
    [super dk_layoutAlert];
    
    CGFloat widthForAlert = SCREEN_WIDTH * .7f;
    self.frame = CGRectMake(0.f, 0.f, widthForAlert, 0.f);
    if (!alertMessage || alertMessage.length == 0) {
        alertMessage = alertTitle;
        alertTitle = nil;
        
        self.labelTitle.text = alertTitle;
        self.textViewContent.text = alertMessage;
        self.textViewContent.font = self.labelTitle.font;
    }
    // 标题
    CGSize sizeForTitle = [self.labelTitle sizeThatFits:CGSizeMake(widthForAlert - padding * 2, CGFLOAT_MAX)];
    self.labelTitle.frame = CGRectMake(padding, padding, widthForAlert - padding * 2, sizeForTitle.height);
    // 我是一条分割线
    UIView *line1 = [self addLineUpToView:self.labelTitle width:CGRectGetWidth(self.labelTitle.frame) needMarginTop:YES];
    if (!alertTitle || alertTitle.length == 0) {
        CGRect frameForLine1 = line1.frame;
        frameForLine1.size.height = 0.f;
        line1.frame = frameForLine1;
    }
    // 内容
    CGSize sizeForMessage = [self.textViewContent sizeThatFits:CGSizeMake(widthForAlert - padding * 2, CGFLOAT_MAX)];
    CGFloat maxHeightForMessage = (SCREEN_HEIGHT - DEFAULT_BUTTON_HEIGHT * arrayButtonTitles.count - padding * 4 - sizeForTitle.height);
    CGFloat heightForMessage = sizeForMessage.height > maxHeightForMessage ? maxHeightForMessage : sizeForMessage.height;
    self.textViewContent.frame = CGRectMake(padding, CGRectGetMaxY(line1.frame) + padding, widthForAlert - padding * 2, heightForMessage);
    // 我是一条分割线
    [self addLineUpToView:self.textViewContent width:widthForAlert needMarginTop:YES];
    // 布局按钮
    CGFloat heightForButtons = [self layoutButtons];
    
    self.frame = CGRectMake(0.f, 0.f, widthForAlert, padding * 4 + CGRectGetHeight(self.labelTitle.frame) + CGRectGetHeight(self.textViewContent.frame) + heightForButtons);
    self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
}

- (CGPathRef)generatePathByDirection:(NSUInteger)direction
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (direction) {
        case DKAlertShowAnimationTypeFromTop:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, -SCREEN_HEIGHT / 2 - CGRectGetHeight(self.frame) / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
            break;
        case DKAlertShowAnimationTypeFromBottom:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT + CGRectGetHeight(self.frame) / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
            break;
        case DKAlertShowAnimationTypeFromLeft:
            [path moveToPoint:CGPointMake(-SCREEN_WIDTH - CGRectGetWidth(self.frame) / 2, SCREEN_HEIGHT / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
            break;
        case DKAlertShowAnimationTypeFromRight:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH + CGRectGetWidth(self.frame) / 2, SCREEN_HEIGHT / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
            break;
        case DKAlertDismissAnimationTypeToTop:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, -SCREEN_HEIGHT / 2 - CGRectGetHeight(self.frame) / 2)];
            break;
        case DKAlertDismissAnimationTypeToBottom:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT + CGRectGetHeight(self.frame) / 2)];
            break;
        case DKAlertDismissAnimationTypeToLeft:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
            [path addLineToPoint:CGPointMake(-SCREEN_WIDTH - CGRectGetWidth(self.frame) / 2, SCREEN_HEIGHT / 2)];
            break;
        case DKAlertDismissAnimationTypeToRight:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH + CGRectGetWidth(self.frame) / 2, SCREEN_HEIGHT / 2)];
            break;
    }
    return path.CGPath;
}

- (CGFloat)layoutButtons
{
    CGFloat height = 0.f;
    if (arrayButtonTitles.count == 1) {
        height = DEFAULT_BUTTON_HEIGHT;
        
        UIButton *btnAction = [self addButtonAtIndex:0];
        btnAction.frame = CGRectMake(0.f, CGRectGetMaxY(self.textViewContent.frame) + padding, CGRectGetWidth(self.frame), DEFAULT_BUTTON_HEIGHT);
    } else if (arrayButtonTitles.count == 2) {
        height = DEFAULT_BUTTON_HEIGHT;
        
        CGFloat widthForButton = CGRectGetWidth(self.frame) / 2;
        for (NSInteger i = 0; i < 2; i++) {
            UIButton *btnAction = [self addButtonAtIndex:i];
            btnAction.frame = CGRectMake(widthForButton * i, CGRectGetMaxY(self.textViewContent.frame) + padding, widthForButton, DEFAULT_BUTTON_HEIGHT);
            if (i == 0) {
                [self addVerticalLineLeftToView:btnAction height:DEFAULT_BUTTON_HEIGHT needMarginLeft:NO];
            }
        }
    } else {
        height = arrayButtonTitles.count * DEFAULT_BUTTON_HEIGHT;
        for (NSInteger i = 0, length = arrayButtonTitles.count; i < length; i++) {
            UIButton *btnAction = [self addButtonAtIndex:i];
            btnAction.frame = CGRectMake(0.f, CGRectGetMaxY(self.textViewContent.frame) + padding + i * DEFAULT_BUTTON_HEIGHT, CGRectGetWidth(self.frame), DEFAULT_BUTTON_HEIGHT);
            [self addLineUpToView:btnAction width:CGRectGetWidth(self.frame) needMarginTop:NO];
        }
    }
    
    return height;
}

- (UIButton *)addButtonAtIndex:(NSInteger)index
{
    UIButton *btnAction = [[UIButton alloc] init];
    [btnAction setTag:index];
    [btnAction setTitle:arrayButtonTitles[index] forState:UIControlStateNormal];
    [btnAction setTitleColor:[self buttonTitleColorAtIndex:index] forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnAction];
    [self.arrayButtons addObject:btnAction];
    
    return btnAction;
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

- (void)actionButtonPressed:(UIButton *)sender
{
    [self dk_dismissAlert];
    NSInteger tag = sender.tag;
    if (self.actionBlock) {
        self.actionBlock(tag);
    }
}

#pragma 对外方法实现
+ (void)dk_showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)titles buttonTitleColors:(NSArray *)colors showAnimationType:(DKAlertShowAnimationType)showType dismissAnimationType:(DKAlertDismissAnimationType)dismissType action:(DKAlert_ButtonActionBlock)block
{
    DKAlert *alertView = [[DKAlert alloc] initWithTitle:title message:message buttonTitle:titles buttonTitleColors:colors];
    alertView.dk_showAnimationType = showType;
    alertView.dk_dismissAnimationType = dismissType;
    alertView.actionBlock = block;
    
    [alertView dk_showAlert];
}

+ (void)dk_showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)titles buttonTitleColors:(NSArray *)colors action:(DKAlert_ButtonActionBlock)block
{
    DKAlert *alertView = [[DKAlert alloc] initWithTitle:title message:message buttonTitle:titles buttonTitleColors:colors];
    alertView.actionBlock = block;
    
    [alertView dk_showAlert];
}

#pragma mark getter/setter
- (UITextView *)textViewContent
{
    if (!_textViewContent) {
        _textViewContent = [[UITextView alloc] init];
        _textViewContent.font = [UIFont systemFontOfSize:16.f];
        _textViewContent.textAlignment = NSTextAlignmentCenter;
        _textViewContent.editable = NO;
        _textViewContent.selectable = NO;
        [self addSubview:_textViewContent];
    }
    return _textViewContent;
}
@end

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
    NSString *cancelButtonTitle;
    UIColor *cancelButtonTitleColor;
}
@property (nonatomic, strong) UILabel *labelTitle;
@end

@implementation DKActionSheet

- (instancetype)initWithTitle:(NSString *)title otherButtonTitles:(NSArray *)titles otherButtonTitleColors:(NSArray *)colors cancelButtonTitle:(NSString *)cancelTitle cancelButtonTitleColor:(UIColor *)cancelTitleColor
{
    self = [super init];
    if (self) {
        alertTitle = title;
        arrayButtonTitles = titles;
        arrayButtonTitleColors = colors;
        cancelButtonTitle = cancelTitle;
        cancelButtonTitleColor = cancelTitleColor;
        
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    [super sharedInit];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)dk_layoutAlert
{
    [super dk_layoutAlert];
    
    CGFloat widthForActionSheet = SCREEN_WIDTH;
    self.frame = CGRectMake(0.f, 0.f, widthForActionSheet, 0.f);
    UIView *labelBottomLine = nil;
    if (alertTitle.length != 0) {
        // 标题
        self.labelTitle.text = alertTitle;
        self.labelTitle.frame = CGRectMake(0.f, 0.f, widthForActionSheet, 60.f);
        labelBottomLine = [self addLineUpToView:self.labelTitle width:widthForActionSheet marginTop:0.f];
    } else {
//        padding = 0.f;
    }
    // 布局按钮
    CGFloat height = [self layoutButtonsReferenceView:labelBottomLine];
    
    CGFloat heightForActionSheet = CGRectGetMaxY(self.labelTitle.frame) + height;
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
- (CGFloat)layoutButtonsReferenceView:(UIView *)view
{
    NSInteger numberOfButtons = arrayButtonTitles.count;
    CGFloat height = DEFAULT_BUTTON_HEIGHT * numberOfButtons + (numberOfButtons - 1) * DEFAULT_LINE_HEIGHT_OR_WIDTH;
    for (NSInteger i = 0; i < numberOfButtons; i++) {
        UIButton *btnAction = [self addButtonAtIndex:i];
        btnAction.frame = CGRectMake(0.f, CGRectGetMaxY(view.frame) + (DEFAULT_BUTTON_HEIGHT + DEFAULT_LINE_HEIGHT_OR_WIDTH) * i, SCREEN_WIDTH, DEFAULT_BUTTON_HEIGHT);
        if (i != numberOfButtons - 1) {
            [self addLineUpToView:btnAction width:CGRectGetWidth(btnAction.frame) marginTop:0.f];
        }
    }
    if (cancelButtonTitle && cancelButtonTitle.length > 0) {
        // 添加取消按钮
        UIButton *previousButton = [[self getButtonsOnView] lastObject];
        UIButton *btnCancel = [self addButtonWithTag:numberOfButtons backgroundColor:nil title:cancelButtonTitle titleColor:cancelButtonTitleColor];
        btnCancel.frame = CGRectMake(0.f, CGRectGetMaxY(previousButton.frame) + padding, CGRectGetWidth(previousButton.frame), DEFAULT_BUTTON_HEIGHT);
        
        height += (padding + DEFAULT_BUTTON_HEIGHT);
    }
    
    return height;
}

#pragma mark 对外方法实现
+ (void)dk_showActionSheetWithTitle:(NSString *)title otherButtonTitles:(NSArray *)titles otherButtonTitleColors:(NSArray *)colors cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonTitleColor:(UIColor *)cancelButtonTitleColor action:(DKAlert_ButtonActionBlock)block
{
    DKActionSheet *actionSheet = [[DKActionSheet alloc] initWithTitle:title otherButtonTitles:titles otherButtonTitleColors:colors cancelButtonTitle:cancelButtonTitle cancelButtonTitleColor:cancelButtonTitleColor];
    actionSheet.dk_showAnimationType = DKAlertShowAnimationTypeFromBottom;
    actionSheet.dk_dismissAnimationType = DKAlertDismissAnimationTypeToBottom;
    actionSheet.actionBlock = block;
    
    [actionSheet dk_showAlert];
}

+ (void)dk_showActionSheetWithTitle:(NSString * __nullable)title otherButtonTitles:(NSArray * __nullable)titles otherButtonTitleColors:(NSArray * __nullable)colors action:(DKAlert_ButtonActionBlock __nullable)block
{
    [self dk_showActionSheetWithTitle:title otherButtonTitles:titles otherButtonTitleColors:colors cancelButtonTitle:@"取消" cancelButtonTitleColor:[UIColor redColor] action:block];
}

#pragma mark getter/setter
- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.backgroundColor = [UIColor whiteColor];
        _labelTitle.textColor = [UIColor lightGrayColor];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:_labelTitle];
    }
    return _labelTitle;
}
@end

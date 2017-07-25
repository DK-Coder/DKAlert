//
//  DKNotificationAlert.m
//  DKAlert
//
//  Created by NSLog on 2017/7/24.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import "DKNotificationAlert.h"

@interface DKNotificationAlert ()
{
    NSTimer *countDownTimer;
}
@property (nullable, nonatomic, strong) UIImageView *imageIcon;
@property (nullable, nonatomic, strong) UILabel *labelTitle;
@property (nullable, nonatomic, strong) UILabel *labelMessage;
@end

static DKNotificationAlert *instance;

@implementation DKNotificationAlert

+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        if (instance) {
            [instance sharedInit];
        }
    });
    return instance;
}

- (void)sharedInit
{
    [super sharedInit];
    
    self.needCoverView = NO;
    self.dk_showAnimationType = DKAlertShowAnimationTypeFromTop;
    self.dk_dismissAnimationType = DKAlertDismissAnimationTypeToTop;
    self.alertLastSeconds = 3;
    self.alertTitleContentColor = [UIColor blackColor];
    self.alertMessageColor = [UIColor blackColor];
    self.alertIconType = DKAlertIconTypeNone;
    self.dk_coverView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)dk_layoutAlert
{
    [super dk_layoutAlert];
    
    self.userWindow.windowLevel = UIWindowLevelAlert;
    
    CGFloat widthForActionSheet = SCREEN_WIDTH;
    self.frame = CGRectMake(0.f, 0.f, widthForActionSheet, 64.f);
    
    [self layoutImageIcon];
    [self layoutTitleLabel];
    [self layoutMessageLabel];
}

- (void)dk_showAlert
{
    [super dk_showAlert];
    
    [self destroyTimer];
    [self addTimerToRunLoop];
}

- (void)dk_dismissAlert
{
    [self destroyTimer];
    [super dk_dismissAlert];
}

- (CGPathRef)generatePathByDirection:(NSUInteger)direction
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (direction) {
        case DKAlertShowAnimationTypeFromTop:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, -CGRectGetHeight(self.frame) / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, CGRectGetHeight(self.frame) / 2)];
            break;
        case DKAlertDismissAnimationTypeToTop:
            [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, CGRectGetHeight(self.frame) / 2)];
            [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, -CGRectGetHeight(self.frame) / 2)];
            break;
    }
    return path.CGPath;
}

#pragma mark 外部方法实现
+ (void)dk_showNotificationWithIconType:(DKAlertIconType)type imageName:(NSString *)imageName title:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
    DKNotificationAlert *alert = [DKNotificationAlert sharedInstance];
    alert.alertImageName = imageName;
    alert.alertIconType = type;
    alert.alertTitleContent = title;
    alert.alertMessage = message;
    alert.dk_delegate = delegate;
    
    [alert dk_showAlert];
}

+ (void)dk_showInfomationNotificationWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
    [self dk_showNotificationWithIconType:DKAlertIconTypeInfomationCircle imageName:nil title:title message:message delegate:delegate];
}

#pragma mark 内部方式实现
- (void)layoutImageIcon
{
    if (_alertImageName) {
        UIImage *image = [UIImage imageNamed:_alertImageName];
        self.imageIcon.image = image;
        
        CGSize sizeForImage = image.size;
        CGFloat widthForImage = 25.f;
        CGFloat heightForImage = widthForImage * sizeForImage.height / sizeForImage.width;
        self.imageIcon.frame = CGRectMake(padding, (CGRectGetHeight(self.frame) - heightForImage) / 2, widthForImage, heightForImage);
    }
}

- (void)layoutTitleLabel
{
    if (_alertTitleContent) {
        self.labelTitle.text = _alertTitleContent;
        
        CGFloat widthForLabel = CGRectGetWidth(self.frame) - CGRectGetMaxX(_imageIcon.frame) - padding * 2;
        CGSize sizeForTitle = [_alertTitleContent boundingRectWithSize:CGSizeMake(widthForLabel, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelTitle.font} context:nil].size;
        if (sizeForTitle.height > 20.f) {
            sizeForTitle.height = 20.f;
        }
        if (_alertMessage) {
            self.labelTitle.frame = CGRectMake(CGRectGetMaxX(_imageIcon.frame) + padding, padding / 2, CGRectGetWidth(self.frame) - CGRectGetMaxX(_imageIcon.frame) - padding * 2, sizeForTitle.height);
        } else {
            self.labelTitle.frame = CGRectMake(CGRectGetMaxX(_imageIcon.frame) + padding, (CGRectGetHeight(self.frame) - 20.f) / 2, CGRectGetWidth(self.frame) - CGRectGetMaxX(_imageIcon.frame) - padding * 2, sizeForTitle.height);
        }
    } else {
        [self.labelTitle removeFromSuperview];
        self.labelTitle = nil;
    }
}

- (void)layoutMessageLabel
{
    if (_alertMessage) {
        self.labelMessage.text = _alertMessage;
        
        CGFloat widthForLabel = CGRectGetWidth(self.frame) - CGRectGetMaxX(_imageIcon.frame) - padding * 2;
        CGSize sizeForMessage = [_alertMessage boundingRectWithSize:CGSizeMake(widthForLabel, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.labelMessage.font} context:nil].size;
        if (sizeForMessage.height > 20.f) {
            self.labelMessage.numberOfLines = 2;
        }
        if (_alertTitleContent) {
            self.labelMessage.frame = CGRectMake(CGRectGetMaxX(_imageIcon.frame) + padding, CGRectGetMaxY(self.labelTitle.frame), widthForLabel, 40.f);
        } else {
            self.labelMessage.frame = CGRectMake(CGRectGetMaxX(_imageIcon.frame) + padding, (CGRectGetHeight(self.frame) - 40.f) / 2, widthForLabel, 40.f);
        }
    } else {
        [self.labelMessage removeFromSuperview];
        self.labelMessage = nil;
    }
}

- (void)tapOnView:(UITapGestureRecognizer *)tap
{
    if (self.dk_delegate && [self.dk_delegate respondsToSelector:@selector(didClickOnNotificationAlert:)]) {
        [self.dk_delegate didClickOnNotificationAlert:self];
    }
    [self dk_dismissAlert];
}

- (void)addTimerToRunLoop
{
    countDownTimer = [NSTimer timerWithTimeInterval:_alertLastSeconds target:self selector:@selector(dk_dismissAlert) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)destroyTimer
{
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
}

#pragma mark getter/setter
- (UIImageView *)imageIcon
{
    if (!_imageIcon) {
        _imageIcon = [[UIImageView alloc] init];
        [self addSubview:_imageIcon];
    }
    return _imageIcon;
}

- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.font = [UIFont boldSystemFontOfSize:16.f];
        [self addSubview:_labelTitle];
    }
    return _labelTitle;
}

- (UILabel *)labelMessage
{
    if (!_labelMessage) {
        _labelMessage = [[UILabel alloc] init];
        _labelMessage.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_labelMessage];
    }
    return _labelMessage;
}

- (void)setAlertTitleContentColor:(UIColor *)alertTitleContentColor
{
    _alertTitleContentColor = alertTitleContentColor;
    
    _labelTitle.textColor = alertTitleContentColor;
}

- (void)setAlertMessageColor:(UIColor *)alertMessageColor
{
    _alertMessageColor = alertMessageColor;
    
    _labelMessage.textColor = alertMessageColor;
}

- (void)setAlertIconType:(DKAlertIconType)alertIconType
{
    _alertIconType = alertIconType;
    
    NSString *imageName = [self getIconFileNameByIconType:alertIconType];
    if (imageName) {
        _alertImageName = imageName;
    }
}
@end

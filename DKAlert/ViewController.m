//
//  ViewController.m
//  DKAlert
//
//  Created by NSLog on 2017/7/18.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import "ViewController.h"
#import "DKAlert.h"
#import "DKActionSheet.h"
#import "DKNotificationAlert.h"

static NSString *kDefaultCellIdentifier = @"kDefaultCellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *arrayAllKeys;
    NSDictionary *dictDatasources;
    
    NSArray *colors;
    
    UITableView *tableOptions;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    colors = @[[UIColor greenColor],
               [UIColor redColor],
               [UIColor blackColor]];
    
    arrayAllKeys = @[@"DKAlert功能展示", @"DKActionSheet功能展示", @"DKNotification功能展示"];
    dictDatasources = @{@(0): @[@"普通Alert，使用淡入淡出动画方式，1个按钮",
                                @"普通Alert，从上方滑入上方滑出，2个按钮",
                                @"普通Alert，从下方滑入下方滑出，3个按钮",
                                @"普通Alert，从左侧滑入左侧滑出，3个按钮",
                                @"普通Alert，从右侧滑入右侧滑出，3个按钮",
                                @"带图标Alert，淡入淡出，1个按钮",
                                @"带图标Alert，淡入淡出，2个按钮",
                                @"带图标Alert，淡入淡出，3个按钮"],
                        @(1): @[@"普通ActionSheet",
                                @"没有title的ActionSheet"],
                        @(2): @[@"普通NotificationAlert",
                                @"没有title的NotificationAlert",
                                @"没有message的NotificationAlert"]};
    
    tableOptions = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableOptions.delegate = self;
    tableOptions.dataSource = self;
    tableOptions.rowHeight = 50.f;
    [tableOptions registerClass:[UITableViewCell class] forCellReuseIdentifier:kDefaultCellIdentifier];
    [self.view addSubview:tableOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleDeviceOrientationRotateAction:(NSNotification *)notification
{
    tableOptions.frame = self.view.frame;
    [tableOptions reloadData];
}

#pragma mark tableview 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayAllKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, CGRectGetWidth(self.view.frame) - 20.f, 30.f)];
    labelTitle.text = arrayAllKeys[section];
    labelTitle.textColor = [UIColor redColor];
    labelTitle.font = [UIFont boldSystemFontOfSize:16.f];
    [headerView addSubview:labelTitle];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayValue = [dictDatasources objectForKey:@(section)];
    
    return arrayValue.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCellIdentifier];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    cell.textLabel.text = [[dictDatasources objectForKey:@(section)] objectAtIndex:row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    
    return cell;
}

#pragma mark tableview 代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            [DKAlert dk_showAlertWithTitle:@"提示信息" message:@"前方高能" buttonTitles:@[@"确定"] buttonTitleColors:nil action:^(NSInteger index) {
                
            }];
        } else if (row == 1) {
            [DKAlert dk_showAlertWithTitle:@"提示信息" message:@"前方高能" buttonTitles:@[@"确定", @"取消"] buttonTitleColors:nil showAnimationType:DKAlertShowAnimationTypeFromTop dismissAnimationType:DKAlertDismissAnimationTypeToTop action:^(NSInteger index) {
                
            }];
        } else if (row == 2) {
            [DKAlert dk_showAlertWithTitle:@"提示信息" message:@"前方高能" buttonTitles:@[@"确定", @"取消", @"以后再说"] buttonTitleColors:colors showAnimationType:DKAlertShowAnimationTypeFromBottom dismissAnimationType:DKAlertDismissAnimationTypeToBottom action:^(NSInteger index) {
                
            }];
        } else if (row == 3) {
            [DKAlert dk_showAlertWithTitle:@"提示信息" message:@"前方高能" buttonTitles:@[@"确定", @"取消", @"以后再说"] buttonTitleColors:colors showAnimationType:DKAlertShowAnimationTypeFromLeft dismissAnimationType:DKAlertDismissAnimationTypeToLeft action:^(NSInteger index) {
                
            }];
        } else if (row == 4) {
            [DKAlert dk_showAlertWithTitle:@"提示信息" message:@"前方高能" buttonTitles:@[@"确定", @"取消", @"以后再说"] buttonTitleColors:colors showAnimationType:DKAlertShowAnimationTypeFromRight dismissAnimationType:DKAlertDismissAnimationTypeToRight action:^(NSInteger index) {
                
            }];
        } else if (row == 5) {
            [DKAlert dk_showImageAlertWithIconType:DKAlertIconTypeSuccess message:@"操作成功" buttonTitles:@[@"确定"] buttonTitleColors:colors showAnimationType:DKAlertShowAnimationTypeFadeIn dismissAnimationType:DKAlertDismissAnimationTypeFadeOut action:^(NSInteger index) {
                
            }];
        } else if (row == 6) {
            [DKAlert dk_showImageAlertWithIconType:DKAlertIconTypeFailure message:@"操作失败" buttonTitles:@[@"确定", @"其他方式"] buttonTitleColors:colors showAnimationType:DKAlertShowAnimationTypeFadeIn dismissAnimationType:DKAlertDismissAnimationTypeFadeOut action:^(NSInteger index) {
                
            }];
        } else if (row == 7) {
            [DKAlert dk_showImageAlertWithIconType:DKAlertIconTypeInfomation message:@"请稍后重试" buttonTitles:@[@"确定", @"其他方式", @"重试"] buttonTitleColors:colors showAnimationType:DKAlertShowAnimationTypeFadeIn dismissAnimationType:DKAlertDismissAnimationTypeFadeOut action:^(NSInteger index) {
                
            }];
        }
    } else if (section == 1) {
        if (row == 0) {
            [DKActionSheet dk_showActionSheetWithTitle:@"选择类型" otherButtonTitles:@[@"类型1", @"类型2", @"类型3"] otherButtonTitleColors:colors action:^(NSInteger index) {
                
            }];
        } else if (row == 1) {
            [DKActionSheet dk_showActionSheetWithTitle:nil otherButtonTitles:@[@"类型1", @"类型2", @"类型3", @"类型4", @"类型5", @"类型6"] otherButtonTitleColors:colors action:^(NSInteger index) {
                
            }];
        }
    } else if (section == 2) {
        if (row == 0) {
            [DKNotificationAlert dk_showInfomationNotificationWithTitle:@"DK-Coder" message:@"今天出去耍不？" delegate:nil];
//            DKNotificationAlert *alert = [[DKNotificationAlert alloc] init];
//            alert.alertIconType = DKAlertIconTypeInfomationCircle;
//            alert.alertTitleContent = @"DK-Coder";
//            alert.alertMessage = @"今天你出去耍不？";
//            
//            [alert dk_showAlert];
        } else if (row == 1) {
            [DKNotificationAlert dk_showNotificationWithIconType:DKAlertIconTypeSuccessCircle imageName:nil title:nil message:@"只能贴最新的20条信息" delegate:nil];
        } else if (row == 2) {
            [DKNotificationAlert dk_showNotificationWithIconType:DKAlertIconTypeFailureCircle imageName:nil title:@"哈哈哈哈哈哈哈哈哈哈" message:nil delegate:nil];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

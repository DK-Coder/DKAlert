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

static NSString *kDefaultCellIdentifier = @"kDefaultCellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSDictionary *dictDatasources;
    
    NSArray *colors;
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
    
    dictDatasources = @{@"DKAlert功能展示": @[@"普通Alert，使用淡入淡出动画方式，1个按钮",
                                          @"普通Alert，从上方滑入上方滑出，2个按钮",
                                          @"普通Alert，从下方滑入下方滑出，3个按钮",
                                          @"普通Alert，从左侧滑入左侧滑出，3个按钮",
                                          @"普通Alert，从右侧滑入右侧滑出，3个按钮",
                                          @"带图标Alert，淡入淡出，1个按钮",
                                          @"带图标Alert，淡入淡出，2个按钮",
                                          @"带图标Alert，淡入淡出，3个按钮"],
                        @"DKActionSheet功能展示" : @[@"普通ActionSheet"]};
    
    UITableView *tableOptions = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableOptions.delegate = self;
    tableOptions.dataSource = self;
    tableOptions.rowHeight = 50.f;
    [tableOptions registerClass:[UITableViewCell class] forCellReuseIdentifier:kDefaultCellIdentifier];
    [self.view addSubview:tableOptions];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dictDatasources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *allKeys = dictDatasources.allKeys;
    UIView *headerView = [[UIView alloc] init];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, CGRectGetWidth(self.view.frame) - 20.f, 30.f)];
    labelTitle.text = allKeys[section];
    labelTitle.textColor = [UIColor redColor];
    labelTitle.font = [UIFont boldSystemFontOfSize:16.f];
    [headerView addSubview:labelTitle];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *allKeys = dictDatasources.allKeys;
    NSArray *arrayValue = [dictDatasources objectForKey:allKeys[section]];
    
    return arrayValue.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCellIdentifier];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray *allKeys = dictDatasources.allKeys;
    cell.textLabel.text = [[dictDatasources objectForKey:allKeys[section]] objectAtIndex:row];
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
            [DKAlert dk_showImageAlertWithIconType:DKImageAlertIconTypeSuccess message:@"操作成功" buttonTitles:@[@"确定"] buttonTitleColors:colors showAnimationType:DKAlertShowAnimationTypeFadeIn dismissAnimationType:DKAlertDismissAnimationTypeFadeOut action:^(NSInteger index) {
                
            }];
        } else if (row == 6) {
            [DKAlert dk_showImageAlertWithIconType:DKImageAlertIconTypeFailure message:@"操作失败" buttonTitles:@[@"确定", @"其他方式"] buttonTitleColors:colors showAnimationType:DKAlertShowAnimationTypeFadeIn dismissAnimationType:DKAlertDismissAnimationTypeFadeOut action:^(NSInteger index) {
                
            }];
        } else if (row == 7) {
            [DKAlert dk_showImageAlertWithIconType:DKImageAlertIconTypeInfomation message:@"请稍后重试" buttonTitles:@[@"确定", @"其他方式", @"重试"] buttonTitleColors:colors showAnimationType:DKAlertShowAnimationTypeFadeIn dismissAnimationType:DKAlertDismissAnimationTypeFadeOut action:^(NSInteger index) {
                
            }];
        }
    } else if (section == 1) {
        if (row == 0) {
            [DKActionSheet showActionSheetWithTitle:@"选择类型" buttonTitles:@[@"类型1", @"类型2", @"类型3"] buttonTitleColors:colors action:^(NSInteger index) {
                
            }];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

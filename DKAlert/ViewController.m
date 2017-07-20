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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *button = [[UIButton alloc] init];
    [button setFrame:CGRectMake(0.f, 200.f, 320.f, 60.f)];
    [button setTitle:@"按我弹alert" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [[UIButton alloc] init];
    [button2 setFrame:CGRectMake(0.f, 400.f, 320.f, 60.f)];
    [button2 setTitle:@"按我弹actionsheet" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonPressed
{
    [DKAlert dk_showAlertWithTitle:@"提示信息" message:@"前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能前方高能" buttonTitles:@[@"确定", @"取消"] buttonTitleColors:nil showAnimationType:DKAlertShowAnimationTypeFromTop dismissAnimationType:DKAlertDismissAnimationTypeToBottom action:^(NSInteger index) {
            
    }];
}

- (void)button2Pressed
{
    [DKActionSheet showActionSheetWithTitle:nil buttonTitles:@[@"类型1", @"类型2", @"类型3"] buttonTitleColors:nil action:^(NSInteger index) {
        
    }];
}
@end

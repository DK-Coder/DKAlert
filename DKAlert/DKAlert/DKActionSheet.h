//
//  DKActionSheet.h
//  DKAlert
//
//  Created by NSLog on 2017/7/20.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import "DKBaseView.h"

@interface DKActionSheet : DKBaseView

/**
 *  生成一个actionsheet
 * @param title 标题，可以nil
 * @param titles 除了cancelbutton以外的按钮title
 * @param colors 除了cancelbutton以外的按钮title颜色
 * @param cancelButtonTitle 取消按钮的title
 * @param cancelButtonTitleColor 取消按钮的title颜色
 * @param block 按下按钮的回调
 */
+ (void)dk_showActionSheetWithTitle:(NSString * __nullable)title otherButtonTitles:(NSArray * __nullable)titles otherButtonTitleColors:(NSArray * __nullable)colors cancelButtonTitle:(NSString * __nullable)cancelButtonTitle cancelButtonTitleColor:(UIColor * __nullable)cancelButtonTitleColor action:(DKAlert_ButtonActionBlock __nullable)block;

/**
 *  生成一个cancelbutton的title默认为“取消”并且文字颜色为红色的actionsheet
 * @param title 标题，可以nil
 * @param titles 除了cancelbutton以外的按钮title
 * @param colors 除了cancelbutton以外的按钮title颜色
 * @param block 按下按钮的回调
 */
+ (void)dk_showActionSheetWithTitle:(NSString * __nullable)title otherButtonTitles:(NSArray * __nullable)titles otherButtonTitleColors:(NSArray * __nullable)colors action:(DKAlert_ButtonActionBlock __nullable)block;
@end

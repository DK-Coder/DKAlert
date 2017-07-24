//
//  DKActionSheet.h
//  DKAlert
//
//  Created by NSLog on 2017/7/20.
//  Copyright © 2017年 DK-Coder. All rights reserved.
//

#import "DKBaseView.h"

@interface DKActionSheet : DKBaseView

+ (void)dk_showActionSheetWithTitle:(NSString * __nullable)title buttonTitles:(NSArray * __nullable)titles buttonTitleColors:(NSArray * __nullable)colors action:(DKAlert_ButtonActionBlock __nullable)block;
@end

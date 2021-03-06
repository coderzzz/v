//
//  BaseViewController.h
//  iwen
//
//  Created by Interest on 15/10/10.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic,strong) UIBarButtonItem *commonbackItem;
- (void)showHudWithString:(NSString *)string;
- (void)showTipWithView:(UIView *)view action:(NSString *)action;
- (void)showHud;
- (void)showTipWithString:(NSString *)str;
- (void)hideHud;

- (UIColor *) colorWithHexString: (NSString *)color;
- (NSString *)convertStringToHexStr:(NSString *)str;
@end

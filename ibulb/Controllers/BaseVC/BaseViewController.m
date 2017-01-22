//
//  BaseViewController.m
//  iwen
//
//  Created by Interest on 15/10/10.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
@interface BaseViewController ()

@end


@implementation BaseViewController

{
    MBProgressHUD *mbpHud;
}

- (id)init{
    self = [super init];
    if (self) {
        
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        self.navigationItem.leftBarButtonItem = self.commonbackItem;
        
        
    }
    return self;
}
- (UIBarButtonItem *)commonbackItem{
    
    if (_commonbackItem  == nil) {
        
        UIButton *blogItem         = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        blogItem.imageEdgeInsets = UIEdgeInsetsMake(0,-25, 0, 0);
        [blogItem setImage:[UIImage imageNamed:@"05"] forState:UIControlStateNormal];
        [blogItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _commonbackItem = [[UIBarButtonItem alloc]initWithCustomView:blogItem];
        
        
    }
    
    return _commonbackItem;
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor colorWithRed:254.0/255.0 green:251.0/255.0 blue:246.0/255.0 alpha:1];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
  
    
    
//    self.navigationItem.leftBarButtonItem = self.commonbackItem;
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
- (void)showHud{
    
    
    AppDelegate *dele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    mbpHud =[[MBProgressHUD alloc]initWithView:dele.window];
    
    [dele.window addSubview:mbpHud];
    
     [mbpHud show:YES];
    
    
}

- (void)hideHud{
    
    
    [mbpHud hide:YES];
     mbpHud = nil;
}

- (void)showHudWithString:(NSString *)string{
    
    
    AppDelegate *dele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:dele.window];
    
    [dele.window addSubview:hud];
    
    hud.mode = MBProgressHUDModeText;
    
    hud.labelText = string;
    
    [hud show:YES];
    
    [hud hide:YES afterDelay:1.2];
    
    
}

- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
//将NSString转换成十六进制的字符串则可使用如下方式:
- (NSString *)convertStringToHexStr:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}
@end

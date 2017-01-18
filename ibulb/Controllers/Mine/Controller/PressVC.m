//
//  PressVC.m
//  ibulb
//
//  Created by Interest on 2016/10/28.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "PressVC.h"
#import "WaitVC.h"
@interface PressVC ()

@end

@implementation PressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)aciton:(id)sender {
    
    WaitVC *vc = [[WaitVC alloc]init];
    vc.title = @"PLEASE WAIT";
    vc.password = self.password;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

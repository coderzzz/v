//
//  NewFirVC.m
//  ibulb
//
//  Created by Interest on 2016/11/3.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "NewFirVC.h"
#import "UpdateVC.h"
@interface NewFirVC ()

@end

@implementation NewFirVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btnAction:(id)sender {
    
    UpdateVC *vc = [[UpdateVC alloc]init];
    vc.title = @"UPDATING";
    [self.navigationController pushViewController:vc animated:YES];
}


@end

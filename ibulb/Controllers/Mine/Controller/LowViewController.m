//
//  LowViewController.m
//  ibulb
//
//  Created by Interest on 2016/11/30.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "LowViewController.h"
#import "ColorVC.h"
@interface LowViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@end

@implementation LowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SUCCESS";
}

- (IBAction)next:(id)sender {
    
    ColorVC *vc = [[ColorVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end

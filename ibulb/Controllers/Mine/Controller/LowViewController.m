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

@property (weak, nonatomic) IBOutlet UILabel *tilab;

@property (weak, nonatomic) IBOutlet UILabel *conlab;

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UIButton *nextbtn;

@end

@implementation LowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tilab.text = NSLocalizedString(@"WI-FI STRENGTH ", nil);
    self.conlab.text = NSLocalizedString(@"Wi-Fi Strength of your speaker is low, it can affect your streaming experience.", nil);
    self.lab1.text = NSLocalizedString(@"1 Please move your speaker closer to Router ", nil);
    self.lab2.text = NSLocalizedString(@"2 Change to another Wi-Fi AP", nil);
    [self.nextbtn setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
    self.title = NSLocalizedString(@"SUCCESS", nil);
}

- (IBAction)next:(id)sender {
    
    ColorVC *vc = [[ColorVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end

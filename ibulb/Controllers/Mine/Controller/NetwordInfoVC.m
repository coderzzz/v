//
//  NetwordInfoVC.m
//  ibulb
//
//  Created by Interest on 2016/10/25.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "NetwordInfoVC.h"
#import "ChosespeakerVC.h"
@interface NetwordInfoVC ()
@property (weak, nonatomic) IBOutlet UITextField *nametf;
@property (weak, nonatomic) IBOutlet UITextField *passwordtf;
@property (weak, nonatomic) IBOutlet UIButton *checkboxBtn;

@end

@implementation NetwordInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nametf.text = self.wifiName;
}
- (IBAction)action:(id)sender {
    
    ChosespeakerVC *vc = [[ChosespeakerVC alloc]init];
    vc.wifiName = self.wifiName;
    vc.password = self.passwordtf.text;
    vc.title = @"CHOOSE YOUR SPEAKER TYPE";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)checkAction:(UIButton *)sender {
    
    self.passwordtf.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}


@end

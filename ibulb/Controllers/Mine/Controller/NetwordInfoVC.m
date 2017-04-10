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
@property (weak, nonatomic) IBOutlet UILabel *namelab;
@property (weak, nonatomic) IBOutlet UILabel *passlab;
@property (weak, nonatomic) IBOutlet UILabel *sholab;
@property (weak, nonatomic) IBOutlet UIButton *nextbtn;

@end

@implementation NetwordInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nametf.text = self.wifiName;
    self.namelab.text = NSLocalizedString(@"Name", nil);
    [self.nextbtn setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
    self.passlab.text = NSLocalizedString(@"Password", nil);
    self.passwordtf.placeholder = NSLocalizedString(@"please", nil);
    self.sholab.text = NSLocalizedString(@"Show Password", nil);
    self.checkboxBtn.selected = YES;
}
- (IBAction)action:(id)sender {
    
    ChosespeakerVC *vc = [[ChosespeakerVC alloc]init];
    vc.wifiName = self.wifiName;
    vc.password = self.passwordtf.text;
    vc.title = NSLocalizedString(@"CHOOSE YOUR SPEAKER TYPE", nil);
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)checkAction:(UIButton *)sender {
    
    self.passwordtf.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}


@end

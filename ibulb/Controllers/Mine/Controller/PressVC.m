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
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation PressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lab.text = NSLocalizedString(@"Make sure your product is plugged into a power outlet. Long Press the connect button (>3s) until you see the status LED blink yellow. ", nil);
    [self.btn setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];

}

- (IBAction)aciton:(id)sender {
    
    WaitVC *vc = [[WaitVC alloc]init];
    vc.title = NSLocalizedString(@"PLEASE WAIT", nil);
    vc.password = self.password;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

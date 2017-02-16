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
@property (weak, nonatomic) IBOutlet UILabel *clab;
@property (weak, nonatomic) IBOutlet UIButton *fbtn;

@end

@implementation NewFirVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fbtn setTitle:NSLocalizedString(@"FIRMWARE UPDATE", nil) forState:UIControlStateNormal];
    self.clab.text = NSLocalizedString(@"The new firmware avaliable", nil);
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btnAction:(id)sender {
    
    UpdateVC *vc = [[UpdateVC alloc]init];
    vc.title = NSLocalizedString(@"UPDATING", nil);
    [self.navigationController pushViewController:vc animated:YES];
}


@end

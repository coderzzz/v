//
//  NotfoundVC.m
//  ibulb
//
//  Created by Interest on 2016/10/28.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "NotfoundVC.h"
#import "Netconfig.h"
@interface NotfoundVC ()

@end

@implementation NotfoundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)action:(id)sender {
    
    Netconfig *vc = [[Netconfig alloc]init];
    vc.title = @"NETWORK CONFIGURATION";
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end

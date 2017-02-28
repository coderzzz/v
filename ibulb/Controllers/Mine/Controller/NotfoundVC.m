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
    NSMutableArray *images = [NSMutableArray array];
    for (int a = 0; a<36; a++) {
        
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d白色",a]];
        [images addObject:img];
        
    }
    
    self.imgv.animationImages = images;
    self.imgv.animationDuration = 2;
    self.imgv.animationRepeatCount = 99999999;
    [self.imgv startAnimating];
    self.searchlab.text = NSLocalizedString(@"Searching", nil);
    self.nearlab.text = NSLocalizedString(@"FOR SPEAKERS NEARBY", nil);
    self.notfoundlab.text = NSLocalizedString(@"NOT FOUND ANY DEVICE\nADD A NEW VIP-A HOME\nSPEAKER ?", nil);
    [self.setupbtn setTitle:NSLocalizedString(@"SETUP WIZARD", nil) forState:UIControlStateNormal];
    
}
- (IBAction)action:(id)sender {
    
    Netconfig *vc = [[Netconfig alloc]init];
    vc.title = NSLocalizedString(@"NETWORK CONFIGURATION", nil);
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end

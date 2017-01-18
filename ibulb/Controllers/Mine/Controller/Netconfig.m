//
//  Netconfig.m
//  ibulb
//
//  Created by Interest on 2016/10/28.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "Netconfig.h"
#import "NetwordInfoVC.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@interface Netconfig ()
@property (weak, nonatomic) IBOutlet UILabel *wifiLab;

@end

@implementation Netconfig

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id info = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSString *str = info[@"SSID"];
        self.wifiLab.text = str;
  
        
    }
    
}
- (IBAction)action:(id)sender {
    
    NetwordInfoVC *vc = [[NetwordInfoVC alloc]init];
    vc.title = @"NETWORK CONFIGURATION";
    vc.wifiName = self.wifiLab.text;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

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
    
    
    self.toplab.text = NSLocalizedString(@"Your speaker will be configured to the same network as your mobil device.", nil);
    [self.btn setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
    self.butlab.text = NSLocalizedString(@"It is important that the speaker has a reliable connection to your router. You can placing the speaker and your phone near the router during the setup process. Check if your router is configuredfor 2.4 GHz, if in doubt, go to your mobil phone's Wi-Fi settings.", nil);
}
- (IBAction)action:(id)sender {
    
    NetwordInfoVC *vc = [[NetwordInfoVC alloc]init];
    vc.title = NSLocalizedString(@"NETWORK CONFIGURATION", nil);
    vc.wifiName = self.wifiLab.text;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

//
//  WifiVC.m
//  ibulb
//
//  Created by Interest on 2016/11/7.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "WifiVC.h"

@interface WifiVC ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation WifiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lab.text = NSLocalizedString(@"Make sure your iPhone is connected to Wi-Fi network. Click the image above to go to your Wifi Settings", nil);
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", nil)
                                                  message:NSLocalizedString(@"Your mobile phone is not\nconnected to the Wifi Network.\nYou can go to Settings to connect.", nil)
                                                 delegate:nil
                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                        otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [view show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

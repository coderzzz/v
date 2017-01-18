//
//  WifiVC.m
//  ibulb
//
//  Created by Interest on 2016/11/7.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "WifiVC.h"

@interface WifiVC ()

@end

@implementation WifiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"Error"
                                                  message:@"Your mobile phone is not\nconnected to the Wifi Network.\nYou can go to Settings to connect."
                                                 delegate:nil
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"OK", nil];
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

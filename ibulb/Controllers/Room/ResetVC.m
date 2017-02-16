//
//  ResetVC.m
//  ibulb
//
//  Created by Interest on 2016/11/2.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "ResetVC.h"
#import "AFHttp.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "ZZBluetoothManger.h"
#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"
#import "HomeVC.h"
#import "BaseNavigationController.h"
#import "WiimuUPnP.h"
#import "GlobalInfo.h"
@interface ResetVC ()
@property (weak, nonatomic) IBOutlet UILabel *clab;
@property (weak, nonatomic) IBOutlet UIButton *nbtn;
@property (weak, nonatomic) IBOutlet UIButton *yben;

@end

@implementation ResetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clab.text = NSLocalizedString(@"Are you sure you want to set the xxxx speaker to factory default (all user defined settings and network settings will be lost)? ", nil);
    [self.nbtn setTitle:NSLocalizedString(@"NOT NOW", nil) forState:UIControlStateNormal];
    [self.yben setTitle:NSLocalizedString(@"YES RESET", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)action:(UIButton *)sender {
    if (sender.tag == 1) {
        
        
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infoDic = [delegate.devices firstObject];

        [[AFHttp shareInstanced]reStroeWithIP:infoDic[@"ip"] completionBlock:^(id obj) {
            
            
            HomeVC *vc =[[HomeVC alloc]initWithNibName:nil bundle:nil];
            BaseNavigationController *rootvc= [[BaseNavigationController alloc]initWithRootViewController:vc];
            
            delegate.window.rootViewController = rootvc;
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            
        }];
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end

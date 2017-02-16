//
//  Firmware.m
//  ibulb
//
//  Created by Interest on 2016/11/2.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "Firmware.h"
#import "NewFirVC.h"
#import "AFHttp.h"
#import "AppDelegate.h"
@interface Firmware ()
@property (weak, nonatomic) IBOutlet UILabel *contenlab;

@end

@implementation Firmware
{
    
    NSString *firm;
    BOOL      need;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contenlab.text = firm;
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [[AFHttp shareInstanced]updateStartCheckWithIP:infoDic[@"ip"] completionBlock:^(id obj) {
        
        NSLog(@"%@",obj);
        
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

- (id)initWithFirmware:(NSString *)firmware needUpdate:(BOOL)needUpdate{
    
    self = [super init];
    if (self) {
        
        firm = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Your speaker has the firmware version", nil),firmware];
        need = needUpdate;
        
    }
    return self;
}

- (IBAction)action:(id)sender {
    
    if (need) {
     
        NewFirVC *vc = [[NewFirVC alloc]init];
        vc.title = NSLocalizedString(@"NEW FIRMWARE", nil);
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}



@end

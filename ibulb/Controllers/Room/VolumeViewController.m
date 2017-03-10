//
//  VolumeViewController.m
//  ibulb
//
//  Created by Interest on 2016/11/30.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "VolumeViewController.h"
#import "WiimuUPnP.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "AppDelegate.h"
@interface VolumeViewController ()<WiimuUPnPObserver>
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation VolumeViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self updateUI];
    
//    [[WiimuUPnP sharedInstance] addObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    
//    [[WiimuUPnP sharedInstance] removeObserver:self];
}
- (void)updateUI{
    
//    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSDictionary *infoDic = [delegate.devices firstObject];
//    
//    [UPnPDevice(infoDic[@"uuid"]) GetInfoEx:^(NSDictionary *result) {
//        if([result[@"statuscode"] intValue] != 0)
//        {
//            return;
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            //            self.navigationItem.title
//            //volume
//            _slider.value = [result[@"OutCurrentVolume"] floatValue];
//            
//            _lab.text = [NSString stringWithFormat:@"%.f%%",[result[@"OutCurrentVolume"] floatValue]];
//            
//            
//        });
//        
//    }];
}
#pragma mark - WiimuUPnPObserver methods

//- (void)UPnPDeviceEvent:(id<WiimuDeviceProtocol>)device event:(NSString *)event
//{
//    NSLog(@"%@",event);
//    [self updateUI];
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lab.text = [NSString stringWithFormat:@"%.f%%",self.value];
    self.slider.value = self.value;
    
    
}
- (IBAction)changeVolume:(UISlider *)sender {
    
    self.lab.text = [NSString stringWithFormat:@"%.f%%",sender.value];
    
}

- (void)back{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateStartupVolume:type:)]) {
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infoDic = [delegate.devices firstObject];
        [self.delegate didUpdateStartupVolume:self.slider.value type:self.type];
        NSString *value = [NSString stringWithFormat:@"%f",self.slider.value];
        [[NSUserDefaults standardUserDefaults]setObject:value forKey:[NSString stringWithFormat:@"start%@",infoDic[@"uuid"]]];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

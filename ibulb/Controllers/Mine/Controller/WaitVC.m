//
//  WaitVC.m
//  ibulb
//
//  Created by Interest on 2016/10/28.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "WaitVC.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "LowViewController.h"
#import "AppDelegate.h"
/**********************************************/
#import "WiimuUPnP.h"
@interface WaitVC ()<WiimuUPnPObserver>
{
    NSMutableArray * dataArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@end

@implementation WaitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    [[WiimuUPnP sharedInstance] cleanAndRestart];
    [[WiimuUPnP sharedInstance] addObserver:self];
    [WiimuUPnP sharedInstance].needBackgroundMode = NO;
    [[WiimuUPnP sharedInstance] startSmartLink:self.password];
    NSMutableArray *images = [NSMutableArray array];
    for (int a = 0; a<36; a++) {
        
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d白色",a]];
        [images addObject:img];
        
    }
    
    self.imgv.animationImages = images;
    self.imgv.animationDuration = 2;
    self.imgv.animationRepeatCount = 99999999;
    [self.imgv startAnimating];
    
}
- (IBAction)aciton:(id)sender {
    
    [[WiimuUPnP sharedInstance] stopSmartLink];
    [[WiimuUPnP sharedInstance] removeObserver:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - WiimuUPnPObserver methods
- (void)UPnPDeviceAdd:(id<WiimuDeviceProtocol>)device
{
    NSLog(@"-- add %@",[device uuid]);
//    [UPnPDevice([device uuid]) GetControlDeviceInfo:^(NSDictionary *result) {
//        if([result[@"statuscode"] intValue] != 0)
//        {
//            //only for old version, use to get friendlyname
//            [self dealWithOldVersion:device];
//            
//            return;
//        }
//        
//        NSDictionary * statusDic = [NSJSONSerialization JSONObjectWithData:[result[@"status"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
//        
//        NSDictionary * infoDic = @{@"ip":[device ip],@"uuid":[device uuid],@"ssid":statusDic[@"ssid"]?:@"",@"name":statusDic[@"DeviceName"]?:@"",@"RSSI":statusDic[@"RSSI"]?:@"",@"hardware":statusDic[@"hardware"]?:@""};
//        //        [dataArray addObject:infoDic];
//        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate.devices addObject:infoDic];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            LowViewController *vc = [[LowViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        });
//    }];
}

- (void)UPnPDeviceRemove:(id<WiimuDeviceProtocol>)device
{
    NSLog(@"-- remove %@",[device uuid]);
    
    for(NSDictionary * dic in dataArray)
    {
        if([dic[@"ip"] isEqualToString:[device ip]])
        {
            [dataArray removeObject:dic];
            break;
        }
    }
    
}

- (void)UPnPDeviceReady:(id<WiimuDeviceProtocol>)device
{
    NSLog(@"-- ready %@",[device uuid]);

}

- (void)UPnPDeviceSmartLink:(id<WiimuDeviceProtocol>)device
{
    NSLog(@"-- smartlink come %@",[device uuid]);
    [UPnPDevice([device uuid]) GetControlDeviceInfo:^(NSDictionary *result) {
        if([result[@"statuscode"] intValue] != 0)
        {
            //only for old version, use to get friendlyname
            [self dealWithOldVersion:device];
            
            return;
        }
        
        NSDictionary * statusDic = [NSJSONSerialization JSONObjectWithData:[result[@"status"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        NSDictionary * infoDic = @{@"ip":[device ip],@"uuid":[device uuid],@"ssid":statusDic[@"ssid"]?:@"",@"name":statusDic[@"DeviceName"]?:@""};
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSInteger index = 999;
        for (NSDictionary *dic in delegate.devices) {
            
            if ([dic[@"uuid"] isEqualToString:[device uuid]]) {
                
                 index= [delegate.devices indexOfObject:dic];
            }
        }
        if (index == 999) {
        
            [delegate.devices addObject:infoDic];
        }
        else{
            
            
            [delegate.devices replaceObjectAtIndex:index withObject:infoDic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            LowViewController *vc = [[LowViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        });
    }];
    
}

- (void)UPnPDeviceEvent:(id<WiimuDeviceProtocol>)device event:(NSString *)event
{
    NSLog(@"-- %@'s event come",event);
}

/**********************************************/

#pragma mark - private methods
- (void)dealWithOldVersion:(id<WiimuDeviceProtocol>)device
{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/description.xml",[device ip],[device port]]]];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    if (!xmlDoc)
    {
        return;
    }
    
    DDXMLElement *deviceItem = [[xmlDoc rootElement] elementForName:@"device"];
    DDXMLElement *nameItem = [deviceItem elementForName:@"friendlyName"];
    
    [dataArray addObject:@{@"ip":[device ip],@"uuid":[device uuid],@"ssid":@"unknown",@"name":[nameItem stringValue]}];
    
    
}


@end

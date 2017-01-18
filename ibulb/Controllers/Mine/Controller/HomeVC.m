//
//  HomeVC.m
//  ibulb
//
//  Created by Interest on 16/10/24.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "HomeVC.h"
#import "WifiVC.h"
#import "NotfoundVC.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "LeftVC.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "DDMenuController.h"
#import "BaseNavigationController.h"
/**********************************************/
#import "WiimuUPnP.h"
@interface HomeVC ()<WiimuUPnPObserver>
{
    NSMutableArray * dataArray;
}
@end

@implementation HomeVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(10 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        NSString *ap = [[WiimuUPnP sharedInstance]getCurrentAp];
        if (!(ap.length>0)) {
            
            WifiVC *vc = [[WifiVC alloc]init];
            vc.title = @"SETTINGS- WI-Fi";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (dataArray.count>0){
            
            
            AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
            DDMenuController *ddmenu = [[DDMenuController alloc]init];
            TabBarViewController *tabVC =[[TabBarViewController alloc]init];
            LeftVC *leftVc = [[LeftVC alloc]init];
            leftVc.list = [dataArray mutableCopy];
            BaseNavigationController *leftNav = [[BaseNavigationController alloc]initWithRootViewController:leftVc];
            ddmenu.leftViewController = leftNav;
            ddmenu.rootViewController = tabVC;
            delegate.window.rootViewController = ddmenu;
            //        delegate.devices = [dataArray mutableCopy];
            delegate.ddmenu = ddmenu;
            [[WiimuUPnP sharedInstance] removeObserver:self];
            
//            NotfoundVC *vc = [[NotfoundVC alloc]init];
//            [[WiimuUPnP sharedInstance] removeObserver:self];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            
            NotfoundVC *vc = [[NotfoundVC alloc]init];
            [[WiimuUPnP sharedInstance] removeObserver:self];
            [self.navigationController pushViewController:vc animated:YES];

//            AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
//            DDMenuController *ddmenu = [[DDMenuController alloc]init];
//            TabBarViewController *tabVC =[[TabBarViewController alloc]init];
//            LeftVC *leftVc = [[LeftVC alloc]init];
//            leftVc.list = [dataArray mutableCopy];
//            BaseNavigationController *leftNav = [[BaseNavigationController alloc]initWithRootViewController:leftVc];
//            ddmenu.leftViewController = leftNav;
//            ddmenu.rootViewController = tabVC;
//            delegate.window.rootViewController = ddmenu;
//            //        delegate.devices = [dataArray mutableCopy];
//            delegate.ddmenu = ddmenu;
//            [[WiimuUPnP sharedInstance] removeObserver:self];
        }
    });

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[WiimuUPnP sharedInstance] start];
    dataArray = [NSMutableArray array];
    [[WiimuUPnP sharedInstance] addObserver:self];
    [WiimuUPnP sharedInstance].needBackgroundMode = NO;
    
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


- (IBAction)btnAction:(UIButton *)sender {
    
    if (sender.tag == 0) {
        
        if (!(dataArray.count>0)) return;
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        DDMenuController *ddmenu = [[DDMenuController alloc]init];
        TabBarViewController *tabVC =[[TabBarViewController alloc]init];
        LeftVC *leftVc = [[LeftVC alloc]init];
        leftVc.list = [dataArray mutableCopy];
        BaseNavigationController *leftNav = [[BaseNavigationController alloc]initWithRootViewController:leftVc];
        ddmenu.leftViewController = leftNav;
        ddmenu.rootViewController = tabVC;
        delegate.window.rootViewController = ddmenu;
//        delegate.devices = [dataArray mutableCopy];
        delegate.ddmenu = ddmenu;
        [[WiimuUPnP sharedInstance] removeObserver:self];
    }
    else if (sender.tag == 1){
        
        NotfoundVC *vc = [[NotfoundVC alloc]init];
        [[WiimuUPnP sharedInstance] removeObserver:self];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        WifiVC *vc = [[WifiVC alloc]init];
        vc.title = @"SETTINGS- WI-Fi";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - WiimuUPnPObserver methods
- (void)UPnPDeviceAdd:(id<WiimuDeviceProtocol>)device
{
    NSLog(@"-- add %@",[device uuid]);
    




    
    [UPnPDevice([device uuid]) GetControlDeviceInfo:^(NSDictionary *result) {
        if([result[@"statuscode"] intValue] != 0)
        {
            //only for old version, use to get friendlyname
            [self dealWithOldVersion:device];
            
            return;
        }
        
        NSDictionary * statusDic = [NSJSONSerialization JSONObjectWithData:[result[@"status"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        //    securemode 等于 0,auth 填成OPEN, encry 填成 NONE
        //    securemode 等于 1,auth 填成getStatus 返回值的auth，encry填成getStatus 返回值的encry，pwd 填成getStatus返回值的psk
        //    encry 加密类型 ,参考auth
        //    pwd OPEN类型密码为空；有密码时，要以16进制编码传输
        NSString *securemode;
        NSString *auth;
        NSString *encry;
        NSString *pwd = [NSString stringWithFormat:@"%@",statusDic[@"psk"]];
        if (pwd.length>0) {
            
            pwd =[NSString stringWithFormat:@"%@",[self convertStringToHexStr:pwd]];
            
        }else{
            pwd = @"OPEN";
        }
        if ([statusDic[@"securemode"] intValue] == 1) {
            
            securemode = @"1";
            auth =statusDic[@"auth"];
            encry =statusDic[@"encry"];
        }else{
            
            securemode = @"0";
            auth =@"OPEN";
            encry =@"NONE";
        }

        NSDictionary * infoDic = @{@"ip":[device ip],@"uuid":[device uuid],@"ssid":statusDic[@"ssid"]?:@"",@"name":statusDic[@"DeviceName"]?:@"",@"ch":statusDic[@"WifiChannel"],@"securemode":securemode,@"auth":auth,@"encry":encry,@"pwd":pwd,@"SlaveList":result[@"SlaveList"]};
        
//        [dataArray addObject:infoDic];
        [self dataAarrayAddObject:infoDic];
        
        NSString *slavestr = result[@"SlaveList"];
        if (slavestr.length>10) {
            
            NSData *data = [slavestr dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *slavedic = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            NSArray *temp = slavedic[@"slave_list"];
            for (NSDictionary *model in temp) {
                
                NSMutableDictionary *gropdic = [NSMutableDictionary dictionaryWithDictionary:model];
                [gropdic setObject:@"1" forKey:@"grouping"];
                 [self dataAarrayAddObject:gropdic];
            }
           

        }

        
    }];
}

- (void)dataAarrayAddObject:(NSDictionary *)dic{
    
    [dataArray addObject:dic];
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.devices = [dataArray mutableCopy];
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

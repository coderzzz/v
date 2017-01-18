//
//  InfoVC.m
//  ibulb
//
//  Created by Interest on 2016/11/2.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "InfoVC.h"
#import "WiimuUPnP.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "AppDelegate.h"
@interface InfoVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation InfoVC


{
    NSMutableArray *list;
    NSMutableArray *contenlist;
}
#pragma mark ViewLife cyle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    list = [@[@"Model",@"Source",@"Battery Level",@"Light Dimming",@"Wi-Fi Strength",@"Startup Volume",@"ID",@"MAC",@"Firmware"]mutableCopy];
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) GetControlDeviceInfo:^(NSDictionary *result) {
        if([result[@"statuscode"] intValue] != 0)
        {
            return;
        }
        NSString *jsonstr = result[@"status"];
        NSData *data =[jsonstr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        if (!err) {
            
           
            NSString *mode = dic[@"DeviceName"];
            NSString *source = @"WI-FI";
            NSString *battery = [NSString stringWithFormat:@"%@%%",dic[@"battery"]];
            NSString *light = @"70%";
            NSString *wifi = @"Excellen";
            NSString *volume = [NSString stringWithFormat:@"%@%%",result[@"volume"]];
            NSString *d =dic[@"ssid"];
            NSString *mac = dic[@"MAC"];
            NSString *firmware = dic[@"firmware"];
            contenlist = [@[mode,source,battery,light,wifi,volume,d,mac,firmware]mutableCopy];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableview reloadData];
            
        });
        
    }];

}






#pragma mark Action







#pragma mark Service






#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [contenlist count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mycell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text = list[indexPath.row];
    cell.detailTextLabel.text = contenlist[indexPath.row];
    
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end
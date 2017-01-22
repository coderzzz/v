//
//  SettingVC.m
//  ibulb
//
//  Created by Interest on 2016/11/2.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "SettingVC.h"
#import "RenameVC.h"
#import "Firmware.h"
#import "ResetVC.h"
#import "WiimuUPnP.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "AppDelegate.h"
#import "VolumeViewController.h"
@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate,VolumeViewControllerDelegate,RenameVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation SettingVC

{
    NSMutableArray *list;
    NSMutableArray *contenlist;
    NSString *needUpdate;
    NSString *firmware;
}
#pragma mark ViewLife cyle

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
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
            
        
            
            NSString *name = dic[@"DeviceName"];
            NSString *volume = [NSString stringWithFormat:@"%@%%",result[@"volume"]];
            NSString *light = @"70%";
            needUpdate = [NSString stringWithFormat:@"%@%%",result[@"VersionUpdate"]];
            firmware = dic[@"firmware"];
            contenlist = [@[@[name,volume,light],@[@"",@""]]mutableCopy];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableview reloadData];
            
        });
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    list = [@[@[@"Name",@"Startup Volume",@"LED intensity"],@[@"Check for new",@"Set to Factory Default"]]mutableCopy];
    
}
#pragma mark Action







#pragma mark Service


#pragma mark VolumeViewControllerDelegate
- (void)didUpdateStartupVolume:(float)value type:(NSString *)type{
    
    if ([type isEqualToString:@"1"]) {
        
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infoDic = [delegate.devices firstObject];
        [UPnPDevice(infoDic[@"uuid"]) sendVolume:value result:^(NSDictionary *result) {
            
            if([result[@"statuscode"] intValue] != 0)
            {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray *ary = [contenlist firstObject];
                NSString *volume = [NSString stringWithFormat:@"%.f%%",value];
                contenlist = [@[@[ary[0],volume,ary[2]],@[@"",@""]]mutableCopy];
                [self.tableview reloadData];
                
            });
            
            
        }];

    }
    else{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            NSArray *ary = [contenlist firstObject];
            NSString *led = [NSString stringWithFormat:@"%.f%%",value];
            contenlist = [@[@[ary[0],ary[1],led],@[@"",@""]]mutableCopy];
            [self.tableview reloadData];
        });
    }
}

#pragma mark RenameVCDelegate
- (void)didUpdateName:(NSString *)value
{
    NSArray *ary = [contenlist firstObject];
    contenlist = [@[@[value,ary[1],ary[2]],@[@"",@""]]mutableCopy];
    [self.tableview reloadData];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [contenlist count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [contenlist[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mycell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = list[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = contenlist[indexPath.section][indexPath.row];
    
    return cell;
}


#pragma mark UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0 && indexPath.section ==0) {
        
        RenameVC *vc = [[RenameVC alloc]init];
        vc.title = @"RENAME YOUR PRODUCT";
        vc.isRename = YES;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row == 1 && indexPath.section ==0) {
        
        VolumeViewController *vc = [[VolumeViewController alloc]init];
        vc.title = @"Startup Volume";
        vc.type = @"1";
        vc.value = [contenlist[indexPath.section][indexPath.row] floatValue];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row == 2 && indexPath.section ==0) {
        
        VolumeViewController *vc = [[VolumeViewController alloc]init];
        vc.title = @"LED";
        vc.type = @"2";
        vc.value = [contenlist[indexPath.section][indexPath.row] floatValue];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row == 0 && indexPath.section ==1){
        
        Firmware *vc = [[Firmware alloc]initWithFirmware:firmware needUpdate:[needUpdate boolValue]];
        vc.title = @"NEW FIRMWARE";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row == 1 && indexPath.section ==1){
        
        ResetVC *vc = [[ResetVC alloc]init];
        vc.title = @"FACTORY RESET";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
}

@end

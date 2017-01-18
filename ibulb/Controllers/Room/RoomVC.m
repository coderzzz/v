//
//  RoomVC.m
//  ibulb
//
//  Created by Interest on 2016/10/28.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "RoomVC.h"
#import "PlaceVC.h"
#import "InfoVC.h"
#import "SettingVC.h"
#import "WiimuUPnP.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "AppDelegate.h"
@interface RoomVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *headview;
@property (weak, nonatomic) IBOutlet UILabel *connectlab;
@property (weak, nonatomic) IBOutlet UILabel *volumelab;
@property (weak, nonatomic) IBOutlet UISlider *volumeProgress;


@end

@implementation RoomVC


{
    NSMutableArray *list;
}
#pragma mark ViewLife cyle

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self updateUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview setTableHeaderView:self.headview];
    list = [@[@"Tuning and Placement",@"Information",@"Settings"]mutableCopy];
}

#pragma mark Action
- (IBAction)changeVolumeAction:(UISlider *)sender {
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
     _volumelab.text = [NSString stringWithFormat:@"%.2f%%",sender.value];
    [UPnPDevice(infoDic[@"uuid"]) sendVolume:sender.value result:^(NSDictionary *result) {
        
       

    }];
}

- (void)updateUI{
    
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
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.navigationItem.title =dic[@"DeviceName"];
                
            });

        }
        
        
        
    }];
    
    [UPnPDevice(infoDic[@"uuid"]) GetInfoEx:^(NSDictionary *result) {
        if([result[@"statuscode"] intValue] != 0)
        {
            return;
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            self.navigationItem.title
            //volume
            _volumeProgress.value = [result[@"OutCurrentVolume"] floatValue];
            
            _volumelab.text = [NSString stringWithFormat:@"%.2f%%",[result[@"OutCurrentVolume"] floatValue]];
            if ([result[@"InternetAccess"] intValue] == 1) {
                
                _connectlab.text = @"CONNECTED";
            }
            else{
                
                _connectlab.text = @"UNCONNECTED";
            }

        });

    }];

}
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = list[indexPath.row];
    
    
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    InfoVC
//    SettingVC
    if (indexPath.row == 0) {
        
        PlaceVC *vc = [[PlaceVC alloc]init];
        vc.title = list[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1){
        
        InfoVC *vc = [[InfoVC alloc]init];
        vc.title = list[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        SettingVC *vc = [[SettingVC alloc]init];
        vc.title = list[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end

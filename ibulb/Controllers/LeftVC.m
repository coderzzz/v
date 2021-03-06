//
//  LeftVC.m
//  ibulb
//
//  Created by Interest on 2016/10/28.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "LeftVC.h"
#import "LeftCell.h"
#import "AppDelegate.h"
#import "WiimuUPnP.h"
#import "DDXML.h"
#import "Netconfig.h"
#import "DDXMLElementAdditions.h"
@interface LeftVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *headview;
@property (weak, nonatomic) IBOutlet UILabel *alab;

@end

@implementation LeftVC
{
    NSMutableArray *progess;
}

#pragma mark ViewLife cyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    progess = [NSMutableArray array];
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *temp = [delegate.devices copy];
    self.list = [NSMutableArray array];
    

    for (int a = 0; a<temp.count; a++) {
        
        NSDictionary *dic = temp[a];
        NSString *isgroup = [NSString stringWithFormat:@"%@",dic[@"grouping"]];
        if (a == 0) {
            
            [self.list addObject:dic];
        }
        else if ([isgroup isEqualToString:@"1"]){
            
            [self.list addObject:dic];
        }else{
            
            break;
        }
    }
    
    
    [self.tableview reloadData];
    
   
    
    
    
    for (NSDictionary *infoDic in self.list) {
    
        [UPnPDevice(infoDic[@"uuid"]) GetInfoEx:^(NSDictionary *result) {
            if([result[@"statuscode"] intValue] != 0)
            {
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
   
                
                //progress
                if([self secondFromTimeString:result[@"OutTrackDuration"]] != 0)
                {
//                    _progressSlider.value = [self secondFromTimeString:result[@"OutRelTime"]]/[self secondFromTimeString:result[@"OutTrackDuration"]];
                    
                    NSString *value  = [NSString stringWithFormat:@"%f",[self secondFromTimeString:result[@"OutRelTime"]]/[self secondFromTimeString:result[@"OutTrackDuration"]]];
                    [progess addObject:value];
                }
                else{
                    
                    [progess addObject:@"0"];
                }
                NSLog(@"progess %@",progess);
                [self.tableview reloadData];
               
            });
            
        }];
        
    }
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"SPEAKER GROUP EMMA'S ROOM", nil);
    self.alab.text = NSLocalizedString(@"ADD MORE", nil);
    UINib *nib = [UINib nibWithNibName:@"LeftCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"leftCell"];
    [self.tableview setTableFooterView:self.headview];
    
}

- (void)back{
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.ddmenu showRootController:YES];
}




#pragma mark Action
- (IBAction)addmore:(id)sender {
    
    
    Netconfig *vc = [[Netconfig alloc]init];
    vc.title = @"NETWORK CONFIGURATION";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)left:(UIButton *)btn{
    
     NSDictionary *dic = self.list[btn.tag];
     [UPnPDevice(dic [@"uuid"]) sendChangeChannel:wiimu_channel_left result:^(NSDictionary *result) {
         
     }];
}

- (void)right:(UIButton *)btn{
    
    NSDictionary *dic = self.list[btn.tag];
    [UPnPDevice(dic [@"uuid"]) sendChangeChannel:wiimu_channel_right result:^(NSDictionary *result) {
        
    }];
}

- (void)changeValue:(UISlider *)slider{
    
    if (slider.tag < self.list.count) {
     
        NSDictionary *infoDic = self.list[slider.tag];
        [UPnPDevice(infoDic[@"uuid"]) sendVolume:slider.value*100 result:^(NSDictionary *result) {
            
        }];
        
    }
}

- (NSTimeInterval)secondFromTimeString:(NSString *)timeString
{
    NSTimeInterval seconds = 0;
    NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
    
    if([timeArray count] != 3)
    {
        return 0;
    }
    
    int hour = [timeArray[0] intValue];
    int min = [timeArray[1] intValue];
    int sec = [timeArray[2] intValue];
    
    seconds+=hour*3600+min*60+sec;
    
    return seconds;
}

- (NSString *)timeStringFromFloat:(CGFloat)time
{
    int hr = (int)(time / 3600);
    int min = (time-3600*hr)/60;
    int sec = (time-3600*hr-60*min);
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hr,min,sec];
}






#pragma mark Service






#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row<progess.count) {
        
        cell.slider.value = [progess[indexPath.row] floatValue];
        
    }
    NSDictionary *dic = self.list[indexPath.row];
    NSString *type =[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"type%@",dic[@"uuid"]]];
    if ([type isEqualToString:@"1"]) {
        
        cell.imgv.image = [UIImage imageNamed:@"19"];
    
    }else{
        
        cell.imgv.image = [UIImage imageNamed:@"04-1"];
    }
    cell.leftbtn.tag = indexPath.row;
    cell.rightbtn.tag = indexPath.row;
    cell.titlelab.text =dic[@"name"];
    [cell.leftbtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightbtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
    cell.slider.tag = indexPath.row;
    [cell.slider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end

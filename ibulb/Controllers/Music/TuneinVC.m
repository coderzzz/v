//
//  TuneinVC.m
//  ibulb
//
//  Created by Interest on 2016/10/31.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "TuneinVC.h"
#import "LocalRadioVC.h"
#import "WiimuUPnP.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "AppDelegate.h"
#import "PlayVC.h"
#import "LinkView.h"
@interface TuneinVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation TuneinVC
{
    NSMutableArray *list;
    NSDictionary *infoDic;
    NSString * currentQueue;
}
#pragma mark ViewLife cyle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    infoDic = [delegate.devices firstObject];
    list = [NSMutableArray array];
    [UPnPDevice(infoDic[@"uuid"]) getTuneinRootData:^(NSDictionary *result) {
        
        NSLog(@"%@",result);
        if([result[@"statuscode"] intValue] != 0)
        {
            return;
        }
        
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:result[@"data"] options:0 error:nil];
        if(xmlDoc == nil)
        {
            NSLog(@"error parse");
            return;
        }
        
        DDXMLElement *bodyElement = [[xmlDoc rootElement] elementForName:@"body"];
        NSArray *array = [bodyElement elementsForName:@"outline"];
        for(DDXMLElement * element in array)
        {
            NSDictionary *dic = [element attributesAsDictionary];
            if (dic) {
                
                [list addObject:dic];
            }
            
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
    
    return [list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row<list.count) {
        
        NSDictionary *dic = list[indexPath.row];
        cell.textLabel.text = dic[@"text"];
    }
    
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    PlayVC *vc = [[PlayVC alloc]initWithPlayQueue:queueArray[indexPath.row] playIndex:1];
//    [self.navigationController pushViewController:vc animated:YES];
    
    if (indexPath.row<list.count) {
        
        NSDictionary *dic = list[indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"URL"]]];
        LocalRadioVC *vc = [[LocalRadioVC alloc]initWithTitle:dic[@"text"] radioUrl:url];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end

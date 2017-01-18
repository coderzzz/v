//
//  ChosespeakerVC.m
//  ibulb
//
//  Created by Interest on 2016/10/28.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "ChosespeakerVC.h"
#import "ChosespeakerCell.h"
#import "PressVC.h"
@interface ChosespeakerVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ChosespeakerVC

{
    NSMutableArray *list;
}
#pragma mark ViewLife cyle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"ChosespeakerCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"chose"];
    
}

#pragma mark Action







#pragma mark Service






#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChosespeakerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chose"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PressVC *vc = [[PressVC alloc]init];
    vc.title = @"PRESS THE BUTTON";
    vc.password = self.password;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

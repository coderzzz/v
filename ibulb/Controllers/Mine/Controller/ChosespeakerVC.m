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
#import "TurnVC.h"
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
    if (indexPath.row == 1) {
        
        cell.img1.hidden = YES;
        cell.imag2.hidden = NO;
        cell.lab.text =@"STOCKHOLM 2.0";
    }
    else{
        
        cell.img1.hidden = NO;
        cell.imag2.hidden = YES;
        
        cell.lab.text = NSLocalizedString(@"COPENHAGEN 2.0", nil);;
    }
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TurnVC *vc = [[TurnVC alloc]init];
    vc.password = self.password;
    vc.type = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

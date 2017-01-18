//
//  TuningSetVC.m
//  ibulb
//
//  Created by Interest on 2016/11/2.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "TuningSetVC.h"
#import "TusetCell.h"
@interface TuningSetVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation TuningSetVC

{
    NSMutableArray *list;
}
#pragma mark ViewLife cyle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TusetCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"tcell"];
}






#pragma mark Action







#pragma mark Service






#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TusetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tcell"];
    
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end

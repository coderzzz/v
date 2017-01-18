//
//  SettingViewController.m
//  ibulb
//
//  Created by Interest on 16/1/7.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "LampCell.h"
#import "SettingSectionView.h"
#import "ChoseCell.h"
#import "RealName.h"
#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"
#import "ZZBluetoothManger.h"
#import "LocalCell.h"
//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *choseTable;

@property (nonatomic, strong) NSMutableArray *choseList;

@property (nonatomic, strong) NSMutableArray *saveList;

@end

@implementation SettingViewController
{
    UITapGestureRecognizer *tap;
}

#pragma mark getter

- (NSMutableArray *)choseList{
    
    if (_choseList == nil) {
        
        
        _choseList = [NSMutableArray array];
    }
    return _choseList;
    
}

- (NSMutableArray *)saveList{
    
    if (_saveList == nil) {
        
        
        _saveList = [NSMutableArray array];
    }
    
    return _saveList;
}

- (UITableView *)choseTable{
    
    if (_choseTable == nil) {
        
        
        _choseTable = [[UITableView alloc]initWithFrame:CGRectMake(20,110,ScreenWidth-40, ScreenHeight-120-49)];
        
        _choseTable.layer.masksToBounds = YES;
        
        _choseTable.layer.cornerRadius = 3.0;
        
        _choseTable.hidden = YES;
//        
//        
        _choseTable.delegate = self;
        
        _choseTable.dataSource = self;
        
        _choseTable.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1];
        
        _choseTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UINib *lampnib=[UINib nibWithNibName:@"ChoseCell" bundle:nil];
        
        [_choseTable registerNib:lampnib forCellReuseIdentifier:@"chose"];

        
        
    }
    
    
    return _choseTable;
    
}

#pragma mark ViewLife cyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *lampnib=[UINib nibWithNibName:@"LampCell" bundle:nil];
    
    [self.tableview registerNib:lampnib forCellReuseIdentifier:@"lampCell"];
    
    
    UINib *setnib=[UINib nibWithNibName:@"LocalCell" bundle:nil];
    
    [self.tableview registerNib:setnib forCellReuseIdentifier:@"Local"];
    
    [self.view addSubview:self.choseTable];
    
    [self reloadTableView];
    
   
    
}



#pragma mark Action

-(void)showChoseTable{
    
    self.choseTable.hidden = !self.choseTable.hidden;
    
    [self reloadChoseTableView];
    
}
- (void)reloadTableView{
    
    NSArray *ary = [RealName MR_findAll];
    
    if (ary.count>0) {
        
        [self.saveList removeAllObjects];
        
        [self.saveList addObjectsFromArray:ary];
        
        [self.tableview reloadData];
    }
}

- (void)reloadChoseTableView{
    
    self.choseList = [[ZZBluetoothManger shareInstance] lightList];
    
    [self.choseTable reloadData];

}

- (void)changeName:(UIButton *)btn{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"test4", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"test5", nil) otherButtonTitles:NSLocalizedString(@"test6", nil), nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    alert.tag = btn.tag;

    [alert show];
    
}

- (void)deleAction:(UIButton *)btn{
    
    RealName *model = self.saveList[btn.tag];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DidDelNotifi" object:model];
    
    [model MR_deleteEntity];

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [self.saveList removeObjectAtIndex:btn.tag];
    
    [self.tableview reloadData];

}

#pragma mark Service



#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.choseTable) {
        
        return self.choseList.count;
    }
    
    return self.saveList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.choseTable) {
        
        ChoseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chose"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        DataModel *model = self.choseList[indexPath.row];
        
        cell.lab.text = model.cbPeripheral.name;
        
        return cell;
    }
    
    
    if (indexPath.row < self.saveList.count) {
        
        LocalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Local"];
        
        RealName *model = self.saveList[indexPath.row];
        
        cell.nameLab.text = model.name;
        
        cell.editBtn.tag = indexPath.row;
        
        cell.deleBtn.tag = indexPath.row;
        
        [cell.editBtn addTarget:self action:@selector(changeName:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.deleBtn addTarget:self action:@selector(deleAction:) forControlEvents:UIControlEventTouchUpInside];
        
    
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        
        LampCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lampCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    
    
    
}

#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.choseTable) {
        
        
        DataModel *model = self.choseList[indexPath.row];
        
        
        NSArray *ary = [RealName MR_findAll];
        
        
        BOOL isExit = NO;
        
        for (RealName *real in ary) {
            
            if ([real.udid isEqualToString:model.cbPeripheral.identifier.UUIDString]) {
                
                isExit = YES;
                
            }
        }
        
        
        if (isExit) {
            
            
            [self showHudWithString:NSLocalizedString(@"test8", nil)];
            
            
        }
        
        else{
            
            RealName *sub = [RealName MR_createEntity];
            
            sub.name = model.cbPeripheral.name;
            
            sub.udid = model.cbPeripheral.identifier.UUIDString;
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            [self reloadTableView];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DidAddNotifi" object:model];
            
        }
        
    }
    
    else{
        
        
        if (indexPath.row < self.saveList.count) {
            
            
            
            
        }else{
            
            [self showHud];
            
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideChoseTable:)];
            
            
            tap.delegate = self;
            
            [[ZZBluetoothManger shareInstance]startScanWithBlock:^(NSMutableArray *ary) {
                
                [self hideHud];
                
                self.choseList = ary;
                
                [self reloadChoseTableView];
                //                deviceList = ary;
                //
                //                [self reloadUi];
                
            }];
            
            [self.view addGestureRecognizer:tap];
            
            self.choseTable.hidden = NO;
            
            
            
        }
        
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
        //
        //        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        //
        //        alert.tag = indexPath.row;
        //
        //        [alert show];
        
    }
    
}
- (void)hideChoseTable:(UITapGestureRecognizer *)ges{
    
    
    
    
    self.choseTable.hidden = YES;
    
    [self.view removeGestureRecognizer:tap];
    
    
    
    
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    if (tableView == self.choseTable) {
//
//        return nil;
//    }
//
//    SettingSectionView *view = [[SettingSectionView alloc]init];
//
//    [view.eidtBtn addTarget:self action:@selector(showChoseTable) forControlEvents:UIControlEventTouchUpInside];
//
//
//    return view;
//
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row <self.saveList.count) {
        
        return 50;
    }
    
    return 44;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    if (tableView == self.choseTable) {
//
//        return 0.001;
//    }
//
//    return 40;
//}
#pragma mark UIGestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    
    CGPoint point = [touch locationInView:self.view];
    
    if (!CGRectContainsPoint([self.choseTable frame], point)) {
        //to-do
        
        return YES;
    }
    return NO;
    //    if (touch.view != self.choseTable && touch.view.superview != self.choseTable) {
    //
    //
    //
    //        return YES;
    //    }
    //    return NO;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        UITextField *texfield = [alertView textFieldAtIndex:0];
        
        
        if (texfield.text.length>0) {
            
            
            RealName *name = self.saveList[alertView.tag];
            
            name.name = texfield.text;
            
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
            
            [self reloadTableView];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DidChangeNameNotifi" object:name];
            
        }
        else{
            
            [self showHudWithString:NSLocalizedString(@"test9", nil)];
        }
        
    }
    
}

@end

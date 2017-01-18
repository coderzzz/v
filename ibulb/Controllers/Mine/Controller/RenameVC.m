//
//  RenameVC.m
//  ibulb
//
//  Created by Interest on 2016/10/25.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "RenameVC.h"
#import "CoupenCell.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "LeftVC.h"
#import "BaseNavigationController.h"
#import "AFHttp.h"
@interface RenameVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UICollectionView *collectview;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) IBOutlet UIView *keyview;
@property (weak, nonatomic) IBOutlet UIButton *savebtn;

@end

@implementation RenameVC

#pragma mark getter



#pragma mark ViewLife cyle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tf becomeFirstResponder];
    self.dataSource = [@[@[@"31",@"BATHROM"],@[@"32",@"KITCHEN"],
                         @[@"33",@"BEDROM"],@[@"34",@"STUDY"],
                         @[@"35",@"LIVINGROM"],@[@"36",@"GARAGE"]]mutableCopy];
    [self setupUI];
}


- (void)setupUI{
    
    UINib *nib = [UINib nibWithNibName:@"CoupenCell" bundle:nil];
    [self.collectview registerNib:nib forCellWithReuseIdentifier:@"CouCell"];
    self.tf.inputAccessoryView = self.keyview;
    self.title = @"RENAME YOUR PRODUCT";
    self.savebtn.layer.masksToBounds = YES;
    self.savebtn.layer.cornerRadius = 5;
    self.savebtn.layer.borderColor = [[UIColor colorWithRed:207.0/255.0 green:150.0/255.0 blue:92.0/255.0 alpha:1] CGColor];
    self.savebtn.layer.borderWidth = 1;
}




#pragma mark Action
- (IBAction)saveAction:(id)sender {
    
    if (self.tf.text.length>0) {
     
        [self.tf resignFirstResponder];
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infodic;
        
        if (self.isRename) {
            
            infodic = [delegate.devices firstObject];
        }
        else{
            
            infodic = [delegate.devices lastObject];
        }
//        NSString *uuid = infodic[@"uuid"];
        
//        http://10.10.10.254/httpapi.asp?command=setDeviceName:%s
        
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/httpapi.asp?command=setDeviceName:%@",infodic[@"ip"],self.tf.text]]];
//        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [[AFHttp shareInstanced]reNameWithIP:infodic[@"ip"] name:self.tf.text completionBlock:^(id obj) {
            
            
            NSLog(@"%@",obj);
            
            NSMutableDictionary *model = [NSMutableDictionary dictionaryWithDictionary:infodic];
            [model setValue:self.tf.text forKey:@"name"];
            [delegate.devices replaceObjectAtIndex:[delegate.devices indexOfObject:infodic]          withObject:model];
            
            if (self.isRename) {
                
                [self.delegate didUpdateName:self.tf.text];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                
                DDMenuController *ddmenu = [[DDMenuController alloc]init];
                TabBarViewController *tabVC =[[TabBarViewController alloc]init];
                LeftVC *leftVc = [[LeftVC alloc]init];
                leftVc.list = delegate.devices;
                BaseNavigationController *leftNav = [[BaseNavigationController alloc]initWithRootViewController:leftVc];
                ddmenu.leftViewController = leftNav;
                ddmenu.rootViewController = tabVC;
                delegate.window.rootViewController = ddmenu;
                delegate.ddmenu = ddmenu;
            }
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            
        }];
        
//        [[NSUserDefaults standardUserDefaults]setObject:@{@"uuid":uuid,@"roomName":self.tf.text} forKey:@"RoomName"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        
    }
    
}




#pragma mark Service






#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  [self.dataSource count];
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CoupenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CouCell" forIndexPath:indexPath];
    cell.imgv.image = [UIImage imageNamed:self.dataSource[indexPath.row][0]];
    cell.title.text =self.dataSource[indexPath.row][1];
    return cell;
}


#pragma mark UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tf.text =self.dataSource[indexPath.row][1];
    
    
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(90, 80);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(20, 10, 10, 10);
}

@end

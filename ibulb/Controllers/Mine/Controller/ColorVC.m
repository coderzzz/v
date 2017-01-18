//
//  ColorVC.m
//  ibulb
//
//  Created by Interest on 2016/10/25.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "ColorVC.h"
#import "RenameVC.h"
#import "CircleView.h"
#import "AppDelegate.h"
@interface ColorVC ()
@property (weak, nonatomic) IBOutlet CircleView *circleview;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIImageView *colorview;

@end

@implementation ColorVC
{
    NSArray *colorlist;
    NSString *selectColor;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"A MATTER OF COLOR";
    self.circleview.target = self;
    self.circleview.selector = @selector(endtracking);
    self.colorview.layer.masksToBounds = YES;
    self.colorview.layer.cornerRadius = 190/2;
    
    
//    colorlist =@[@"F1E3BE",@"CBD9E5",@"DAE9EF",@"8E8D8C",@"FFFFFF",@"8A9182",@"7A8894",@"FFFFFF",@"DADFE0",@"EDE1DF",@"767C61"];
    
    colorlist =@[@"F0CD71",@"92B4D2",@"B6DCEB",@"605F5E",@"CBCAC7",@"6A755F",@"535F6B",@"D2D1C8",@"A4B3B7",@"E1BBB3",@"585F3D"];
    selectColor =colorlist[0];
    self.colorview.backgroundColor =[self colorWithHexString:selectColor];
}

- (void)endtracking{
    
    int value =self.circleview.currentValue;
    
    int a = 360/colorlist.count;
    int index = value/a;
    NSLog(@"index =%d",index);
    if (index<colorlist.count) {
     
        selectColor =colorlist[index];
        self.colorview.backgroundColor =[self colorWithHexString:colorlist[index]];
        
    }
    
}

- (IBAction)next:(id)sender {
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices lastObject];
    [[NSUserDefaults standardUserDefaults]setObject:selectColor forKey:infoDic[@"uuid"]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    RenameVC *vc = [[RenameVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end

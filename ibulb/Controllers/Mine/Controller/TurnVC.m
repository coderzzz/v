//
//  TurnVC.m
//  ibulb
//
//  Created by sam on 2017/4/9.
//  Copyright © 2017年 Interest. All rights reserved.
//

#import "TurnVC.h"
#import "PressVC.h"
@interface TurnVC ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation TurnVC
- (IBAction)acton:(id)sender {
    PressVC *vc = [[PressVC alloc]init];
    vc.title = NSLocalizedString(@"PRESS THE BUTTON", nil);
    vc.password = self.password;
    vc.type = self.type;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"turn", nil);
    self.lab.text = NSLocalizedString(@"make", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

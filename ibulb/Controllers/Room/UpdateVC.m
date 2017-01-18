//
//  UpdateVC.m
//  ibulb
//
//  Created by Interest on 2016/11/4.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "UpdateVC.h"
#import "AFHttp.h"
#import "AppDelegate.h"
@interface UpdateVC ()

@end

@implementation UpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    //调用该接口后，如果有升级包，则设备会开始下载升级包,下载完成后会自动开始烧录；升级过程请勿断电
    [[AFHttp shareInstanced]updateStartWithIP:infoDic[@"ip"] completionBlock:^(id obj) {
        
        NSLog(@"%@",obj);
        
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_queue_create("UpdateStatusQueue", NULL));
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            
            
            [[AFHttp shareInstanced]updateStatusWithIP:infoDic[@"ip"] completionBlock:^(id obj) {
                
                if ([obj isEqualToString:@"30"]) {
                    
                    dispatch_source_cancel(timer);
                }
                
            } failureBlock:nil];
            
        });
        dispatch_source_set_cancel_handler(timer, ^{
            NSLog(@"cancel");
        });
        dispatch_resume(timer);

    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
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

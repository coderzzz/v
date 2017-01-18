//
//  RenameVC.h
//  ibulb
//
//  Created by Interest on 2016/10/25.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "BaseViewController.h"
@protocol RenameVCDelegate <NSObject>

@required

- (void)didUpdateName:(NSString *)value;

@end
@interface RenameVC : BaseViewController
@property (nonatomic, assign) id<RenameVCDelegate>delegate;
@property (nonatomic, assign) BOOL isRename;
@end

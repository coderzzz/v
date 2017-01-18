//
//  VolumeViewController.h
//  ibulb
//
//  Created by Interest on 2016/11/30.
//  Copyright © 2016年 Interest. All rights reserved.
//


#import "BaseViewController.h"
@protocol VolumeViewControllerDelegate <NSObject>

@required

- (void)didUpdateStartupVolume:(float)value;

@end
@interface VolumeViewController : BaseViewController
@property (nonatomic, weak) id<VolumeViewControllerDelegate>delegate;
@property (nonatomic, assign) float value;
@end

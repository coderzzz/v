//
//  PlayVC.h
//  ibulb
//
//  Created by Interest on 2016/11/16.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "BaseViewController.h"

@interface PlayVC : BaseViewController

@property (assign, nonatomic) int selectindex;

- (id)initWithMPMediaItemProperty:(NSString *)property name:(NSString *)name;

- (id)initWithPlayQueue:(NSString *)queueName playIndex:(int)index;

- (id)initWithRadioModel:(NSDictionary *)model;

- (id)initWithHome:(BOOL)ishome;
@end

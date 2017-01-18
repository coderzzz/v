//
//  AppDelegate.h
//  ibulb
//
//  Created by Interest on 16/1/7.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *devices;
@property (strong, nonatomic) DDMenuController *ddmenu;

@end


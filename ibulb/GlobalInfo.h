//
//  GlobalInfo.h
//  WiimuUPnPDemo
//
//  Created by 赵帅 on 15/1/9.
//  Copyright (c) 2015年 Wiimu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalInfo : NSObject

+ (GlobalInfo *)sharedInstance;

@property (assign,readonly) int httpServerPort;
@property (retain,readonly) NSString * httpServerIP;

@end

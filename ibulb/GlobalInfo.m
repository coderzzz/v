//
//  GlobalInfo.m
//  WiimuUPnPDemo
//
//  Created by 赵帅 on 15/1/9.
//  Copyright (c) 2015年 Wiimu. All rights reserved.
//

#import "GlobalInfo.h"
#import <UIKit/UIKit.h>

#import "HTTPServer.h"
#import "IPAddress.h"
#include <arpa/inet.h>

#define DEMO_PORT 12345

@interface GlobalInfo()
{
    HTTPServer * httpServer;
}

@end

@implementation GlobalInfo

static id sharedInstance = nil;

+ (GlobalInfo *)sharedInstance
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[GlobalInfo alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self createHTTPServer];
    }
    return self;
}

-(void)createHTTPServer
{
    httpServer = [[HTTPServer alloc] init];
    [httpServer setType:@"_http._tcp."];
    
    [httpServer setPort:DEMO_PORT];
    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory
                                                          , NSUserDomainMask
                                                          , YES);
    NSString *tmpDir =[patchs firstObject];
    [httpServer setDocumentRoot:tmpDir];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while ([httpServer isRunning]) {
            [httpServer stop];
            [NSThread sleepForTimeInterval:1];
        }
        
        NSError *error;
        if([httpServer start:&error])
        {
            NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
            _httpServerPort = [httpServer listeningPort];
        }
        else
        {
            NSLog(@"Error starting HTTP Server: %@", error);
        }
    });
}

-(NSString *)httpServerIP
{
    int addr[32] = {0};
    int number = 0;
    
    if([[UIDevice currentDevice].model rangeOfString:@"Simulator"].location != NSNotFound)
    {
        number = GetIPAddresses(addr);
    }
    else
    {
        number = GetWifiIPAddresses(addr);
    }
    struct in_addr ia;
    ia.s_addr = addr[0];
    
    return [NSString stringWithFormat:@"%s",inet_ntoa(ia)];
}

@end

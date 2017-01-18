//
//  UPnPInterface.h
//  upnpx
//
//  Created by 赵帅 on 14/12/1.
//  Copyright (c) 2014年 wiimu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiimuDeviceProtocol.h"

@protocol WiimuUPnPObserver <NSObject>

@optional
/**
 *  New device online notify.
 *
 *  @param device Device info
 */
- (void)UPnPDeviceAdd:(id<WiimuDeviceProtocol>)device;

/**
 *  Device offline notify.
 *
 *  @param device Device info
 */
- (void)UPnPDeviceRemove:(id<WiimuDeviceProtocol>)device;

/**
 *  When come back from background, this method will be called as fast as possible
 *  to tell you which exsited device is current online. If a device not be called
    for 5s, then UPnPDeviceRemove: will be called.
 *  @param device Device info
 */
- (void)UPnPDeviceReady:(id<WiimuDeviceProtocol>)device;

/**
 *  Smart Link find device notify.
 *  1 This method may come earlier or later than UPnPDeviceAdd:.
 *  2 Between startSmartLink and stopSmartLink, one device will only come once.
 *  @param device Device info
 */
- (void)UPnPDeviceSmartLink:(id<WiimuDeviceProtocol>)device;

/**
 *  Device event notify.
 *
 *  @param device Device info
 *  @param event xml
 */
- (void)UPnPDeviceEvent:(id<WiimuDeviceProtocol>)device event:(NSString *)event;

@end

@interface WiimuUPnP : NSObject

+ (WiimuUPnP *)sharedInstance;

/**
 *  Open/close SDK log
 *  default is NO
 */
+ (void)setDebugLogOn:(BOOL)logOn;

/**
 *  Device timeout time interval, default 60
 */
@property (assign) int deviceTimeoutInterval;

/**
    Default NO.
 *  If you play musics from ipod library, and need music still be playing even app went to background,then you should change this switch to YES, this will keep SDK alive when goes to background.
    But if this variable is set to YES, you must guarantee app is awake even went to background, otherwise SDK will occur FATAL ERROR.
 */
@property (assign) BOOL needBackgroundMode;

/**
 *  Start SDK search, just call this for once.
 */
- (void)start;

/**
 *  Start SDK search, just call this for once.
 *
 *  This method's purpose is in compatible with old firmware version
 *  which dosen't support our custom m-search command.
 *  So if possible, try to use - (void)start instead of this.
 */
- (void)startCompatibleOldVersion;

/**
 *  Start SDK search, just call this for once.
 *
 *  @param searchKey: The key use to search your devices. If empty, this is equal to - (void)start;
 */
- (void)startWithCustomSearchKey:(NSString *)searchKey;

/**
 *  Clean all devices and search again.
 */
- (void)cleanAndRestart;

- (void)addObserver:(id<WiimuUPnPObserver>)observer;
- (void)removeObserver:(id<WiimuUPnPObserver>)observer;

- (id<WiimuDeviceProtocol>)UPnPDeviceForUUID:(NSString *)uuid;

#pragma mark - Smart Link

/**
 *  SmartLink begin search
 *
 *  @param password Current iPhone's connected AP's password
 */
-(void)startSmartLink:(NSString *)password;

/**
 *  Stop SmartLink search
 */
-(void)stopSmartLink;


#pragma mark - Utility
/**
 *  Current iPhone's connected AP's SSID
    Note: Simulator not supported, return nil.
 *  @return ssid
 */
- (NSString *)getCurrentAp;

/**
 *  To see iPhone connect to our device(wiimu_direct_type) or a router(wiimu_wifi_type).
 *  If some error happens, then return wiimu_none_type;
 *  iOS simulator always return wiimu_wifi_type.
 *
 *  @return see WiimuConnectType
 */
- (WiimuConnectType)currentConnectType;

/**
 *  A simplify define of get UPnPDeviceForUUID
 */
#define UPnPDevice(uuid) [[WiimuUPnP sharedInstance] UPnPDeviceForUUID:uuid]

@end

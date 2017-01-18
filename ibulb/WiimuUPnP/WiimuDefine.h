//
//  WiimuDefine.h
//  upnpx
//
//  Created by 赵帅 on 15/4/27.
//  Copyright (c) 2015年 wiimu. All rights reserved.
//

typedef void (^WiimuSDKReturnBlock)(NSDictionary * result);

typedef enum
{
    wiimu_direct_type,
    wiimu_wifi_type,
    wiimu_none_type
}WiimuConnectType;

typedef enum
{
    wiimu_channel_stereo,
    wiimu_channel_left,
    wiimu_channel_right
}WiimuBoxChannel;

typedef enum
{
    wiimu_queue_listrepeat,
    wiimu_queue_singlerepeat,
    wiimu_queue_shuffle
}WiimuQueueLoopMode;

typedef enum
{
    wiimu_eq_mode_null = 0,
    wiimu_eq_mode_classic,
    wiimu_eq_mode_popular,
    wiimu_eq_mode_jazzy,
    wiimu_eq_mode_vocal,
}WiimuEqualizer;

typedef enum
{
    wiimu_support,
    wiimu_unsupport,
    wiimu_unknown
}WiimuSupportType;

//capability
typedef enum
{
    wiimu_capability_plm = 19
}WiimuDeviceCapabilityEnum;

//play modes
typedef enum
{
    wiimu_plm_linein = 1,
    wiimu_plm_bt,
    wiimu_plm_extusb,
    wiimu_plm_optical
}WiimuDevicePlayModeEnum;

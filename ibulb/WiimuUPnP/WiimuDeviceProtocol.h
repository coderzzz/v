//
//  WiimuDeviceProtocol.h
//  upnpx
//
//  Created by 赵帅 on 14/12/4.
//  Copyright (c) 2014年 wiimu. All rights reserved.
//

#import "WiimuSourceProtocol.h"
#import "WiimuDefine.h"

@protocol WiimuDeviceProtocol <WiimuSourceProtocol>

-(NSString *)uuid;
-(NSString *)ip;
-(int)port;

/**
 *  To see if a capability is supported
 *
 *  @param stream See WiimuDeviceCapabilityEnum
 *
 *  @return See WiimuSupportType
 */
- (WiimuSupportType)supportCapbility:(WiimuDeviceCapabilityEnum)capability;

/**
 *  To see if a play mode is supported
 *
 *  @param stream See WiimuDevicePlayModeEnum
 *
 *  @return See WiimuSupportType
 */
- (WiimuSupportType)supportPlm:(WiimuDevicePlayModeEnum)plm;

#pragma mark - Play Command
/**
 *  Play command
 *
 *  @param result
    statuscode: status code
 */
- (void)sendPlay:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Pause command
 *
 *  @param result
    statuscode: status code
 */
- (void)sendPause:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Stop command
 *
 *  @param result
    statuscode: status code
 */
- (void)sendStop:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Next command
 *
 *  @param result
    statuscode: status code
 */
- (void)sendPlayNext:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Prev command
 *
 *  @param result
    statuscode: status code
 */
- (void)sendPlayPrev:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Set volume command
 *
 *  @param volume      0~100
 *  @param result
    statuscode: status code
 */
- (void)sendVolume:(float)volume result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Set progress command
 *
 *  @param progress    time in second
 *  @param result
    statuscode: status code
 */
- (void)sendProgress:(NSTimeInterval)progress result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Set sound channel command
 *
 *  @param channel     see WiimuBoxChannel
 *  @param result
    statuscode: status code
 */
- (void)sendChangeChannel:(WiimuBoxChannel)channel result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Set equalizer command
 *
 *  @param desiredEqualizer     see WiimuEqualizer
 *  @param result
 *  statuscode: status code
 */
- (void)SetEqualizer:(WiimuEqualizer)desiredEqualizer result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Set play uri command.
 *
 *  @param uri   media's uri.
 *  @param meta  media's metadata.
    @param result
 *  statuscode: status code
 */
- (void)playURI:(NSString *)uri metadata:(NSString *)meta result:(WiimuSDKReturnBlock)resultBlock;

#pragma mark - Get Info
/**
 *  Get play state
 *
 *  @return
    statuscode: status code
    OutCurrentTransportState: current play state
 */
- (void)GetPlayState:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get some media info
 *
 *  @return
    statuscode: status code
    OutTrackDuration: media total length
    OutRelTime: media current play length
    OutTrackMetaData: media metadata
    TrackURI: media uri
 */
- (void)GetPositionInfo:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get volume
 *
 *  @return
    statuscode: status code
    OutCurrentVolume: current volume
 */
- (void)GetVolume:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get sound channel
 *
 *  @return
    statuscode: status code
    OutCurrentChannel: device's sound channel
 */
- (void)GetSoundChannel:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get media info
 *
 *  @return
    statuscode: status code
    OutMediaDuration: media total length
    OutCurrentURI: media uri
    OutCurrentURIMetaData: metadata
    OutPlayMedium: media type
    OutTrackSource: media source
 */
- (void)GetMediaInfo:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get a combination of device's info,
 *  contains GetPlayState, GetPositionInfo, GetPositionInfo and so on.
 *
 *  @return
     statuscode: status code
     OutCurrentTransportState: current play state
     OutTrackDuration: media total length
     OutRelTime: media current play length
     OutTrackMetaData: media metadata
     OutCurrentVolume: current volume
     LoopMode: current play queue's loop mode
     SlaveList: current device's slave list
     TrackSource: current queue's source
     PlayMedium: current media type
     TrackURI: media uri
 */
- (void)GetInfoEx:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get device's info
 *
 *  @return
     statuscode: status code
     MultiType: master or slave device
     Router: connected router
     SlaveMask: if device is slave, mask or not
     SlaveList: device's slave list
     ssid: device's ssid
     status: device's info, in json
     volume: device's volume
     mute: device mute or not
     channel: device's sound channel
 */
- (void)GetControlDeviceInfo:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get equalizer command
 *
 *  @param result
 *  statuscode: status code
    CurrentEqualizer: see WiimuEqualizer
 */
- (void)GetEqualizer:(WiimuSDKReturnBlock)resultBlock;


#pragma mark - Queue
/**
 *  Get queue info.
 *
 *  @param QueueName Queue's name
        default queue name:
 *      TotalQueue Get all exist queues' info.
 *      CurrentQueue Get current playing queue's info.
 *      USBDiskQueue Get USB queue's info.
    @return
        statuscode: status code
        QueueContext queue's info
        CurrentIndex Current played music's index(except TotalQueue)
 */
-(void)BrowseQueue:(NSString *)QueueName result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Create a queue in SDRAM.
 *
 *  @param QueueContext Queue context of the new queue
    @return
        statuscode: status code
 */
-(void)CreateQueue:(NSString *)QueueContext result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Delete a queue.
 *
 *  @param QueueName   queue's name.
    @return
        statuscode: status code
 */
-(void)DeleteQueue:(NSString *)QueueName result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Play a queue.
 *
 *  @param QueueName   queue's name.
 *  @param Index       play index, begin from 1.
    @return
        statuscode: status code
 */
-(void)PlayQueueWithIndex:(NSString *)QueueName index:(int)Index result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Replace a queue.
 *
 *  @param QueueContext Queue context of the new queue.
 *  @return
        statuscode: status code
 */
-(void)ReplaceQueue:(NSString *)QueueContext result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Set a queue's loop mode.
 *
 *  @param LoopMode    See WiimuQueueLoopMode
 *  @return
        statuscode: status code
 */
-(void)SetQueueLoopMode:(WiimuQueueLoopMode)LoopMode result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get a queue's loop mode.
 *
 *  @return
        statuscode: status code
        LoopMode: see WiimuQueueLoopMode
 */
-(void)GetQueueLoopMode:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Back up a queue in device's flash.
 *
 *  @param QueueContext Queue context of the new queue.
 *  @return
        statuscode: status code
 */
-(void)BackUpQueue:(NSString *)QueueContext result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Append musics to queue's end.
 *
 *  @param QueueContext The info you want to append.
 *  @return
        statuscode: status code
 */
-(void)AppendTracksInQueue:(NSString *)QueueContext result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Append musics to queue's top or end.
 *
 *  @param QueueContext The info you want to append.
 *  @param Direction    0 top 1 end
    @param StartIndex   begin with 1, if Direction == 1 & (StartIndex >= 1 & StartIndex <= queue.len), then this value is legal.
 *  @return
        statuscode: status code
 */
-(void)AppendTracksInQueue:(NSString *)QueueContext direction:(NSString *)Direction index:(int)StartIndex result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Remove musics from queue.
 *
 *  @param QueueName Queue's name
    @param RangeStart Begin index, from 1.
    @param RangeEnd End index
 *  @return
        statuscode: status code
 */
-(void)RemoveTracksInQueue:(NSString *)QueueName from:(int)RangeStart to:(int)RangeEnd result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Preset music to device.
 *
 *  @param QueueContext Preset XML
 *  @return
        statuscode: status code
 */
-(void)Preset:(NSString *)QueueContext result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get preset XML.
 *
 *  @return
        statuscode: status code
        QueueContext: preset info XML
 */
-(void)GetPresetInfo:(WiimuSDKReturnBlock)resultBlock;

/**
 *  SET SPOTYIF
 *
 *  @param KeyIndex: index of preset key
 *  @param result
 statuscode: status code
 spotifyPresetName:spotify Preset Name
 */
- (void)SetSpotifyPreset:(int)keyIndex result:(WiimuSDKReturnBlock)resultBlock;

@end

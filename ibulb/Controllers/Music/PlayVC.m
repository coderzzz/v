//
//  PlayVC.m
//  ibulb
//
//  Created by Interest on 2016/11/16.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "PlayVC.h"
#import "GlobalInfo.h"
#import "DDXML.h"
#import "WiimuUPnP.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "DDXMLElementAdditions.h"
#import "NowVC.h"
#import "ArtWorkModel.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
@interface PlayVC ()<WiimuUPnPObserver>
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UISlider *timeProgress;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UISlider *volumeProgress;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *randomBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UIButton *prevBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation PlayVC
{
    NSString *radioUrl;
    NSString *radioName;
    NSString *radioImageUrl;
    NSTimeInterval allsec;
    dispatch_source_t timer;
    NSMutableArray *artworks;
    
    NSString *myproperty;
    NSString *myname;
    
    BOOL home;
    
    __block CGFloat begin;
    
    NSString *myqueue;
    int myindex;
    
    NSDictionary *radioModel;
    
    
}
- (id)initWithMPMediaItemProperty:(NSString *)property name:(NSString *)name{
    
    self = [super init];
    if (self) {
        
        myproperty = property;
        myname = name;
    }

    return self;
    
}
- (id)initWithPlayQueue:(NSString *)queueName playIndex:(int)index{
    
    self = [super init];
    if (self) {
        
        myqueue = queueName;
        myindex = index;
    }
    return self;
    
}
- (id)initWithRadioModel:(NSDictionary *)model{
    
    self = [super init];
    if (self) {
        
        radioModel = model;
    }
    return self;
}
- (id)initWithHome:(BOOL)ishome{
    
    self = [super init];
    if (self) {
        
        home = ishome;
    }
    return self;
}

- (void)updateUI{
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) GetInfoEx:^(NSDictionary *result) {
        if([result[@"statuscode"] intValue] != 0)
        {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //play state
//            self.playBtn.selected = ![result[@"OutCurrentTransportState"] isEqualToString:@"PLAYING"];

            //progress
            NSString *type = result[@"PlayMedium"];
            if ([type hasPrefix:@"RADIO"]) {
                
                self.timeProgress.userInteractionEnabled = NO;
            }
            
            
            if([self secondFromTimeString:result[@"OutTrackDuration"]] != 0 && home)
            {
                if (timer) dispatch_source_cancel(timer);
                __block NSTimeInterval nowsec = [self secondFromTimeString:result[@"OutTrackDuration"]];
                if (allsec != nowsec) {
                    
                    
                    __block CGFloat begin = (CGFloat)[self secondFromTimeString:result[@"OutRelTime"]];
                    
                    self.timeProgress.maximumValue = (CGFloat)nowsec;
                    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
                    dispatch_source_set_event_handler(timer, ^{
                        
                        
                        if ((nowsec - begin)>0) {
                            
                            begin++;
                            self.timeProgress.value = begin;
                            
                            
                        }
                        else{
                            allsec = nowsec;
                            dispatch_source_cancel(timer);
                        }
                    });
                    dispatch_source_set_cancel_handler(timer, ^{
                        
                    });
                    dispatch_resume(timer);
                    
                }
                else{
                    allsec = 0;
                    self.timeProgress.value = 0.0f;
                }
                home = NO;
                
                
//                _timeProgress.value = [self secondFromTimeString:result[@"OutRelTime"]]/[self secondFromTimeString:result[@"OutTrackDuration"]];
            }
            
            //volume
            _volumeProgress.value = [result[@"OutCurrentVolume"] floatValue];
            
        });
        
        //channel
//        [UPnPDevice(infoDic[@"uuid"]) GetSoundChannel:^(NSDictionary *result) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                boxchannel = [result[@"OutCurrentChannel"] intValue];
//                [self updateChannelButton];
//            });
//        }];
        
        //meta data
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:result[@"OutTrackMetaData"] options:0 error:nil];
        if (!xmlDoc)
        {
            return;
        }
        
        DDXMLElement *trackItem = [[xmlDoc rootElement] elementForName:@"item"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *title =[[trackItem elementForName:@"dc:title"] stringValue];
            NSString *artist =[[trackItem elementForName:@"upnp:artist"] stringValue];
            _titlelab.text = [NSString stringWithFormat:@"%@\n%@",title,artist];
            
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([NSURL URLWithString:[[trackItem elementForName:@"upnp:albumArtURI"] stringValue]] != nil)
            {
                NSString *uri =[[trackItem elementForName:@"upnp:albumArtURI"] stringValue];
  
                [self.imageV sd_setImageWithURL:[NSURL URLWithString:uri]placeholderImage:[UIImage imageNamed:@"121"]];
                

            }
         });
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"NOW PLAY", nil);
    allsec = 0;
    [[WiimuUPnP sharedInstance] addObserver:self];
    
    if (myproperty) [self layoutMPMediaItem];
    if (myqueue) [self layoutQueue];
    if (radioModel) [self layoutRadio];
    if (home) [self layoutHome];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[WiimuUPnP sharedInstance] removeObserver:self];
    if (timer) dispatch_source_cancel(timer);
}


- (void)layoutHome{
    
     [self updateUI];
}

- (void)layoutMPMediaItem{
    
    [self showHudWithString:NSLocalizedString(@"wa", nil)];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        artworks =[NSMutableArray array];
        int index = 1;
        NSMutableArray *itemsFromArtistQuery = [NSMutableArray array];
        if ([myproperty isEqualToString:@"playlist"]) {
            
            MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
            NSArray *playlists = [myPlaylistsQuery collections];
            for (MPMediaPlaylist *playlist in playlists) {
                if ([myname isEqualToString:[playlist valueForProperty: MPMediaPlaylistPropertyName]]) {
                    
                    itemsFromArtistQuery = [[playlist items]mutableCopy];
                }
            }
        }
        else if([myproperty isEqualToString:@"title"]){

            MPMediaQuery *myQuery = [[MPMediaQuery alloc] init];
            [itemsFromArtistQuery addObjectsFromArray:[myQuery items]];
            index = self.selectindex;
        }
        else{
            
            MPMediaPropertyPredicate *artistNamePredicate =[MPMediaPropertyPredicate predicateWithValue:myname forProperty:myproperty];
            MPMediaQuery *myArtistQuery = [[MPMediaQuery alloc] init];
            [myArtistQuery addFilterPredicate: artistNamePredicate];
            itemsFromArtistQuery = [[myArtistQuery items]mutableCopy];

        }
        
        NSString *queuecontext = [NSString stringWithFormat:@"<PlayList><ListName>Test</ListName><ListInfo><SourceName></SourceName><TrackNumber>%lu</TrackNumber><SearchUrl>searchurl</SearchUrl></ListInfo><Tracks>",(unsigned long)itemsFromArtistQuery.count];
        
        for (int a=0;a<itemsFromArtistQuery.count;a++) {
            
            MPMediaItem *curItem = itemsFromArtistQuery[a];
            NSURL *url= [curItem valueForProperty:MPMediaItemPropertyAssetURL];
            NSString *fileName = [self getFileNameWithMediaItem:curItem];
            NSArray *paths= NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *exportFile = [[paths firstObject] stringByAppendingPathComponent:fileName];
            NSString *trackStr = [self makeTrackStringWihtMediaItem:curItem fileName:fileName index:a];
            queuecontext = [queuecontext stringByAppendingString:trackStr];
            if (![[NSFileManager defaultManager]fileExistsAtPath:exportFile]) {
                
                AVURLAsset *songAsset= [AVURLAsset URLAssetWithURL:url options:nil];
                //init export, here you must set "presentName" argument to "AVAssetExportPresetPassthrough". If not, you will can't export mp3 correct.
                AVAssetExportSession *mExporter= [[AVAssetExportSession alloc] initWithAsset:songAsset presetName:AVAssetExportPresetAppleM4A];
                mExporter.outputFileType = AVFileTypeAppleM4A;
                NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
                mExporter.outputURL = exportURL;
                dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
                [mExporter exportAsynchronouslyWithCompletionHandler:^{
                    
                    int exportStatus = mExporter.status;
                    switch (exportStatus)
                    {
                        case AVAssetExportSessionStatusFailed:
                        {
                            // log error to text view
                            NSError *exportError = mExporter.error;
                            NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                            break;
                        }
                        case AVAssetExportSessionStatusCompleted:
                        {
                            NSLog (@"AVAssetExportSessionStatusCompleted");
                            
                            break;
                        }
                        case AVAssetExportSessionStatusUnknown:
                        {
                            NSLog (@"AVAssetExportSessionStatusUnknown");
                            break;
                        }
                        case AVAssetExportSessionStatusExporting:
                        {
                            NSLog (@"AVAssetExportSessionStatusExporting");
                            break;
                        }
                        case AVAssetExportSessionStatusCancelled:
                        {
                            NSLog (@"AVAssetExportSessionStatusCancelled");
                            break;
                        }
                        case AVAssetExportSessionStatusWaiting:
                        {
                            NSLog (@"AVAssetExportSessionStatusWaiting");
                            break;
                        }
                        default:
                        {
                            NSLog (@"didn't get export status");
                            break;
                        }
                    }
                    dispatch_semaphore_signal(wait);
                    
                }];
                long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
                if (timeout) {
                    NSLog(@"timeout.");
                }
                if (wait) {
                    //dispatch_release(wait);
                    wait = nil;
                }
            }
        }
        [self hideHud];
        queuecontext = [queuecontext stringByAppendingString:@"</Tracks></PlayList>"];
        NSLog(@"queuecontext =%@",queuecontext);
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infoDic = [delegate.devices firstObject];
        [UPnPDevice(infoDic[@"uuid"]) CreateQueue:queuecontext result:^(NSDictionary *result) {
            if([result[@"statuscode"] intValue]!= 0)
            {
                return;
            }
            
            [UPnPDevice(infoDic[@"uuid"]) PlayQueueWithIndex:@"Test" index:index result:^(NSDictionary *result) {
                
                [self updateUI];
            }];
        }];

        
    });
    
}

- (void)layoutQueue{
    
    [self showHudWithString:NSLocalizedString(@"wa", nil)];
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) PlayQueueWithIndex:myqueue index:myindex result:^(NSDictionary *result) {
        
        [self hideHud];
        if([result[@"statuscode"] intValue] == 0)
        {
            NSLog(@"play success");
            [self updateUI];
        }
    }];
}

- (void)layoutRadio{
    
    self.timeProgress.userInteractionEnabled = NO;
    self.randomBtn.selected = YES;
    self.randomBtn.userInteractionEnabled = NO;
    self.orderBtn.selected = YES;
    self.orderBtn.userInteractionEnabled = NO;
    self.prevBtn.selected = YES;
    self.prevBtn.userInteractionEnabled = NO;
    self.nextBtn.selected = YES;
    self.nextBtn.userInteractionEnabled = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"45"] style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self showHudWithString:NSLocalizedString(@"wa", nil)];
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    NSString *url = radioModel[@"URL"];
    NSArray *ary = [url componentsSeparatedByString:@"&"];
    NSString *first = [NSString stringWithFormat:@"%@&amp;",ary[0]];
    radioUrl = [NSString stringWithFormat:@"%@%@",first,ary[1]];
    radioName = radioModel[@"text"];
    radioImageUrl = radioModel[@"image"];
    NSString * queuecontext = [NSString stringWithFormat:@"<PlayList><ListName>Radio</ListName><ListInfo><SourceName></SourceName><TrackNumber>1</TrackNumber><SearchUrl>searchurl</SearchUrl><Radio>1</Radio></ListInfo><Tracks><Track1><URL>%@</URL><Source></Source><Metadata>&lt;?xml version=\"1.0\" encoding=\"UTF-8\"?&gt;&lt;DIDL-Lite xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:upnp=\"urn:schemas-upnp-org:metadata-1-0/upnp/\" xmlns:song=\"www.wiimu.com/song/\" xmlns:custom=\"www.wiimu.com/custom/\" xmlns=\"urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/\"&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;item&gt;&lt;dc:title&gt;%@&lt;/dc:title&gt;&lt;upnp:artist&gt;%@&lt;/upnp:artist&gt;&lt;upnp:album&gt;%@&lt;/upnp:album&gt;&lt;upnp:albumArtURI&gt;%@&lt;/upnp:albumArtURI&gt;&lt;custom:url&gt;%@&lt;/custom:url&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</Metadata></Track1></Tracks></PlayList>",radioUrl,radioModel[@"text"],radioModel[@"subtext"],@"专辑",radioModel[@"image"],@"url"];
    
    NSLog(@"queuecontext =%@",queuecontext);
    [UPnPDevice(infoDic[@"uuid"]) CreateQueue:queuecontext result:^(NSDictionary *result) {
        
        
        [self hideHud];
        if([result[@"statuscode"] intValue] != 0)
        {
            NSLog(@"播放失败");
            return;
        }
        
        [UPnPDevice(infoDic[@"uuid"]) PlayQueueWithIndex:@"Radio" index:1 result:^(NSDictionary *result) {
            
            [self updateUI];
            
            
        }];
    }];
}

- (void)dealloc{
    
}
#pragma mark - WiimuUPnPObserver methods
- (void)UPnPDeviceEvent:(id<WiimuDeviceProtocol>)device event:(NSString *)event
{
//    NSLog(@"%@",event);
    [self updateUI];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSArray *temp = [event componentsSeparatedByString:@"<"];
        for (NSString *str in temp) {
            
            if ([str hasPrefix:@"CurrentMediaDuration"]) {
                if (timer) dispatch_source_cancel(timer);
                NSLog(@"%@",str);
                NSString *timestr = [str substringWithRange:NSMakeRange(26, 8)];
                NSLog(@"%@",timestr);
                __block NSTimeInterval nowsec = [self secondFromTimeString:timestr];
                if (allsec != nowsec) {
                    

                    begin = 0.f;
                    
                    self.timeProgress.maximumValue = (CGFloat)nowsec;
                    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
                    dispatch_source_set_event_handler(timer, ^{
                        
                        
                        if ((nowsec - begin)>0) {
                            
                            begin++;
                            self.timeProgress.value = begin;
                          
                            
                        }
                        else{
                            allsec = nowsec;
                            dispatch_source_cancel(timer);
                        }
                    });
                    dispatch_source_set_cancel_handler(timer, ^{
                        
                    });
                    dispatch_resume(timer);

                }
                else{
                    allsec = 0;
                    self.timeProgress.value = 0.0f;
                    
                }
            }
            if ([str hasPrefix:@"CurrentTrackMetaData"]) {
                
//                [self updateUI];
//                NSString *metaData = [str substringWithRange:NSMakeRange(26, str.length-28)];
//                NSLog(@"metaData = %@",metaData);
//                DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:metaData options:0 error:nil];
//                if (!xmlDoc)
//                {
//                    return;
//                }
//                DDXMLElement *trackItem = [[xmlDoc rootElement] elementForName:@"item"];
//                NSString *title =[[trackItem elementForName:@"dc:title"] stringValue];
//                NSString *artist =[[trackItem elementForName:@"upnp:artist"] stringValue];
//                _titlelab.text = [NSString stringWithFormat:@"%@\n%@",title,artist];
//                NSLog(@"%@",_titlelab.text);

            }
        }
    });
}
#pragma mark privacy
- (NSString *)makeQueueContextWithTracks{
    
    NSString *queuecontext = @"<PlayList><ListName>Test</ListName><ListInfo><SourceName></SourceName><TrackNumber>2</TrackNumber><SearchUrl>searchurl</SearchUrl></ListInfo><Tracks></Tracks></PlayList>";
    return queuecontext;
}
- (NSString *)getFileNameWithMediaItem:(MPMediaItem *)item{
    
    NSURL *url= [item valueForProperty:MPMediaItemPropertyAssetURL];
    NSString *fileName= [NSString stringWithFormat:@"%@.m4a",[[url.absoluteString componentsSeparatedByString:@"="] lastObject]];
    return fileName;
}
- (NSString *)makeTrackStringWihtMediaItem:(MPMediaItem *)item fileName:(NSString *)fileName index:(int)a{

//
    MPMediaItemArtwork *work =[item valueForProperty: MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [work imageWithSize: _imageV.bounds.size];
    
    NSString *imgurl = [NSString stringWithFormat:@"http://%@:%d/%@_artwork",[GlobalInfo sharedInstance].httpServerIP,[GlobalInfo sharedInstance].httpServerPort,fileName];
    
    [[SDWebImageManager sharedManager]saveImageToCache:artworkImage forURL:[NSURL URLWithString:imgurl]];
    
    ArtWorkModel *model = [[ArtWorkModel alloc]init];
    if (artworkImage) {
        model.file = imgurl;
        model.artworkImage = artworkImage;
        [artworks addObject:model];
    }
    NSString *trackStr = [NSString stringWithFormat:@"<Track%d><URL>http://%@:%d/%@</URL><Source></Source><Metadata>&lt;?xml version=\"1.0\" encoding=\"UTF-8\"?&gt;&lt;DIDL-Lite xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:=\"urn:schemas-upnp-org:metadata-1-0/upnp/\" xmlns:song=\"www.wiimu.com/song/\" xmlns:custom=\"www.wiimu.com/custom/\" xmlns=\"urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/\"&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;item&gt;&lt;dc:title&gt;%@&lt;/dc:title&gt;&lt;upnp:artist&gt;%@&lt;/upnp:artist&gt;&lt;upnp:album&gt;%@&lt;/upnp:album&gt;&lt;custom:url&gt;http://%@:%d/%@&lt;/custom:url&gt;&lt;upnp:albumArtURI&gt;%@&lt;/upnp:albumArtURI&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</Metadata></Track%d>",a+1,[GlobalInfo sharedInstance].httpServerIP,[GlobalInfo sharedInstance].httpServerPort,fileName,item.title,item.artist,[item.albumTitle stringByReplacingOccurrencesOfString:@"&" withString:@""],[GlobalInfo sharedInstance].httpServerIP,[GlobalInfo sharedInstance].httpServerPort,fileName,imgurl,a+1];
    return trackStr;
}
- (NSTimeInterval)secondFromTimeString:(NSString *)timeString
{
    NSTimeInterval seconds = 0;
    NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
    
    if([timeArray count] != 3)
    {
        return 0;
    }
    
    int hour = [timeArray[0] intValue];
    int min = [timeArray[1] intValue];
    int sec = [timeArray[2] intValue];
    
    seconds+=hour*3600+min*60+sec;
    
    return seconds;
}
#pragma mark action
- (void)more{
    
    NowVC *vc = [[NowVC alloc]initWithRadioName:radioName radioUrl:radioUrl picUrl:radioImageUrl];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)randomAction:(UIButton *)sender {
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) SetQueueLoopMode:wiimu_queue_shuffle result:^(NSDictionary *result) {
        
    }];
}
- (IBAction)changeTime:(UISlider *)sender {
    
  
    [self showHudWithString:NSLocalizedString(@"wa", nil)];
    if (timer) dispatch_suspend(timer);
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) sendProgress:sender.value result:^(NSDictionary *result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideHud];
//            if([result[@"statuscode"] intValue]!= 0)
//            {
//                if (timer) dispatch_resume(timer);
//                return;
//            }
            begin = sender.value;
            if (timer) dispatch_resume(timer);

        });
        
    }];
}

- (IBAction)changeVolumeAction:(UISlider *)sender {
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) sendVolume:sender.value result:^(NSDictionary *result) {
        
    }];
}
- (IBAction)orderAction:(id)sender {
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) SetQueueLoopMode:wiimu_queue_listrepeat result:^(NSDictionary *result) {
        
    
    }];
}
- (IBAction)prevAction:(id)sender {
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    if (timer) dispatch_source_cancel(timer);
    [UPnPDevice(infoDic[@"uuid"]) sendPlayPrev:^(NSDictionary *result) {
        
         NSLog(@"sendPlayPrev = %@",result);
        if([result[@"statuscode"] intValue] != 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
//                [self showHudWithString:@"操作失败"];
            });
            return;
        }
       
    }];
}
- (IBAction)nextAction:(id)sender {
    

    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    if (timer) dispatch_source_cancel(timer);
    [UPnPDevice(infoDic[@"uuid"]) sendPlayNext:^(NSDictionary *result) {
        
        NSLog(@"sendPlaynext = %@",result);
        if([result[@"statuscode"] intValue] != 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
               
//                [self showHudWithString:@"操作失败"];
            });
            return;
        }
    }];
}
- (IBAction)playAction:(UIButton *)sender {
    
    if(sender.isSelected)
    {
      
     AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infoDic = [delegate.devices firstObject];
        [UPnPDevice(infoDic[@"uuid"]) sendPlay:^(NSDictionary *result) {
            
           if (timer)  dispatch_resume(timer);
        }];
    }
    else
    {
     
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infoDic = [delegate.devices firstObject];
        [UPnPDevice(infoDic[@"uuid"]) sendPause:^(NSDictionary *result) {
            
            if (timer) dispatch_suspend(timer);
        }];
    }
    sender.selected = !sender.isSelected;
}
@end

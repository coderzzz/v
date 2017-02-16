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
    
}
- (id)initWithMPMediaItemProperty:(NSString *)property name:(NSString *)name{
    
    self = [super init];
    if (self) {
        
        artworks =[NSMutableArray array];
        NSArray *itemsFromArtistQuery;
        if ([property isEqualToString:@"playlist"]) {
            
            MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
            NSArray *playlists = [myPlaylistsQuery collections];
            for (MPMediaPlaylist *playlist in playlists) {
                if ([name isEqualToString:[playlist valueForProperty: MPMediaPlaylistPropertyName]]) {
                    
                    itemsFromArtistQuery = [playlist items];
                }
            }
        }
        else{

            MPMediaPropertyPredicate *artistNamePredicate =[MPMediaPropertyPredicate predicateWithValue:name forProperty:property];
            MPMediaQuery *myArtistQuery = [[MPMediaQuery alloc] init];
            [myArtistQuery addFilterPredicate: artistNamePredicate];
            itemsFromArtistQuery = [myArtistQuery items];
        }
    
        NSString *queuecontext = [NSString stringWithFormat:@"<PlayList><ListName>Test</ListName><ListInfo><SourceName></SourceName><TrackNumber>%lu</TrackNumber><SearchUrl>searchurl</SearchUrl></ListInfo><Tracks>",(unsigned long)itemsFromArtistQuery.count];
        [self showHud];
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
            
            [UPnPDevice(infoDic[@"uuid"]) PlayQueueWithIndex:@"Test" index:1 result:^(NSDictionary *result) {
                
                [self updateUI];
            }];
        }];
    }

    return self;
    
}
- (id)initWithPlayQueue:(NSString *)queueName playIndex:(int)index{
    
    self = [super init];
    if (self) {
        
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infoDic = [delegate.devices firstObject];
        [UPnPDevice(infoDic[@"uuid"]) PlayQueueWithIndex:queueName index:index result:^(NSDictionary *result) {
            if([result[@"statuscode"] intValue] == 0)
            {
                NSLog(@"play success");
                [self updateUI];
            }
        }];
    }
    return self;
    
}
- (id)initWithRadioModel:(NSDictionary *)model{
    
    self = [super init];
    if (self) {
        
     
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infoDic = [delegate.devices firstObject];
        NSString *url = model[@"URL"];
        NSArray *ary = [url componentsSeparatedByString:@"&"];
        NSString *first = [NSString stringWithFormat:@"%@&amp;",ary[0]];
        radioUrl = [NSString stringWithFormat:@"%@%@",first,ary[1]];
        radioName = model[@"text"];
        radioImageUrl = model[@"image"];
        NSString * queuecontext = [NSString stringWithFormat:@"<PlayList><ListName>Radio</ListName><ListInfo><SourceName></SourceName><TrackNumber>1</TrackNumber><SearchUrl>searchurl</SearchUrl><Radio>1</Radio></ListInfo><Tracks><Track1><URL>%@</URL><Source></Source><Metadata>&lt;?xml version=\"1.0\" encoding=\"UTF-8\"?&gt;&lt;DIDL-Lite xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:upnp=\"urn:schemas-upnp-org:metadata-1-0/upnp/\" xmlns:song=\"www.wiimu.com/song/\" xmlns:custom=\"www.wiimu.com/custom/\" xmlns=\"urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/\"&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;item&gt;&lt;dc:title&gt;%@&lt;/dc:title&gt;&lt;upnp:artist&gt;%@&lt;/upnp:artist&gt;&lt;upnp:album&gt;%@&lt;/upnp:album&gt;&lt;upnp:albumArtURI&gt;%@&lt;/upnp:albumArtURI&gt;&lt;custom:url&gt;%@&lt;/custom:url&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</Metadata></Track1></Tracks></PlayList>",radioUrl,model[@"text"],model[@"subtext"],@"专辑",model[@"image"],@"url"];
        
        NSLog(@"queuecontext =%@",queuecontext);
        [UPnPDevice(infoDic[@"uuid"]) CreateQueue:queuecontext result:^(NSDictionary *result) {
            
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
            if([self secondFromTimeString:result[@"OutTrackDuration"]] != 0)
            {
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
                if ([uri containsString:@"_artwork"]) {
                    
                    for (ArtWorkModel *model in artworks) {
                        
                        if ([model.file isEqualToString:uri]) {
                            
                            self.imageV.image = model.artworkImage;
                        }
                    }
                    
                }
                else{
                    
                    [self.imageV sd_setImageWithURL:[NSURL URLWithString:uri]placeholderImage:[UIImage imageNamed:@"121"]];
                }

            }
         });
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (radioUrl.length>0) {
        
        self.timeProgress.hidden = YES;
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
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"NOW PLAY", nil);
    allsec = 0;
    [[WiimuUPnP sharedInstance] addObserver:self];
}
- (void)dealloc{
    
    [[WiimuUPnP sharedInstance] removeObserver:self];
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
                    

                    __block CGFloat begin = 0.f;
                    
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
- (IBAction)changeTimeAction:(UISlider *)sender {
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) sendProgress:sender.value result:^(NSDictionary *result) {
        
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
            
            dispatch_resume(timer);
        }];
    }
    else
    {
     
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infoDic = [delegate.devices firstObject];
        [UPnPDevice(infoDic[@"uuid"]) sendPause:^(NSDictionary *result) {
            
            dispatch_suspend(timer);
        }];
    }
    sender.selected = !sender.isSelected;
}
@end

//
//  RadioVC.m
//  ibulb
//
//  Created by Interest on 2016/10/28.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "RadioVC.h"
#import "EditVC.h"
#import "WiimuUPnP.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
@interface RadioVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UISlider *volumeProgress;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIPageControl *pagec;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIImageView *imgv2;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UISlider *volume2;
@property (weak, nonatomic) IBOutlet UIButton *palybtn2;
@property (weak, nonatomic) IBOutlet UIImageView *imgv3;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UISlider *volume3;
@property (weak, nonatomic) IBOutlet UIButton *palybtn3;
@end

@implementation RadioVC
{
    NSMutableArray *keyList;
    NSMutableArray *images;
    NSMutableArray *titls;
    NSMutableArray *btns;
    NSMutableArray *progess;
    int currentPlayIndex;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadPreset];
//    [self updateUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"45"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(more)];
    self.navigationItem.rightBarButtonItem = item;
    if (self.view.bounds.size.height<450) {
        
        self.scrollview.contentSize = CGSizeMake(ScreenWidth * 3, 450);
        self.view1.frame = CGRectMake(0, 0, ScreenWidth, 450);
        [self.scrollview addSubview:self.view1];
        
        self.view2.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, 450);
        [self.scrollview addSubview:self.view2];
        
        self.view3.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, 450);
        [self.scrollview addSubview:self.view3];
        
    }
    else{
        
        self.scrollview.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight -64 - 49);
        self.view1.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight -64 - 49);
        [self.scrollview addSubview:self.view1];
        
        self.view2.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight -64 - 49);
        [self.scrollview addSubview:self.view2];
        
        self.view3.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight -64 - 49);
        [self.scrollview addSubview:self.view3];
    }
    self.pagec.frame = CGRectMake((ScreenWidth - 100)/2, ScreenHeight - 64 - 49 - 37, 100, 37);
    [self.view addSubview:self.pagec];
    progess =[@[_volumeProgress,_volume2,_volume3]mutableCopy];
    btns = [@[_playBtn,_palybtn2,_palybtn3]mutableCopy];
    images = [@[_imageV,_imgv2,_imgv3]mutableCopy];
    titls = [@[_titlelab,_title2,_title3]mutableCopy];
}

- (void)loadPreset{
    
    keyList = [NSMutableArray array];
    currentPlayIndex = -1;
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) GetPresetInfo:^(NSDictionary *result) {
        
        
        if([result[@"statuscode"] intValue] != 0)
        {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:result[@"QueueContext"] options:0 error:nil];
            if(xmlDoc == nil)
            {
                NSLog(@"error parse");
                return;
            }
            for (int a = 0; a<3; a++) {
                
                NSString *radioName = [[[xmlDoc nodesForXPath:[NSString stringWithFormat:@"KeyList/Key%d/Name",a] error:nil] firstObject] stringValue];
                NSString *url = [[[xmlDoc nodesForXPath:[NSString stringWithFormat:@"KeyList/Key%d/Url",a] error:nil] firstObject] stringValue];
                NSString *radioUrl =[url stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
//                NSArray *ary = [url componentsSeparatedByString:@"&"];
//                NSString *first = [NSString stringWithFormat:@"%@&amp;",ary[0]];
//                NSString *radioUrl = [NSString stringWithFormat:@"%@%@",first,ary[1]];
                NSString *image = [[[xmlDoc nodesForXPath:[NSString stringWithFormat:@"KeyList/Key%d/PicUrl",a] error:nil] firstObject] stringValue];
                if (!image) {
                    image = @"";
                }
                if (!(radioName.length>0)) {
                    radioName = @"";
                    [keyList addObject:@[@"",@"",@""]];
                }
                else{
                    
                    [keyList addObject:@[radioName,radioUrl,image]];
                }
                UIImageView *imagv = images[a];
                [imagv sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"121"]];
                UILabel *titlelab = titls[a];
                titlelab.text = radioName;
 
            }
            [self updateUI];
        });
    }];
}
- (IBAction)changeVolumeAction:(UISlider *)sender {
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    if (sender.tag == currentPlayIndex) {
        
        
        [UPnPDevice(infoDic[@"uuid"]) sendVolume:sender.value result:^(NSDictionary *result) {
            
        }];
    }
    
}
- (IBAction)playaction:(UIButton *)sender {
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    if (sender.tag == currentPlayIndex) {
        
        if (sender.selected) {
            
            [UPnPDevice(infoDic[@"uuid"]) sendStop:^(NSDictionary *result) {
                
            }];
        }
        else{
            
            [UPnPDevice(infoDic[@"uuid"]) sendPlay:^(NSDictionary *result) {
                
            }];
            
        }
        sender.selected = !sender.selected;
    }else{
        
        NSArray *ary = keyList[sender.tag];
        NSString*name = [ary firstObject];
        if (!(name.length>0)) return;
        NSString *radioUrl = ary[1];
        NSString *imageurl = [ary lastObject];
        NSString * queuecontext = [NSString stringWithFormat:@"<PlayList><ListName>Radio</ListName><ListInfo><SourceName></SourceName><TrackNumber>1</TrackNumber><SearchUrl>searchurl</SearchUrl><Radio>1</Radio></ListInfo><Tracks><Track1><URL>%@</URL><Source></Source><Metadata>&lt;?xml version=\"1.0\" encoding=\"UTF-8\"?&gt;&lt;DIDL-Lite xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:upnp=\"urn:schemas-upnp-org:metadata-1-0/upnp/\" xmlns:song=\"www.wiimu.com/song/\" xmlns:custom=\"www.wiimu.com/custom/\" xmlns=\"urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/\"&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;item&gt;&lt;dc:title&gt;%@&lt;/dc:title&gt;&lt;upnp:artist&gt;%@&lt;/upnp:artist&gt;&lt;upnp:album&gt;%@&lt;/upnp:album&gt;&lt;upnp:albumArtURI&gt;%@&lt;/upnp:albumArtURI&gt;&lt;custom:url&gt;%@&lt;/custom:url&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</Metadata></Track1></Tracks></PlayList>",radioUrl,name,name,@"专辑",imageurl,@"url"];
        [UPnPDevice(infoDic[@"uuid"]) CreateQueue:queuecontext result:^(NSDictionary *result) {
            
            if([result[@"statuscode"] intValue] != 0)
            {
                NSLog(@"创建列表失败");
                return;
            }
            
            [UPnPDevice(infoDic[@"uuid"]) PlayQueueWithIndex:@"Radio" index:1 result:^(NSDictionary *result) {
                
                
                NSLog(@"播放成功");
                
           
                         
                [self updateUI];
                sender.selected = YES;
              
                
            }];
        }];
    }
}
- (void)updateUI{
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) GetInfoEx:^(NSDictionary *result) {
        if([result[@"statuscode"] intValue] != 0)
        {
            return;
        }
        if(![result[@"PlayMedium"] hasPrefix:@"RADIO"])
        {
            return;
        }
        NSLog(@"GetInfoEx =%@",result);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *url =result[@"TrackURI"];
            for (int a = 0; a<keyList.count; a++) {
                
                NSArray *ary = keyList[a];
                NSString *radiourl = [ary[1] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                if ([radiourl isEqualToString:url]) {
                    
                    currentPlayIndex = a;
                    [self.scrollview setContentOffset:CGPointMake(ScreenWidth * a, 0) animated:NO];
                    //play state
                    UIButton *btn = btns[a];
                    btn.selected = ![result[@"OutCurrentTransportState"] isEqualToString:@"STOPPED"];
                    
                    //volume
                    UISlider *slider = progess[a];
                    slider.value = [result[@"OutCurrentVolume"] floatValue];
                }else{
                    UIButton *btn = btns[a];
                    btn.selected = NO;
                }
                
            }
            
        });

//        //meta data
//        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:result[@"OutTrackMetaData"] options:0 error:nil];
//        if (!xmlDoc)
//        {
//            return;
//        }
//        
//        DDXMLElement *trackItem = [[xmlDoc rootElement] elementForName:@"item"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSString *title =[[trackItem elementForName:@"dc:title"] stringValue];
//            NSString *artist =[[trackItem elementForName:@"upnp:artist"] stringValue];
//            _titlelab.text = [NSString stringWithFormat:@"%@\n%@",title,artist];
//            
//        });
//
    }];
    
}
- (void)more{
    
    EditVC *vc = [[EditVC alloc]init];
    vc.title = NSLocalizedString(@"EDIT PRESETS", nil);
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int a = scrollView.contentOffset.x/ScreenWidth;
    NSLog(@"scrollView %d",a);
    self.pagec.currentPage = a;
    
}
@end

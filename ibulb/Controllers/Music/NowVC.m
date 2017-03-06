//
//  NowVC.m
//  ibulb
//
//  Created by Interest on 2016/11/1.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "NowVC.h"
#import "GlobalInfo.h"
#import "DDXML.h"
#import "WiimuUPnP.h"
#import "AppDelegate.h"
#import "DDXMLElementAdditions.h"
@interface NowVC ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UILabel *slab;
@property (weak, nonatomic) IBOutlet UILabel *olab;



@end

@implementation NowVC
{
    NSString *currentName;
    NSString *currentUrl;
    NSString *currentPicUrl;
    NSString *currentIndex;
    NSArray  *btnList;
    NSMutableArray *keyList;
}

- (id)initWithRadioName:(NSString *)name radioUrl:(NSString *)url picUrl:(NSString *)picUrl{
    
    self = [super init];
    if (self) {
        
        currentName = name;
        currentUrl = url;
        currentPicUrl = picUrl;

        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Now Play", nil);
    btnList = @[_btn1,_btn2,_btn3];
    
    self.slab.text = NSLocalizedString(@"Save this Radio to your", nil);
    self.olab.text = NSLocalizedString(@"one of the fav radio presets?", nil);
    
    keyList = [NSMutableArray array];
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) GetPresetInfo:^(NSDictionary *result) {
        
        NSLog(@"GetPresetInfo =%@",result);
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
                NSString *radioUrl = [url stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
                NSString *image = [[[xmlDoc nodesForXPath:[NSString stringWithFormat:@"KeyList/Key%d/PicUrl",a] error:nil] firstObject] stringValue];
                UIButton *btn = btnList[a];
                if (!(radioName.length>0)) {
                    radioName = @"";
                    [keyList addObject:radioName];
                }
                else{
                    
                    NSString *keystr = [self makeKeyStrWithName:radioName url:radioUrl imgUrl:image index:a];
                    [keyList addObject:keystr];
                    
                }
                [btn setTitle:[NSString stringWithFormat:@"%d %@",a,radioName] forState:UIControlStateNormal];
            }
        });
    }];
    
}
- (IBAction)btnaction:(UIButton *)sender {
    
    currentIndex = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    [self showHud];
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices firstObject];
    [UPnPDevice(infoDic[@"uuid"]) Preset:[self makeRadioContext] result:^(NSDictionary *result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self hideHud];
            if([result[@"statuscode"] intValue] != 0)
            {
                [self showHudWithString:NSLocalizedString(@"success", nil)];
                [self hideHud];
            }else{
                [self showHudWithString:NSLocalizedString(@"failure", nil)];
                [self hideHud];
                [sender setTitle:[NSString stringWithFormat:@"%ld %@",(long)sender.tag+1,currentName] forState:UIControlStateNormal];
            }
            
        });
    }];
    
}

- (NSString *)makeKeyStrWithName:(NSString *)name url:(NSString *)url imgUrl:(NSString *)imgurl index:(int)a{
    
    NSString *keyStr = [NSString stringWithFormat:@"<Key%d><Name>%@</Name><Url>%@</Url><Source>TuneIn</Source><PicUrl>%@</PicUrl><Metadata>&lt;?xml version=\"1.0\" encoding=\"UTF-8\"?&gt;&lt;DIDL-Lite xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:upnp=\"urn:schemas-upnp-org:metadata-1-0/upnp/\" xmlns:song=\"www.wiimu.com/song/\" xmlns:custom=\"www.wiimu.com/custom/\" xmlns=\"urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/\"&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;item&gt;&lt;res protocolInfo=\"http-get:*:audio/mpeg:DLNA.ORG_PN=MP3;DLNA.ORG_OP=01;\" duration=""&gt;%@&lt;/res&gt;&lt;dc:title&gt;%@&lt;/dc:title&gt;&lt;upnp:artist&gt;tunein&lt;/upnp:artist&gt;&lt;upnp:album&gt;tunein&lt;/upnp:album&gt;&lt;upnp:albumArtURI&gt;%@&lt;/upnp:albumArtURI&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;</Metadata></Key%d>",a,name,url,imgurl,url,name,imgurl,a];
    return keyStr;
}

- (NSString *)makeRadioContext{
    
    NSString *context = @"<KeyList><ListName>KeyMappingQueue</ListName><MaxNumber>20</MaxNumber>";
    for (int a = 0; a<keyList.count; a++) {
        
        if ([currentIndex intValue] == a) {
            
            NSString *currentkey = [self makeKeyStrWithName:currentName url:currentUrl imgUrl:currentPicUrl index:a];
            [keyList replaceObjectAtIndex:a withObject:currentkey];
        }
        context = [context stringByAppendingString:keyList[a]];
    }
    context =[context stringByAppendingString:@"</KeyList>"];
    NSLog(@"RadioContext = %@",context);
    return context;
}


@end

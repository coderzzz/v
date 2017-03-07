//
//  LocalRadioVC.m
//  ibulb
//
//  Created by Interest on 2016/10/31.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "LocalRadioVC.h"
#import "LocaSectionView.h"
#import "LCell.h"
#import "WiimuUPnP.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "PlayVC.h"
#import "RadioVC.h"
#import "LinkView.h"
@interface LocalRadioVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation LocalRadioVC
{
    NSMutableArray *list;
    NSInteger selectIndex;
    NSMutableArray *keyList;
    NSString *currentIndex;
    NSString *currentName;
    NSString *currentUrl;
    NSString *currentPicUrl;
    NSMutableArray *titles;
    NSString *currentTitle;
    NSURL *radioUrl;

}

- (instancetype)initWithTitle:(NSString *)title radioUrl:(NSURL *)url{
    
    self = [super init];
    if (self) {
        
        currentTitle = title;
        radioUrl = url;
        
    }
    return self;
}


- (void)loaddata{
    
    self.title = currentTitle;
    list = [NSMutableArray array];
    [self showHudWithString:NSLocalizedString(@"wait", nil)];
    NSURLRequest *request = [NSURLRequest requestWithURL:radioUrl];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSData *data =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
        if (!xmlDoc)
        {
            [self showTipWithView:self.tableview action:@"loaddata"];
            return;
        }
        
        DDXMLElement *bodyElement = [[xmlDoc rootElement] elementForName:@"body"];
        NSArray *array = [bodyElement elementsForName:@"outline"];
        for(DDXMLElement * element in array)
        {
            NSDictionary *dic = [element attributesAsDictionary];
            NSArray *childrens = element.children;
            if (!(childrens.count>0)) {
                
                [list addObject:dic];
            }
            for(DDXMLElement * children in childrens)
            {
                NSDictionary *dic = [children attributesAsDictionary];
                if (dic) {
                    
                    [list addObject:dic];
                }
            }
        }
        NSLog(@"%@",list);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideHud];
            [self.tableview reloadData];
            
        });
    });
}


#pragma mark ViewLife cyle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loaddata];
    selectIndex = 999;
    UINib *nib = [UINib nibWithNibName:@"LCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"lcell"];
    [self loadPreset];
}


- (void)loadPreset{
    
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
            titles = [NSMutableArray array];
            for (int a = 0; a<3; a++) {
                
                NSString *radioName = [[[xmlDoc nodesForXPath:[NSString stringWithFormat:@"KeyList/Key%d/Name",a] error:nil] firstObject] stringValue];
                NSString *url = [[[xmlDoc nodesForXPath:[NSString stringWithFormat:@"KeyList/Key%d/Url",a] error:nil] firstObject] stringValue];
//                NSArray *ary = [url componentsSeparatedByString:@"&"];
//                NSString *first = [NSString stringWithFormat:@"%@&amp;",ary[0]];
//                NSString *radioUrl = [NSString stringWithFormat:@"%@%@",first,ary[1]];
                NSString *radioUrl = [url stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
                NSString *image = [[[xmlDoc nodesForXPath:[NSString stringWithFormat:@"KeyList/Key%d/PicUrl",a] error:nil] firstObject] stringValue];
                if (!(radioName.length>0)) {
                    radioName = @"";
                    [keyList addObject:radioName];
                }
                else{
                    
                    NSString *keystr = [self makeKeyStrWithName:radioName url:radioUrl imgUrl:image index:a];
                    [keyList addObject:keystr];
                    
                }
                [titles addObject:[NSString stringWithFormat:@"%d %@",a,radioName]];
                
            }
            [titles addObject:@"Cancle"];
            
        });
    }];
}




#pragma mark Action

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
#pragma mark Service
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == selectIndex) {
        
        return 4;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lcell"];
    if (indexPath.row<titles.count) {
        [cell.btn setTitle:titles[indexPath.row] forState:UIControlStateNormal];
    }
    return cell;
}


#pragma mark UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if (section<list.count) {
        
        NSDictionary *dic = list[section];
        NSString *type = dic[@"type"];
        if (![type isEqualToString:@"link"]) {
         
            LocaSectionView *view = [[LocaSectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
            [view.imagv sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
            view.titlelab.text = dic[@"text"];
            view.subTitlelab.text = dic[@"subtext"];
            view.tag = section;
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectiontap:)];
            [view addGestureRecognizer:tap];
            return view;
        }else{
            
            LinkView *view = [[LinkView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 46)];
            view.lab.text =dic[@"text"];
            view.tag = section;
            [view.tap addTarget:self action:@selector(sectiontap:)];
            return view;
        }

    }
    return nil;
    
}

- (void)sectiontap:(UITapGestureRecognizer *)tap{
    
    id vc = [self.navigationController.viewControllers firstObject];
    if ([vc isKindOfClass:[RadioVC class]]) {
        
        if (selectIndex == tap.view.tag) {
            
            selectIndex = 999;
            
        }else{
         
            selectIndex = tap.view.tag;
        }
        [self.tableview reloadData];
    }
    else{
        
        NSDictionary *model = list[tap.view.tag];
        if (model) {
            
            NSString *type = model[@"type"];
            if (![type isEqualToString:@"link"]) {
                
                PlayVC *vc = [[PlayVC alloc]initWithRadioModel:model];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model[@"URL"]]];
                
                currentTitle = model[@"text"];
                radioUrl = url;
//                [self loaddatawithtitle:model[@"text"] url:url];
                [self loaddata];
            }
            
            
            
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section<list.count) {
        
        NSDictionary *dic = list[section];
        NSString *type = dic[@"type"];
        if (![type isEqualToString:@"link"]) {
            
            return 70;
        }
        else{
            
            return 46;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if (indexPat.row == 3) {
        
       selectIndex = 999;
       [self.tableview reloadData];
    }else{
        
        NSDictionary *dic = list[indexPat.section];
        NSString *url = dic[@"URL"];
        NSArray *ary = [url componentsSeparatedByString:@"&"];
        NSString *first = [NSString stringWithFormat:@"%@&amp;",ary[0]];
        currentUrl = [NSString stringWithFormat:@"%@%@",first,ary[1]];
        currentName = dic[@"text"];
        currentPicUrl = dic[@"image"];
        currentIndex = [NSString stringWithFormat:@"%ld",(long)indexPat.row];
        [self showHud];
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSDictionary *infoDic = [delegate.devices firstObject];
        [UPnPDevice(infoDic[@"uuid"]) Preset:[self makeRadioContext] result:^(NSDictionary *result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideHud];
                if([result[@"statuscode"] intValue] != 0)
                {
                    NSLog(@"设置失败");
//                    [self showHudWithString:@"设置失败"];
                }else{
//                    [self showHudWithString:@"设置成功"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                
            });
        }];
    }

}
@end

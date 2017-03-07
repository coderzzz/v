//
//  UsbVC.m
//  ibulb
//
//  Created by Interest on 2016/10/31.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "UsbVC.h"
#import "WiimuUPnP.h"
#import "DDXML.h"
#import "PlayVC.h"
#import "AppDelegate.h"
@interface UsbVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation UsbVC
{
    NSMutableArray *list;
}
#pragma mark ViewLife cyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *infoDic = [delegate.devices lastObject];
    [self showHudWithString:NSLocalizedString(@"wait", nil)];
    [UPnPDevice(infoDic[@"uuid"]) BrowseQueue:@"USBDiskQueue" result:^(NSDictionary *result) {
       
      
        if ([result[@"statuscode"] intValue] < 0) {
            
            [self hideHud];
            return;
        }
        
        list = [NSMutableArray array];
        
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:result[@"QueueContext"] options:0 error:nil];
        if(xmlDoc == nil)
        {
            NSLog(@"error parse");
        }
        
        NSArray * arr = [xmlDoc nodesForXPath:@"PlayList/Tracks/*" error:nil];
        
        for(DDXMLElement * element in arr)
        {
            NSMutableDictionary * song = [NSMutableDictionary dictionary];
            
            for(DDXMLElement * child in element.children)
            {
                if([child.name isEqualToString:@"URL"])
                {
                    [song setObject:[child.stringValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]?:@"" forKey:@"URL"];
                }
                else if([child.name isEqualToString:@"Metadata"])
                {
                    [song addEntriesFromDictionary:[self parseMetadata:child.stringValue]];
                }
                else if([child.name isEqualToString:@"Source"])
                {
                    [song setObject:child.stringValue?:@"" forKey:@"Source"];
                }
            }
            
            NSString *title = song[@"title"];
            NSString *artist = song[@"artist"];
            
            if ([artist hasPrefix:@"._"] || [title hasPrefix:@"._"]) {
                
                
            }else{
                
                [list addObject:song];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [self.tableview reloadData];
        });
    }];

   
}
-(NSDictionary *)parseMetadata:(NSString *)MetaData
{
    NSMutableDictionary * returnDic = [NSMutableDictionary dictionary];
    
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:MetaData options:0 error:nil];
    DDXMLElement *root = [xmlDoc rootElement];
    
    //title
    NSString * title;
    NSArray * arr = [root nodesForXPath:@"//dc:title" error:nil];
    if([arr count]!=0)
    {
        title = [arr[0] stringValue];
    }
    
    [returnDic setObject:title?:@"" forKey:@"title"];
    
    //artist
    NSString * artist;
    arr = [root nodesForXPath:@"//upnp:artist" error:nil];
    if([arr count]!=0)
    {
        artist = [arr[0] stringValue];
    }
    
    [returnDic setObject:artist?:@"" forKey:@"artist"];
    
    //album
    NSString * album;
    arr = [root nodesForXPath:@"//upnp:album" error:nil];
    if([arr count]!=0)
    {
        album = [arr[0] stringValue];
    }
    
    [returnDic setObject:album?:@"" forKey:@"album"];
    
    //artworkurl
    NSString * artworkURL;
    arr = [root nodesForXPath:@"//upnp:albumArtURI" error:nil];
    if([arr count]!=0)
    {
        artworkURL = [arr[0] stringValue];
    }
    
    [returnDic setObject:artworkURL?:@"" forKey:@"artworkURL"];
    
    return returnDic;
}





#pragma mark Action







#pragma mark Service






#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = list[indexPath.row][@"title"];
//    cell.textLabel.minimumScaleFactor = 0.1;
//    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",list[indexPath.row][@"artist"],list[indexPath.row][@"album"]];
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayVC *vc = [[PlayVC alloc]initWithPlayQueue:@"USBDiskQueue" playIndex:(int)indexPath.row+1];
    [self.navigationController pushViewController:vc animated:YES];
 
}
@end

//
//  ArtistsVC.m
//  ibulb
//
//  Created by Interest on 2016/10/31.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "ArtistsVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PlayVC.h"
@interface ArtistsVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ArtistsVC
{
    NSMutableArray *list;
}
#pragma mark ViewLife cyle


- (void)viewDidLoad {
    [super viewDidLoad];
    list = [@[]mutableCopy];
    dispatch_async(dispatch_queue_create("query", NULL), ^{
        
        MPMediaQuery *myQuery = [[MPMediaQuery alloc] init];
        if ([self.mediaItemProperty isEqualToString:@"playlist"]) {
            
            MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
            NSArray *playlists = [myPlaylistsQuery collections];
            [list addObjectsFromArray:playlists];
            
        }
        else{
            
            NSArray *itemsFromGenericQuery = [myQuery items];
            for (MPMediaItem *item in itemsFromGenericQuery) {
                NSString *artistName = [item valueForProperty:self.mediaItemProperty];
                if (![list containsObject:artistName]) {
                    
                    if (!(artistName.length>0)) {
                        
                        artistName = @"unknow";
                    }
                    
                    [list addObject:artistName];
                }
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableview reloadData];
            
        });
    });
  
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
    if ([self.mediaItemProperty isEqualToString:@"playlist"]) {
        
        MPMediaPlaylist *playlist = list[indexPath.row];
        cell.textLabel.text =[playlist valueForProperty: MPMediaPlaylistPropertyName];
        
    }
    else{
        
        cell.textLabel.text = list[indexPath.row];
    }
    
    
    
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *name;
    if ([self.mediaItemProperty isEqualToString:@"playlist"]) {
        
        MPMediaPlaylist *playlist = list[indexPath.row];
        name =[playlist valueForProperty: MPMediaPlaylistPropertyName];
        
    }
    else{
        
        name = list[indexPath.row];
    }
    
    PlayVC *vc = [[PlayVC alloc]initWithMPMediaItemProperty:self.mediaItemProperty name:name];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

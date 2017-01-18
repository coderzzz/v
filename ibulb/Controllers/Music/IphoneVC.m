//
//  IphoneVC.m
//  ibulb
//
//  Created by Interest on 2016/10/31.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "IphoneVC.h"
#import "ArtistsVC.h"
#import <MediaPlayer/MediaPlayer.h>
@interface IphoneVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation IphoneVC
{
    NSMutableArray *list;
}
#pragma mark ViewLife cyle


- (void)viewDidLoad {
    [super viewDidLoad];
   
    list = [@[@"Playlists",@"Artists",@"Albums",@"Songs"]mutableCopy];
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
    cell.textLabel.text = list[indexPath.row];
    
    
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArtistsVC *vc =[[ArtistsVC alloc]init];
    vc.title  = list[indexPath.row];
    if (indexPath.row == 1) {
        
        vc.mediaItemProperty = MPMediaItemPropertyArtist;
    }
    else if (indexPath.row == 2){
        
        vc.mediaItemProperty = MPMediaItemPropertyAlbumTitle;
    }
    else if (indexPath.row == 3){
        
         vc.mediaItemProperty = MPMediaItemPropertyTitle;
    }
    else{
        
        vc.mediaItemProperty = @"playlist";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end

//
//  MusicVC.m
//  ibulb
//
//  Created by Interest on 2016/10/28.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "MusicVC.h"
#import "SpotifyVC.h"
#import "TuneinVC.h"
#import "UsbVC.h"
#import "IphoneVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GlobalInfo.h"

#import "DDXML.h"
#import "WiimuUPnP.h"
@interface MusicVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIView *contentview;
@property (weak, nonatomic) IBOutlet UILabel *songlab;

@end

@implementation MusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollview.contentSize = CGSizeMake(ScreenWidth, 500);
    self.contentview.frame = CGRectMake(0, 0, ScreenWidth, 500);
    [self.scrollview addSubview:self.contentview];
    [self getAllmusics];
    
    
//    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
//    NSArray *playlists = [myPlaylistsQuery collections];
//    for (MPMediaPlaylist *playlist in playlists) {
//        NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
//        
//        NSArray *songs = [playlist items];
//        for (MPMediaItem *song in songs) {
//            NSString *songTitle =
//            [song valueForProperty: MPMediaItemPropertyTitle];
//            NSLog (@"\t\t%@", songTitle);
//        }
//    }
    
}

- (void)getAllmusics{
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    self.songlab.text =[NSString stringWithFormat:@"%lu songs",(unsigned long)itemsFromGenericQuery.count];
}

- (IBAction)btnAction:(UIButton *)sender {
    
    if (sender.tag == 0) {
        
        SpotifyVC *vc = [[SpotifyVC alloc]init];
        vc.title = @"SPOTIFY";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (sender.tag == 1){
        
        TuneinVC *vc = [[TuneinVC alloc]init];
        vc.title = @"TUNEIN";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        NSURL *myUrl = [NSURL URLWithString:@"QQmusic://"];
        [[UIApplication sharedApplication] openURL:myUrl];

    }
}
- (IBAction)localAction:(UIButton *)sender {
    
    if (sender.tag == 0) {
        
        IphoneVC *vc = [[IphoneVC alloc]init];
        vc.title = @"IPHONE MUSIC";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (sender.tag == 2){
        
        UsbVC *vc = [[UsbVC alloc]init];
        vc.title = @"USB DISK";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}


@end

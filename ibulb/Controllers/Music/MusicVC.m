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
    
    self.locallab.text = NSLocalizedString(@"LOCAL MUSIC", nil);
    [self.ilab setTitle:NSLocalizedString(@"iPhone Music", nil) forState:UIControlStateNormal];
    [self.nlab setTitle:NSLocalizedString(@"Net Music Storage", nil) forState:UIControlStateNormal];
    [self.ulab setTitle:NSLocalizedString(@"USB Disk", nil) forState:UIControlStateNormal];
    self.slab.text = NSLocalizedString(@"STREAMING SERVICE", nil);
}

- (void)getAllmusics{
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSArray *itemsFromGenericQuery = [everything items];
    self.songlab.text =[NSString stringWithFormat:@"%lu %@",(unsigned long)itemsFromGenericQuery.count,NSLocalizedString(@"songs", nil)];
}

- (IBAction)btnAction:(UIButton *)sender {
    
    if (sender.tag == 0) {
        
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Spotify"]) {
            
            NSURL *myUrl = [NSURL URLWithString:@"Spotify://"];
            [[UIApplication sharedApplication] openURL:myUrl];
            
        }
        else{
            
            SpotifyVC *vc = [[SpotifyVC alloc]init];
            vc.title = @"SPOTIFY";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }

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
        vc.title = NSLocalizedString(@"iPhone Music", nil);
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (sender.tag == 2){
        
        UsbVC *vc = [[UsbVC alloc]init];
        vc.title = NSLocalizedString(@"USB Disk", nil);
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}


@end

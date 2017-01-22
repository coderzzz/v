//
//  SpotifyVC.m
//  ibulb
//
//  Created by Interest on 2016/10/31.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "SpotifyVC.h"
@interface SpotifyVC ()


@end
@implementation SpotifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lab.text = @"Spotify Premium lets you listen to millions of songs ad-free - the artists you love, the latest hits and discoveries just for you. Simply hit play to hear any song you like, at the highest sound quality. millions of songs. Your new device has Spotify Connect built in. You'll need Spotify Premium to use Connect. Learn more at spotify.com/connect O Play any song in Spotify app. O Tap the song image in the bottom left of the screen. @ Tap the Connect icon @ Pick your speaker from the list.";
    
}
- (IBAction)run:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Spotify"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSURL *myUrl = [NSURL URLWithString:@"Spotify://"];
    [[UIApplication sharedApplication] openURL:myUrl];
    
}
@end

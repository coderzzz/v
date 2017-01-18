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
    

}
- (IBAction)run:(id)sender {
    
    NSURL *myUrl = [NSURL URLWithString:@"Spotify://"];
    [[UIApplication sharedApplication] openURL:myUrl];
}
@end

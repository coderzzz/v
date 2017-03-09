//
//  SpotifyVC.m
//  ibulb
//
//  Created by Interest on 2016/10/31.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "SpotifyVC.h"
@interface SpotifyVC ()

@property (weak, nonatomic) IBOutlet UILabel *dlab;
@property (weak, nonatomic) IBOutlet UIButton *rbtn;

@end
@implementation SpotifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = NSLocalizedString(@"Spotify Premium lets you listen to millions of songs ad-free - the artists you love, the latest hits and discoveries just for you. Simply hit play to hear any song you like, at the highest sound quality. millions of songs. Your new device has Spotify Connect built in. You'll need Spotify Premium to use Connect. Learn more at spotify.com/connect O Play any song in Spotify app. O Tap the song image in the bottom left of the screen. @ Tap the Connect icon @ Pick your speaker from the list.", nil);
    
    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc] initWithString:str];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"Page0"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, 0, 16, 16);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];
    
    // 用label的attributedText属性来使用富文本
    NSMutableAttributedString *b =[[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"ss", nil)];
    [attri appendAttributedString:b];
    self.lab.attributedText = attri;
    
    

    NSMutableAttributedString *attri2 =[[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"don’t show this agin。", nil)];
    NSTextAttachment *attch3 = [[NSTextAttachment alloc] init];
    // 表情图片
    attch3.image = [UIImage imageNamed:@"Circle"];
    // 设置图片大小
    attch3.bounds = CGRectMake(-10, -6, 22, 22);
    
    // 创建带有图片的富文本
    NSAttributedString *string2 = [NSAttributedString attributedStringWithAttachment:attch3];
    
    [attri2 insertAttributedString:string2 atIndex:0];
    self.dlab.attributedText = attri2;
    [self.rbtn setTitle:NSLocalizedString(@"RUN NOW", nil) forState:UIControlStateNormal];
}
- (IBAction)run:(id)sender{
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Spotify"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSURL *myUrl = [NSURL URLWithString:@"Spotify://"];
    [[UIApplication sharedApplication] openURL:myUrl];
    
}
@end

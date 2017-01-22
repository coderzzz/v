//
//  VolumeViewController.m
//  ibulb
//
//  Created by Interest on 2016/11/30.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "VolumeViewController.h"

@interface VolumeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation VolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lab.text = [NSString stringWithFormat:@"%.f%%",self.value];
    self.slider.value = self.value;
}
- (IBAction)changeVolume:(UISlider *)sender {
    
    self.lab.text = [NSString stringWithFormat:@"%.f%%",sender.value];
}

- (void)back{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateStartupVolume:type:)]) {
        
        [self.delegate didUpdateStartupVolume:self.slider.value type:self.type];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

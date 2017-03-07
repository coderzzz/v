//
//  VifaTopCell.m
//  ibulb
//
//  Created by Interest on 2016/12/7.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "VifaTopCell.h"

@implementation VifaTopCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.playwebview.hidden = YES;
    NSMutableArray *images = [NSMutableArray array];
    for (int a = 1; a<42; a++) {
        
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"图层-%d",a]];
        if (img) {
            
            [images addObject:img];
            
        }
        
    }
    
    self.playwebview.animationImages = images;
    self.playwebview.animationDuration = 2;
    self.playwebview.animationRepeatCount = 0;
    [self.playwebview startAnimating];
    
    
}

@end

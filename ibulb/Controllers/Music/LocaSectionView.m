//
//  LocaSectionView.m
//  ibulb
//
//  Created by Interest on 2016/11/9.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "LocaSectionView.h"

@implementation LocaSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
     self = [[[NSBundle mainBundle]loadNibNamed:@"LocaSectionView"owner:self options:nil] firstObject];
    }
    return self;
}
@end

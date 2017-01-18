//
//  LinkView.m
//  ibulb
//
//  Created by Interest on 2017/1/5.
//  Copyright © 2017年 Interest. All rights reserved.
//

#import "LinkView.h"

@implementation LinkView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"LinkView"owner:self options:nil] firstObject];
    }
    return self;
}
@end

//
//  SettingSectionView.m
//  ibulb
//
//  Created by Interest on 16/1/9.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "SettingSectionView.h"

@implementation SettingSectionView

-(id)init{
    
    self = [super init];
    if (self) {
        
        self = [[NSBundle mainBundle]loadNibNamed:@"SettingSectionView" owner:self options:nil][0];
        
        
    }
    return self;
}
@end

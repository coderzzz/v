//
//  BaseButton.m
//  ibulb
//
//  Created by Interest on 2017/3/9.
//  Copyright © 2017年 Interest. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{

//    [self setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height); //  <- Here
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

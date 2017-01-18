//
//  CircleView.m
//  ibulb
//
//  Created by Interest on 2016/12/3.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "CircleView.h"
#define SQR(x)			( (x) * (x) )
@implementation CircleView
#define pi 3.14159265358979323846
#define degreesToRadian(x) (pi * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / pi)
#pragma mark 计算圆圈上点在IOS系统中的坐标

{
    UIImageView *handleimgv;
}
-(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}

- (CGFloat)angleBetweenLines:(CGPoint)line1Start line1End:(CGPoint)line1End line2Start:(CGPoint) line2Start  line2End:(CGPoint) line2End
{
    
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    return radiansToDegrees(rads);
    
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    handleimgv  =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"椭圆-1"]];
    handleimgv.center = CGPointMake(270/2, 0);
    [self addSubview:handleimgv];
}

- (void)movePoint:(CGPoint)point{
    
   
    CGFloat radians=[self angleBetweenLines:CGPointMake(270/2, 270/2) line1End:CGPointMake(270/2, 0) line2Start:CGPointMake(270/2, 270/2) line2End:point];
    if (point.x<270/2) {
        
        radians = 360 -radians;
    }
    self.currentValue = (int)radians;
    handleimgv.center = [self calcCircleCoordinateWithCenter:CGPointMake(270/2, 270/2) andWithAngle:90-radians andWithRadius:270/2];
    
}

#pragma mark - UIControl Override

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint touchLocation = [touch locationInView:self];
    [self movePoint:touchLocation];
    [self sendAction:self.selector to:self.target forEvent:event];
    return YES;

}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [super endTrackingWithTouch:touch withEvent:event];
//    NSLog(@"radians =%.f",radians);
}

@end

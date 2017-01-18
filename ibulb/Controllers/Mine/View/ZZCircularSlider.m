//
//  ZZCircularSlider.m
//  ibulb
//
//  Created by Interest on 16/1/8.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "ZZCircularSlider.h"
#define MAXANGLE 170
#define START_ANGLE 90
#define CLOCK_WISE YES
#define SQR(x)			( (x) * (x) )
#define CENTER_POINT CGPointMake(220/2, 100)

#define CenterX 220/2
@implementation ZZCircularSlider
{
    int radius;
    
    UIImageView *handel;
}

-(id)initWithFrame:(CGRect)frame
          usingMax:(float) max
          usingMin:(float) min
        withTarget:(id)target
        sliderMode:(ZZCircularSliderMode)mode
     usingSelector:(SEL)selector
{
    self = [super initWithFrame:frame];
    
    if(self){
        self.target = target;
        self.selector = selector;
        self.opaque = NO;
        self.angle = 0;
        self.maxValue = max;
        self.minValue = min;
        self.sliderMode =mode;
        
        UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 220, 100)];
        
    
        
        
        
        
        handel = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100-20, 20, 20)];
        
        handel.image = [UIImage imageNamed:@"移动按钮"];
        
    
        
        
        
        if (self.sliderMode == ZZCircularSliderModeTop) {
            
            imagev.image = [UIImage imageNamed:@"上半圆"];

//            
            handel.center = CGPointMake(7, 96);
        }
        else{

            
            imagev.image = [UIImage imageNamed:@"下半圆"];
            
            handel.center = CGPointMake(6,0);
        }
        
        
        [self addSubview:imagev];
        
        [self addSubview:handel];
        
    }

    return self;

}

- (void)updateSliderWithValue:(int)value{
    
    CGFloat x = value * 2;
    
    CGFloat y  = 0;
    
    if (x<=100) {
    
        
        CGFloat h=sqrtf(10000 - (100 -x) * (100 - x));
        
        if (self.sliderMode == ZZCircularSliderModeTop) {
            
            y = 110 - h;
            
            if (y>96) {
                
                y=96;
            }
            
        }
        else{
            
            
            y = h-8;
            if (y<0) {
                y=0;
            }
        }
        
        
        handel.center = CGPointMake(x + 8, y);
    }
    else{
        
        CGFloat h=sqrtf(10000 - (x -100) * (x - 100));
        
        
        if (self.sliderMode == ZZCircularSliderModeTop) {
            
            y = 110 - h;
            
            if (y>96) {
                
                y=96;
            }
            
        }
        else{
            
            
            y = h-8;
            
            if (y<0) {
                y=0;
            }
        }
        
        handel.center = CGPointMake(x + 11, y);
        
    }
    
    


}

#pragma mark - UIControl Override

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    CGPoint touchLocation = [touch locationInView:self];
    
    
    [self movehandle:touchLocation];

    
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [super continueTrackingWithTouch:touch withEvent:event];
    
   
    
    CGPoint touchLocation = [touch locationInView:self];
    
 
//    [self movehandle:touchLocation];
//    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
//    if ([self pointInside:touchLocation withEvent:event]) {
//        
        [self movehandle:touchLocation];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
//
        return YES;
//    }
//    else{
//        
//        return NO;
//    }
//   
}

-(float) distanceFrom:(CGPoint) p1 To:(CGPoint) p2{
    CGFloat xDist = (p1.x - p2.x);
    CGFloat yDist = (p1.y - p2.y);
    float distance = sqrt((xDist * xDist) + (yDist * yDist));
    //    NSLog(@" distance is %.2f", distance);
    return distance;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
}

#pragma mark 

+(float) toRad:(float)deg  withMax:(float)max{
    return ( (M_PI * (deg)) / (max/2) );
}

+(float) toDeg:(float)rad withMax:(float)max
{
    return ( ((max/2) * (rad)) / M_PI );
}

-(void)movePoint:(CGPoint)point{
    
    CGPoint v = CGPointMake(point.x-270/2,point.y-270/2);
    float vmag = sqrt(SQR(v.x) + SQR(v.y));
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    
    NSLog(@"radians =%.f",radians);
}

-(void)movehandle:(CGPoint)lastPoint{
    
    
    CGFloat originX = lastPoint.x;
    CGFloat originY = lastPoint.y;
    CGFloat x = originX;

    CGFloat space = 6;
    
    CGFloat orginx= 0;
    
    if (x<space) {
        x = 0;
    }
    
    if (x>220-space) {
        
        x = 220-space;
    }
    
    orginx = x;
    
    if (lastPoint.x>CenterX) {
        
        x = x-CenterX;
    }
    else{
        
        x = CenterX-x;
    }
    

    double h =sqrt((CenterX-space)*(CenterX-space)-x * x);
    
    
    if (h>=0) {
        
        if (self.sliderMode == ZZCircularSliderModeTop) {
            
            CGFloat y = 110-h;
            
            if (y>96) {
                
                y=96;
            }
            
            handel.center = CGPointMake(orginx,y);
        }
        else{
            
            CGFloat y = h-8;
            
            if (y<0) {
                y=0;
            }
            
            
            handel.center = CGPointMake(orginx,y);
        }
       
    }
    
    
    float value =originX * self.maxValue/220;
    

//    float value = round((angleNext * self.maxValue)/MAXANGLE);
   [self movehandleToValue:value];
}

-(void)movehandleToValue:(float)value{
    if (value>self.maxValue) {
        value=self.maxValue;
    }else if (value<self.minValue){
        value= self.minValue;
    }
    self.currentValue = value;
    self.angle = ((self.currentValue * MAXANGLE)/self.maxValue);
    
//    [self setTextValue];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [[self target] performSelector:[self selector]
                        withObject:self];
//    [self setNeedsDisplay];
}

//-(CGPoint)pointFromAngle:(float)angleInt{
//    CGPoint centerPoint = CENTER_POINT;
//    CGPoint result;
//    result.y = centerPoint.y + radius * sin([ZZCircularSlider toRad:(-angleInt) withMax:MAXANGLE]);
//    result.x = centerPoint.x + radius * cos([ZZCircularSlider toRad:(-angleInt) withMax:MAXANGLE]);
//    
//    return result;
//}
//
//static inline float AngleFromNorth(CGPoint p1, CGPoint p2, float max) {
//    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
//    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
//    v.x /= vmag;
//    v.y /= vmag;
//    double radians = atan2(v.y,v.x);
//    result = [ZZCircularSlider toDeg:(radians)  withMax:max] + START_ANGLE;
//    result = (result >=0  ? result : result + max);
//    if (CLOCK_WISE) {
//        result = MAXANGLE - result;
//    }
//    return (result >=0  ? result : result + max);
//}

@end

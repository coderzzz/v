//
//  ZZCircularSlider.h
//  ibulb
//
//  Created by Interest on 16/1/8.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ZZCircularSlider : UIControl

typedef NS_ENUM(NSInteger, ZZCircularSliderMode) {
    ZZCircularSliderModeTop,
    ZZCircularSliderModeaButtom,
};

@property (nonatomic,assign) float angle;
@property (nonatomic) int currentValue;
@property (nonatomic) float maxValue;
@property (nonatomic) float minValue;
@property (nonatomic) int majorStep;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) ZZCircularSliderMode sliderMode;

-(id)initWithFrame:(CGRect)frame
          usingMax:(float) max
          usingMin:(float) min
        withTarget:(id)target
        sliderMode:(ZZCircularSliderMode)mode
     usingSelector:(SEL)selector;

- (void)updateSliderWithValue:(int)value;
@end

//
//  CircleView.h
//  ibulb
//
//  Created by Interest on 2016/12/3.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIControl
@property (nonatomic) int currentValue;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@end

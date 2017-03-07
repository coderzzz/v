//
//  LeftCell.h
//  ibulb
//
//  Created by Interest on 2016/11/4.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *leftbtn;
@property (weak, nonatomic) IBOutlet UIButton *rightbtn;

@property (weak, nonatomic) IBOutlet UIImageView *imgv;

@property (weak, nonatomic) IBOutlet UILabel *titlelab;



@end

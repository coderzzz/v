//
//  VifaTopCell.h
//  ibulb
//
//  Created by Interest on 2016/12/7.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VifaTopCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIButton *donebtn;
@property (weak, nonatomic) IBOutlet UILabel *namelab;
@property (weak, nonatomic) IBOutlet UIImageView *bgimgv;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@property (weak, nonatomic) IBOutlet UIView *playview;

@property (weak, nonatomic) IBOutlet UIImageView *playimgv;
@property (weak, nonatomic) IBOutlet UIImageView *playwebview;

- (void)start;
- (void)stop;
@end

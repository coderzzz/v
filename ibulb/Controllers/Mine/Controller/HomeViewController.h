//
//  HomeViewController.h
//  ibulb
//
//  Created by Interest on 16/1/7.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "BaseViewController.h"
#import "ZZCircularSlider.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Palette.h"
@interface HomeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *lightOnbtn;

- (IBAction)oneOn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;


@property (weak, nonatomic) IBOutlet UIButton *allbtn;

@end

//
//  ArtistsVC.h
//  ibulb
//
//  Created by Interest on 2016/10/31.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "BaseViewController.h"

@interface ArtistsVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (copy, nonatomic) NSString *mediaItemProperty;

@end

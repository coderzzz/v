//
//  ChoseCell.m
//  ibulb
//
//  Created by Interest on 16/1/9.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "ChoseCell.h"

@implementation ChoseCell

- (void)awakeFromNib {
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

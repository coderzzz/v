//
//  LCell.m
//  ibulb
//
//  Created by Interest on 2016/11/9.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "LCell.h"

@implementation LCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

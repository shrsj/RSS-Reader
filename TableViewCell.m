//
//  TableViewCell.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 14/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.frame = CGRectMake(15, 5, 100, 100);
}

@end

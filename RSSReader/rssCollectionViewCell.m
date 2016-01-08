//
//  rssCollectionViewCell.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 06/01/16.
//  Copyright © 2016 Mac-Mini-2. All rights reserved.
//

#import "rssCollectionViewCell.h"

@implementation rssCollectionViewCell

-(void) awakeFromNib
{
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView =bgView;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    //selected background
    UIView *selected = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView = selected;
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithHue:0.54 saturation:0.54 brightness:0.87 alpha:0.4];
}
@end

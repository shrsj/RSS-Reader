//
//  rssCollectionViewCell.h
//  RSSReader
//
//  Created by Mac-Mini-2 on 06/01/16.
//  Copyright © 2016 Mac-Mini-2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rssCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *feedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *feedSymbol;
@end

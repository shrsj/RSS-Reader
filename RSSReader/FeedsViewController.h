//
//  FeedsViewController.h
//  RSSReader
//
//  Created by Mac-Mini-2 on 11/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface FeedsViewController : UITableViewController <NSXMLParserDelegate,UINavigationControllerDelegate,UITableViewDelegate,SDWebImageManagerDelegate>

@property (strong,nonatomic) NSString *url;
@property (nonatomic, strong) NSCache *imageCache;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndi;


@end

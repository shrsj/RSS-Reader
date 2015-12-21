//
//  FeedsViewController.h
//  RSSReader
//
//  Created by Mac-Mini-2 on 11/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedsViewController : UITableViewController <NSXMLParserDelegate,UINavigationControllerDelegate,UITableViewDelegate>

@property (strong,nonatomic) NSString *url;

@end

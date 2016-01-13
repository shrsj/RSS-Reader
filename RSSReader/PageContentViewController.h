//
//  PageContentViewController.h
//  RSSReader
//
//  Created by Mac-Mini-2 on 21/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PageContentViewController : UIViewController

@property NSUInteger pageIndex;
@property NSString *labelText;
@property NSString *webUrl;
@property (strong, nonatomic) NSMutableArray *rssfeeds;

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@end

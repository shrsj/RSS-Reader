//
//  DetailViewController.h
//  RSSReader
//
//  Created by Mac-Mini-2 on 14/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOWebViewController.h"

@interface DetailViewController : UIViewController < UIPageViewControllerDataSource>

//@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *rssfeeds;
@property (strong, nonatomic) NSString *url;
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UILabel *article;
@property NSInteger selected;
@property (weak, nonatomic) IBOutlet UIButton *previous;

- (IBAction)prev:(UIButton *)sender;
- (IBAction)next:(UIButton *)sender;


@end

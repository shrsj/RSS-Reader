//
//  PageContentViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 21/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "PageContentViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PageContentViewController ()

@property (strong) UIView *detailWebView;

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.Title.text = [self.rssfeeds[self.pageIndex] objectForKey:@"title"];
    NSString *linked = [[self.rssfeeds objectAtIndex:self.pageIndex] objectForKey:@"image"];
    NSURL *iurl = [NSURL URLWithString:linked];
    [self.Image sd_setImageWithURL:iurl placeholderImage:[UIImage imageNamed:@"no image"]];
    NSString *description = [self.rssfeeds[self.pageIndex] objectForKey:@"description"];
    NSString *desc = [NSString stringWithString:[description stringByRemovingPercentEncoding]];
    self.articleContent.text = desc;
    //set the url
    NSLog(@"Feeeds are %@", self.rssfeeds[self.pageIndex]);
    
    NSLog(@"DiskCache: %@ of %@", @([[NSURLCache sharedURLCache] currentDiskUsage]), @([[NSURLCache sharedURLCache] diskCapacity]));
    NSLog(@"MemoryCache: %@ of %@", @([[NSURLCache sharedURLCache] currentMemoryUsage]), @([[NSURLCache sharedURLCache] memoryCapacity]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

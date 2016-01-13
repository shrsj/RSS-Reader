//
//  PageContentViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 21/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "PageContentViewController.h"
#import "AppDelegate.h"
#import "CustomURLCache.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set the url
    NSString *link = [self.webUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSCharacterSet *customCharacterset = [[NSCharacterSet characterSetWithCharactersInString:@" "] invertedSet];
    NSURL *myURL = [NSURL URLWithString: [link stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:300];
    
    [self.detailWebView loadRequest:request];
    self.detailWebView.paginationMode = UIWebPaginationModeTopToBottom;
    self.detailWebView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    NSLog(@"DiskCache: %@ of %@", @([[NSURLCache sharedURLCache] currentDiskUsage]), @([[NSURLCache sharedURLCache] diskCapacity]));
    NSLog(@"MemoryCache: %@ of %@", @([[NSURLCache sharedURLCache] currentMemoryUsage]), @([[NSURLCache sharedURLCache] memoryCapacity]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

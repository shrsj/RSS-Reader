//
//  PageContentViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 21/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "PageContentViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "CustomURLCache.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NSURL *myURL = [NSURL URLWithString: [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    
    //set the url
    NSString *link = [self.webUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSCharacterSet *customCharacterset = [[NSCharacterSet characterSetWithCharactersInString:@" "] invertedSet];
    NSURL *myURL = [NSURL URLWithString: [link stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset]];
    
    CustomURLCache *cust = [[CustomURLCache alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:300];
    
    /*NSCachedURLResponse *response = [cust cachedResponseForRequest:request];
    NSLog(@"cached response is %@",response);*/
    
  /*  if (response == NULL) {
        [cust storeCachedResponse:response forRequest:request]);
    }*/
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

//
//  PageContentViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 21/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *link = [self.webUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
   // NSURL *myURL = [NSURL URLWithString: [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSCharacterSet *customCharacterset = [[NSCharacterSet characterSetWithCharactersInString:@" "] invertedSet];
    NSURL *myURL = [NSURL URLWithString: [link stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
   // NSURLRequest *request = [NSURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:300];
    [self.detailWebView loadRequest:request];
    self.detailWebView.paginationMode = UIWebPaginationModeTopToBottom;
    self.detailWebView.paginationBreakingMode = UIWebPaginationBreakingModePage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

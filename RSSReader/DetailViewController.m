//
//  DetailViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 14/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    NSInteger selectedRow;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",self.url);
    
    NSString *link = [self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSURL *myURL = [NSURL URLWithString: [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    /*if ([[UIApplication sharedApplication] canOpenURL:myURL]) {
     [[UIApplication sharedApplication] openURL:myURL];
     }*/
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    
    
    [self.detailWebView loadRequest:request];
    self.detailWebView.paginationMode = UIWebPaginationModeTopToBottom;
    self.detailWebView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    NSString *plabel = [NSString stringWithFormat:@" Article %ld of %lu ",(long)self.selected,(unsigned long)([self.rssfeeds count]-1)];
    self.article.text = plabel;
    selectedRow = self.selected;
    
    //swipe gesture
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc ] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.detailWebView addGestureRecognizer:swipeRight];
    swipeRight.delegate =self;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.detailWebView addGestureRecognizer:swipeLeft];
    
    self.previous.titleLabel.adjustsFontSizeToFitWidth = TRUE;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)prev:(UIButton *)sender
{
    if (selectedRow > 0 && selectedRow < [self.rssfeeds count])
    {
        selectedRow = selectedRow - 1;
        NSString *plabel = [NSString stringWithFormat:@" Article %ld of %lu ",(long)selectedRow,(unsigned long)[self.rssfeeds count]];
        self.article.text = plabel;
        NSString *string = [self.rssfeeds[selectedRow] objectForKey: @"link"];
        NSString *data= [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL *myURL = [NSURL URLWithString: [data stringByAddingPercentEscapesUsingEncoding:
                                              NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
        [self.detailWebView loadRequest:request];
    }
    else{
        NSLog(@"U cant read articles before the beginning of what begins ;) ");
    }
    
}

- (IBAction)next:(UIButton *)sender
{
    if (selectedRow < ([self.rssfeeds count] -1))
    {
        selectedRow = selectedRow + 1;
        NSString *plabel = [NSString stringWithFormat:@" Article %ld of %lu ",(long)selectedRow,(unsigned long)[self.rssfeeds count]];
        self.article.text = plabel;
        //reload the webview
        NSString *string = [self.rssfeeds[selectedRow] objectForKey: @"link"];
        NSString *data= [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL *myURL = [NSURL URLWithString: [data stringByAddingPercentEscapesUsingEncoding:
                                              NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
        [self.detailWebView loadRequest:request];
    }
    else
    {
        NSLog(@"Hello boss no more articles !!!");
    }
    
}

#pragma mark Swipe gesture delegate methods

-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (selectedRow > 0 && selectedRow < [self.rssfeeds count])
    {
        selectedRow = selectedRow - 1;
        NSString *plabel = [NSString stringWithFormat:@" Article %ld of %lu ",(long)selectedRow,(unsigned long)[self.rssfeeds count]];
        self.article.text = plabel;
        NSString *string = [self.rssfeeds[selectedRow] objectForKey: @"link"];
        NSString *data= [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL *myURL = [NSURL URLWithString: [data stringByAddingPercentEscapesUsingEncoding:
                                              NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
        [self.detailWebView loadRequest:request];
    }
    else{
        NSLog(@"NOTHING");
    }
    
}

-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (selectedRow < ([self.rssfeeds count] -1))
    {
        selectedRow = selectedRow + 1;
        NSString *plabel = [NSString stringWithFormat:@" Article %ld of %lu ",(long)selectedRow,(unsigned long)[self.rssfeeds count]];
        self.article.text = plabel;
        //reload the webview
        NSString *string = [self.rssfeeds[selectedRow] objectForKey: @"link"];
        NSString *data= [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL *myURL = [NSURL URLWithString: [data stringByAddingPercentEscapesUsingEncoding:
                                              NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
        [self.detailWebView loadRequest:request];
    }
    else
    {
        NSLog(@"Hello boss no more articles !!!");
    }
}

@end

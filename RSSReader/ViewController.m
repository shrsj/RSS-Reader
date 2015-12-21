//
//  ViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 10/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "ViewController.h"
#import "FeedsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)news:(UIButton *)sender
{
    FeedsViewController *feeds = [self.storyboard instantiateViewControllerWithIdentifier:@"feeds"];
    feeds.url = @"http://www.ozarkareanetwork.com/category/app-feed/feed/rss2";
    [self.navigationController showViewController:feeds sender:self];
}

- (IBAction)sports:(UIButton *)sender
{
    FeedsViewController *feeds = [self.storyboard instantiateViewControllerWithIdentifier:@"feeds"];
    feeds.url = @"http://www.ozarkareanetwork.com/category/sports/feed/rss2";
    [self.navigationController showViewController:feeds sender:self];
}

- (IBAction)birth:(UIButton *)sender
{
    FeedsViewController *feeds = [self.storyboard instantiateViewControllerWithIdentifier:@"feeds"];
    feeds.url = @"http://www.ozarkareanetwork.com/category/birthdays-anniversaries/feed/rss2";
    [self.navigationController showViewController:feeds sender:self];
}

- (IBAction)obit:(UIButton *)sender
{
    FeedsViewController *feeds = [self.storyboard instantiateViewControllerWithIdentifier:@"feeds"];
    feeds.url = @"http://www.ozarkareanetwork.com/category/obits/feed/rss2";
    [self.navigationController showViewController:feeds sender:self];
}
@end

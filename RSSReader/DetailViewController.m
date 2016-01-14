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
    selectedRow = self.selected;
    NSString *plabel = [NSString stringWithFormat:@" Article %ld of %lu ",((long)selectedRow+1),(unsigned long)[self.rssfeeds count]];
    self.article.text = plabel;
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    TOWebViewController *startingViewController = [self viewControllerAtIndex:selectedRow];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
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
        NSString *plabel = [NSString stringWithFormat:@" Article %ld of %lu ",((long)selectedRow+1),(unsigned long)[self.rssfeeds count]];
        self.article.text = plabel;
        TOWebViewController *startingViewController  = [self viewControllerAtIndex:selectedRow];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
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
        NSString *plabel = [NSString stringWithFormat:@" Article %ld of %lu ",((long)selectedRow+1),(unsigned long)[self.rssfeeds count]];
        self.article.text = plabel;
        
        //reload the webview
        TOWebViewController *startingViewController  = [self viewControllerAtIndex:selectedRow];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    else
    {
        NSLog(@"Hello boss no more articles !!!");
    }
    
}
#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    if ((selectedRow == 0) || (selectedRow == NSNotFound)) {
        return nil;
    }
    if (selectedRow > 0 && selectedRow < [self.rssfeeds count])
    {
        selectedRow--;
        NSString *plabel = [NSString stringWithFormat:@" Article %ld of %lu ",((long)selectedRow+1),(unsigned long)[self.rssfeeds count]];
        self.article.text = plabel;
        return [self viewControllerAtIndex:selectedRow];
    }
    else
    {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    
    if (selectedRow == NSNotFound) {
        return nil;
    }
    
    selectedRow++;
    if (selectedRow == [self.rssfeeds count]) {
        return nil;
    }
    if (selectedRow < [self.rssfeeds count])
    {
        NSString *plabel = [NSString stringWithFormat:@" Article %ld of %lu ",((long)selectedRow+1),(unsigned long)[self.rssfeeds count]];
        self.article.text = plabel;
        return [self viewControllerAtIndex:selectedRow];
    }
    else{
        return nil;
    }
}

- (TOWebViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.rssfeeds count] == 0) || (index >= [self.rssfeeds count]))
    {
        return nil;
    }
    
    // Create a new view controller and pass suitable data
    
    NSString *webUrl = [self.rssfeeds[index] objectForKey:@"link"];
    NSString *link = [webUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSCharacterSet *customCharacterset = [[NSCharacterSet characterSetWithCharactersInString:@" "] invertedSet];
    NSURL *myURL = [NSURL URLWithString: [link stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset]];
    TOWebViewController *webViewContoller  = [[TOWebViewController alloc]initWithURL:myURL];
    return webViewContoller;
}


-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.rssfeeds count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


@end

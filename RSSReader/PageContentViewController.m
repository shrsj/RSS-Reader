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
#import "TFHpple.h"

#define DELEGATE ((AppDelegate*)[[UIApplication sharedApplication]delegate])

@interface PageContentViewController ()
{
    TFHpple *parser;
    NSMutableString *Content;                        //Contains article content
}
@end

@implementation PageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self loadfeeds];
    [self.activityIndi startAnimating];
    AppDelegate *checkCache = DELEGATE;
    
    NSString *link = self.webUrl;
    id obj = [checkCache.articleCache objectForKey:link];
    
    
    if(obj != NULL)
    {
        NSLog(@"Article in Cache");
        NSString *contents = [checkCache.articleCache valueForKey:link];
        [self loadDataOnView:contents];
    }
    else
    {
        NSOperationQueue* aQueue = [[NSOperationQueue alloc] init];
        [aQueue addOperationWithBlock:^{
            NSLog(@"Article not in Cache");
            [self startParsing];
        }];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark convert and display html in view methods
-(void)loadDataOnView:(NSString *)ContentOfArticle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.Title.text = [self.rssfeeds[self.pageIndex] objectForKey:@"title"];
        
        //setting image
        NSString *linked = [[self.rssfeeds objectAtIndex:self.pageIndex] objectForKey:@"image"];
        NSURL *iurl = [NSURL URLWithString:linked];
        [self.Image sd_setImageWithURL:iurl placeholderImage:[UIImage imageNamed:@"no image"]];
        
        //set the article content
        
        self.articleContent.attributedText = [self convertHtmlToAttributedText:ContentOfArticle];
        [self.activityIndi stopAnimating];
        self.activityIndi.hidden = TRUE;
    });
    
    
}

-(NSAttributedString *)convertHtmlToAttributedText:(NSString *)content
{
    NSData *stringData = [content dataUsingEncoding:NSUTF32StringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSAttributedString *decodedString;
    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                     options:options
                                          documentAttributes:NULL
                                                       error:NULL];
    return decodedString;
}

-(void)startParsing
{
    //COnvert string to proper url
    NSString *url = self.webUrl;
    NSString* webString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    webString = [webString stringByReplacingOccurrencesOfString:@"%0A%09%09" withString:@""];
    webString = [webString stringByReplacingOccurrencesOfString:@"%3A" withString:@":"];
    NSURL *webString1 = [NSURL URLWithString:webString];
    NSData *HtmlData = [NSData dataWithContentsOfURL:webString1];
    
    //parse the link
    
    parser = [TFHpple hppleWithHTMLData:HtmlData];
    NSString *pathQuery = @"//div[@class='entry-content']/p";
    NSArray *nodes = [parser searchWithXPathQuery:pathQuery];
    Content =[[NSMutableString alloc] init];
    
    for(TFHppleElement *element in nodes)
    {
        [Content appendString:[element content]];
    }
    //NSAttributedString *attributedContent = [[NSAttributedString alloc] initWithString:Content];
    [self loadDataOnView:Content];
    
    AppDelegate *checkCache = DELEGATE;
    [checkCache.articleCache setObject:Content forKey:url];
    NSLog(@"updated to cache, total articles in cache -- %lu",(unsigned long)[checkCache.articleCache count]);
    
}

@end
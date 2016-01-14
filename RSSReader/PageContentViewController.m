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
    NSAttributedString *decodedString = [self convertHtmlToAttributedText:description];
    self.articleContent.attributedText = decodedString;
    //set the url
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSAttributedString *)convertHtmlToAttributedText:(NSAttributedString *)content
{
    NSData *stringData = [[content string] dataUsingEncoding:NSUTF32StringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSAttributedString *decodedString;
    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                     options:options
                                          documentAttributes:NULL
                                                       error:NULL];
    return decodedString;
}
@end

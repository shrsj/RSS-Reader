//
//  PageContentViewController.h
//  RSSReader
//
//  Created by Mac-Mini-2 on 21/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PageContentViewController : UIViewController

@property NSUInteger pageIndex;
@property NSString *labelText;
@property NSString *webUrl;
@property (strong, nonatomic) NSMutableArray *rssfeeds;

@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UITextView *articleContent;
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndi;

-(NSAttributedString *)convertHtmlToAttributedText:(NSString *)content;
@end

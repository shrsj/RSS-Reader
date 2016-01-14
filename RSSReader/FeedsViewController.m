
//  FeedsViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 11/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "FeedsViewController.h"
#import "DetailViewController.h"
#import "FeedsTableViewCell.h"


#define kAppIconHeight 100
#define kAppIconWidth 70

@interface FeedsViewController ()
{
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
    
    //variable to parse description and image link
    NSMutableString *previewImage;
    NSString *previewImage1;
    NSMutableString *subtitle;
}

@end

@implementation FeedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageCache = [[NSCache alloc] init];                                                                 //Initialise image cache
    
    
    feeds = [[NSMutableArray alloc] init];
    NSLog(@"starting progress bar");
    
    [self loadfeeds];
}

-(void)loadfeeds
{
    NSOperationQueue* aQueue = [[NSOperationQueue alloc] init];
    [aQueue addOperationWithBlock:^{
        [self.activityIndi startAnimating];
        NSLog(@"Beginning operation.\n");
        // Do some work.
        NSURL *url = [NSURL URLWithString:self.url];
        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        NSLog(@"parsing started in block");
        [parser parse];
        
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cell for row at index entered");
    // NSLog(@"inside cell for row at indexpath");
    FeedsTableViewCell *cell = [[FeedsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    
    NSString *normalSubtitle = [[feeds objectAtIndex:indexPath.row] objectForKey:@"description"];
    NSString *data= [normalSubtitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.text = data;
    
    NSString *linked = [[feeds objectAtIndex:indexPath.row] objectForKey:@"content:encoded"];
    NSURL *iurl = [NSURL URLWithString:linked];
    // NSString *path = [NSString stringWithFormat:@"%ld",(long)[indexPath row]];
    //NSData *imageData = [NSData dataWithContentsOfURL:iurl];
    
    [cell.imageView sd_setImageWithURL:iurl placeholderImage:[UIImage imageNamed:@"no image"]];
    /* SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
     [downloader downloadImageWithURL:iurl
     options:0
     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
     // progression tracking code
     [cell.imageView setImage:[UIImage imageNamed:@"no image"]];
     }
     completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
     if (image && finished) {
     // do something with image
     [cell.imageView setImage:image];
     }
     }];*/
    /*
     [SDWebImageDownloader.sharedDownloader downloadImageWithURL:iurl
     options:0
     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
     // progression tracking code
     [cell.imageView setImage:[UIImage imageNamed:@"no image"]];
     }
     completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
     if (cell.tag == indexPath.row && image && finished)
     {
     dispatch_async(dispatch_get_main_queue(), ^(){
     cell.imageView.image = image;
     });
     
     }
     }];
     */
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *details = [[DetailViewController alloc] init];
    details.url = [feeds[indexPath.row] objectForKey:@"link"];
    //NSLog(@"%@ %ld",[feeds[indexPath.row] objectForKey:@"link"],(long)indexPath.row);
    [self performSegueWithIdentifier:@"viewDetail" sender:self];
    
}

#pragma mark parser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    element = elementName;
    if ([element isEqualToString:@"item"])
    {
        //alloc for image and subtitle strings here
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        subtitle = [[NSMutableString alloc] init];
        previewImage = [[NSMutableString alloc] init];
        previewImage1 = [[NSString alloc] init];
        NSLog(@"parsing started in didstartelement block %@",link);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"])
    {
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:subtitle forKey:@"description"];
        [item setObject:previewImage1 forKey:@"content:encoded"];
        [feeds addObject:[item copy]];
        NSLog(@"parsing started in did End element block");
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if ([element isEqualToString:@"title"])
    {
        [title appendString:string];
    }
    else if ([element isEqualToString:@"link"])
    {
        [link appendString:string];
    }
    else if ([element isEqualToString:@"description"])
    {
        [subtitle appendString:string];
    }
    else if ([element isEqualToString:@"content:encoded"])
    {
        [previewImage appendString:string];
        //NSString *finalURL = [[NSString alloc] init];
        if ([previewImage rangeOfString:@"<img"].location != NSNotFound)
        {
            NSRange firstRange = [previewImage rangeOfString:@"src="];
            NSRange endRange = [[previewImage substringFromIndex:firstRange.location] rangeOfString:@"\" alt"];
            NSString *finalLink = [[NSString alloc] init];
            finalLink = [previewImage substringWithRange:NSMakeRange(firstRange.location, endRange.location)];
            //NSString *finalLink = [previewImage substringWithRange:NSMakeRange(firstRange.location, endRange.location)];
            NSString *match = @"src=\"";
            //NSString *match2 = @"\"";
            NSString *postMatch;
            NSScanner *scanner = [NSScanner scannerWithString:finalLink];
            [scanner scanString:match intoString:nil];
            //[scanner scanString:match2 intoString:nil];
            postMatch = [finalLink substringFromIndex:scanner.scanLocation];
            NSString *finalURL = [postMatch stringByAppendingString:@""];
            previewImage1 = finalURL;
        }
        //code to capture image
        
    }
    NSLog(@"parsing in foundCharacters block");
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"parsing started didend document in block");
    //[self.tableView reloadData];
    
    NSLog(@"Reload Complete");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [self.activityIndi stopAnimating];
        self.activityIndi.hidden = TRUE;
        [self.activityIndi removeFromSuperview];
    });
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *sendDetails = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"viewDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
        NSInteger row = indexPath.row;
        // code to remove unwanted characters....
        NSString *data= [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        sendDetails.rssfeeds = [feeds copy];
        sendDetails.selected = row;
        sendDetails.url = data;
    }
}


-(NSString *)stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end


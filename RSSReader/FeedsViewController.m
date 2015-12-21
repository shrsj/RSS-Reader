//
//  FeedsViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 11/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "FeedsViewController.h"
#import "DetailViewController.h"

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
    
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:self.url];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
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
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    // cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // cell.textLabel.frame = CGRectMake(200, 5, 375, 25);
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    
    NSString *normalSubtitle = [[feeds objectAtIndex:indexPath.row] objectForKey:@"description"];
    NSString *data= [normalSubtitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //cell.detailTextLabel.frame= CGRectMake(200, 35, 375, 35);
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.text = data;
    
    NSString *linked = [[feeds objectAtIndex:indexPath.row] objectForKey:@"content:encoded"];
    NSURL *iurl = [NSURL URLWithString:linked];
    
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:iurl]];
    
    //cell.imageView.frame = CGRectMake(15, 5, 135, 50);
    if (cell.imageView.image == nil)
    {
        cell.imageView.image = [UIImage imageNamed:@"no image"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *details = [[DetailViewController alloc] init];
    details.url = [feeds[indexPath.row] objectForKey:@"link"];
    NSLog(@"%@ %ld",[feeds[indexPath.row] objectForKey:@"link"],(long)indexPath.row);
    [self performSegueWithIdentifier:@"viewDetail" sender:self];
    
}

#pragma mark delegate methods

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
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
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
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
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


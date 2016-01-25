
//  FeedsViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 11/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "FeedsViewController.h"
#import "DetailViewController.h"
#import "FeedsTableViewCell.h"

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
    NSMutableAttributedString *subtitle;
    NSOperationQueue* aQueue;
    
    BOOL parseStatus;
    NSTimer *timeout;
}
@end

@implementation FeedsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageCache = [[NSCache alloc] init];
    feeds = [[NSMutableArray alloc] init];
    timeout = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(cancelParsing) userInfo:nil repeats:YES];
    [self loadfeeds];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [aQueue cancelAllOperations];
}

-(void)loadfeeds
{
    aQueue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init]; // create operation
    __weak NSBlockOperation *weakOperation = operation;             // avoiding reference cycle
    
    [operation addExecutionBlock:^{
        
        [self.activityIndi startAnimating];
        NSURL *url = [NSURL URLWithString:self.url];
        if ([weakOperation isCancelled]) {
            return;
        }
        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        if ([weakOperation isCancelled]) {
            return;
        }
        parseStatus = [parser parse];
    }];
    
    [aQueue addOperation:operation];
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
    FeedsTableViewCell *cell = [[FeedsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    
    NSAttributedString *normalSubtitle = [[feeds objectAtIndex:indexPath.row] objectForKey:@"description"];
    // NSString *data= [normalSubtitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.detailTextLabel.numberOfLines = 3;
    //NSAttributedString *content = [self convertHtmlToAttributedText:data];
    cell.detailTextLabel.attributedText = normalSubtitle;
    
    NSString *linked = [[feeds objectAtIndex:indexPath.row] objectForKey:@"image"];
    NSURL *iurl = [NSURL URLWithString:linked];
    [cell.imageView sd_setImageWithURL:iurl placeholderImage:[UIImage imageNamed:@"no image"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *details = [[DetailViewController alloc] init];
    details.url = [feeds[indexPath.row] objectForKey:@"link"];
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
        subtitle = [[NSMutableAttributedString alloc] init];
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
        [item setObject:previewImage1 forKey:@"image"];
        [feeds addObject:[item copy]];
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
        if ([string rangeOfString:@"\u2026<p>"].location != NSNotFound)
        {
            NSRange endRange = [[string substringFromIndex:0] rangeOfString:@"\u2026<p>"];
            NSString *finalString = [string substringWithRange:NSMakeRange(0, endRange.location)];
            [subtitle appendAttributedString:[self convertHtmlToAttributedText:finalString]];
        }
        else
        {
            [subtitle appendAttributedString:[self convertHtmlToAttributedText:string]];
        }
        
    }
    else if ([element isEqualToString:@"content:encoded"])
    {
        [previewImage appendString:string];
        if ([previewImage rangeOfString:@"<img"].location != NSNotFound)
        {
            NSRange firstRange = [previewImage rangeOfString:@"src="];
            NSRange endRange = [[previewImage substringFromIndex:firstRange.location] rangeOfString:@"\" alt"];
            NSString *finalLink = [[NSString alloc] init];
            finalLink = [previewImage substringWithRange:NSMakeRange(firstRange.location, endRange.location)];
            NSString *match = @"src=\"";
            NSString *postMatch;
            NSScanner *scanner = [NSScanner scannerWithString:finalLink];
            [scanner scanString:match intoString:nil];
            postMatch = [finalLink substringFromIndex:scanner.scanLocation];
            NSString *finalURL = [postMatch stringByAppendingString:@""];
            previewImage1 = finalURL;
        }
        //code to capture image
        
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
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

#pragma mark String Functions

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

-(void)cancelParsing
{
    if (parseStatus)
    {
        NSLog(@"parser is working");
    }
    else
    {
        [aQueue cancelAllOperations];
        [parser abortParsing];
        [self displayAlert:@"The Website is Not Responding \n Do You want to go back??"];
    }
}


-(void)displayAlert:(NSString *)msg
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"RSS Feeds"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self.navigationController popToRootViewControllerAnimated:YES];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/*
 -(NSString *)stringByStrippingHTML {
 NSRange r;
 NSString *s = [self copy];
 while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
 s = [s stringByReplacingCharactersInRange:r withString:@""];
 return s;
 }
 */

/*********** Direct implementation of NSOperation Queues without cancel operation
 
 [aQueue addOperationWithBlock:^{
 [self.activityIndi startAnimating];
 // NSLog(@"Beginning operation.\n");
 // Do some work.
 NSURL *url = [NSURL URLWithString:self.url];
 parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
 [parser setDelegate:self];
 [parser setShouldResolveExternalEntities:NO];
 [parser parse];
 }];
 
 ************/

/******* method to cancel threads when timeout ********
 
 - (NSOperation *)AaddOperationWithBlock:(void (^)(NSBlockOperation *operation))block timeout:(CGFloat)timeout timeoutBlock:(void (^)(void))timeoutBlock
 {
 NSBlockOperation *blockOperation = [[NSBlockOperation alloc] init];  // create operation
 NSBlockOperation __weak *weakOperation = blockOperation;             // prevent strong reference cycle
 
 // add call to caller's provided block, passing it a reference to this `operation`
 // so the caller can check to see if the operation was canceled (i.e. if it timed out)
 
 [blockOperation addExecutionBlock:^{
 block(weakOperation);
 }];
 
 // add the operation to this queue
 
 [aQueue addOperation:blockOperation];
 
 // if unfinished after `timeout`, cancel it and call `timeoutBlock`
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 // if still in existence, and unfinished, then cancel it and call `timeoutBlock`
 
 if (weakOperation && ![weakOperation isFinished]) {
 [weakOperation cancel];
 if (timeoutBlock) {
 timeoutBlock();
 }
 }
 });
 
 return blockOperation;
 }
 
 ************/

@end


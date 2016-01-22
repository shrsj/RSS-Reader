//
//  rssCollectionViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 06/01/16.
//  Copyright © 2016 Mac-Mini-2. All rights reserved.
//

#import "rssCollectionViewController.h"
#import "rssCollectionViewCell.h"
#import "FeedsViewController.h"
#import "SubmitViewController.h"
#import "ContactViewController.h"

@interface rssCollectionViewController ()
{
    NSArray *feedTypes, *feedLinks, *fillImages;
}
@end

@implementation rssCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    feedTypes = @[@"News" ,@"Sports" ,@"Birthday" ,@"Obit" ,@"Contact Us",@"Submit Story"];
    fillImages = @[@"NewsFill",@"SportsFill" ,@"BirthdayFill" ,@"ObitFill" ,@"Contact UsFill",@"Submit StoryFill"];
    feedLinks = @[@"http://www.ozarkareanetwork.com/category/app-feed/feed/rss2", @"http://www.ozarkareanetwork.com/category/sports/feed/rss2", @"http://www.ozarkareanetwork.com/category/birthdays-anniversaries/feed/rss2",@"http://www.ozarkareanetwork.com/category/obits/feed/rss2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of items
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    rssCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.feedLabel.text = [feedTypes objectAtIndex:[indexPath row]];
    cell.feedSymbol.image = [UIImage imageNamed:[feedTypes objectAtIndex:[indexPath row]]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self setHighlighted:YES :indexPath];  //change icon on select...
    if ([indexPath row] < 4)
    {
        FeedsViewController *feeds = [self.storyboard instantiateViewControllerWithIdentifier:@"feeds"];
        feeds.url = [feedLinks objectAtIndex:[indexPath row]];
        [self.navigationController showViewController:feeds sender:self];
    }
    else if([indexPath row] == 4)
    {
        ContactViewController *contactUs = [self.storyboard instantiateViewControllerWithIdentifier:@"contact"];
        [self.navigationController showViewController:contactUs sender:self];
    }
    else
    {
        SubmitViewController *submit = [self.storyboard instantiateViewControllerWithIdentifier:@"submit"];
        [self.navigationController showViewController:submit sender:self];
    }
    [self setHighlighted:YES :indexPath];
    [collectionView reloadData];
}


// .....to be continued....
-(void)setHighlighted:(BOOL)highlighted
                     :(NSIndexPath*)selectedPath
{
    rssCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:selectedPath];
    if (highlighted)    // To change the icon when a cell is selected
    {
        cell.feedSymbol.image = [UIImage imageNamed:[fillImages objectAtIndex:[selectedPath row]]];
    }
    else   // if cell is not selected icon reverts back/or remains the same.
    {
        cell.feedLabel.text = [feedTypes objectAtIndex:[selectedPath row]];
        cell.feedSymbol.image = [UIImage imageNamed:[feedTypes objectAtIndex:[selectedPath row]]];
    }
}


@end

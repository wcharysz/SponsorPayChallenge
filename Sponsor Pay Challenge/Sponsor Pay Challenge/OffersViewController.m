//
//  OffersViewController.m
//  test app
//
//  Created by User  on 21.02.2014.
//  Copyright (c) 2014 Wojciech Charysz. All rights reserved.
//

#import "OffersViewController.h"
#import "TableCell.h"
#import "OfferItem.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface OffersViewController ()

@end

@implementation OffersViewController
@synthesize offersTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cellIdentifier = @"OfferCell";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil offersPages:(Pages *)offers {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cellIdentifier = @"OfferCell";
        pagesWithOffers = offers;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Use TableCell and it's xib layout for cells in table
    UINib *tableCellNib = [UINib nibWithNibName:@"TableCell" bundle:[NSBundle mainBundle]];
    [self.offersTableView registerNib:tableCellNib forCellReuseIdentifier:cellIdentifier];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //Gives row numbers equal to number of downloaded offers list

    return [pagesWithOffers.offerItemsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Use the height defined in the TableCell.xib
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell.bounds.size.height;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(TableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Populate cell elements with content from data models
    [cell.offerTitleLabel setText:[(OfferItem *)[pagesWithOffers.offerItemsArray objectAtIndex:indexPath.row] offerTitle]];
    [cell.teaserLabel setText:[(OfferItem *)[pagesWithOffers.offerItemsArray objectAtIndex:indexPath.row] offerTeaser]];
    [cell.payoutLabel setText:[(OfferItem *)[pagesWithOffers.offerItemsArray objectAtIndex:indexPath.row] offerPayout]];
    
    //We use here SDWebImage framework to load and cache offer thumbnails
    NSURL *thumbnailURL = [NSURL URLWithString:[(OfferItem *)[pagesWithOffers.offerItemsArray objectAtIndex:indexPath.row] thumbnailHiResLink]];
    [cell.thumbnailImageView setImageWithURL:thumbnailURL placeholderImage:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Use TableCell and it's layout for cells.
    TableCell *oneCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return oneCell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //TODO: Maybe we could launch offer link
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

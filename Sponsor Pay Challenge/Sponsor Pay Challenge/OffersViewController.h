//
//  OffersViewController.h
//  test app
//
//  Created by User  on 21.02.2014.
//  Copyright (c) 2014 Wojciech Charysz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pages.h"

@interface OffersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  
    NSString *cellIdentifier;
    Pages *pagesWithOffers;
}


@property (strong, nonatomic) IBOutlet UITableView *offersTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil offersPages:(Pages *)offers;

@end

//
//  TableCell.h
//  test app
//
//  Created by User  on 21.02.2014.
//  Copyright (c) 2014 Wojciech Charysz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *offerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teaserLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *payoutLabel;

@end

//
//  TableCell.m
//  test app
//
//  Created by User  on 21.02.2014.
//  Copyright (c) 2014 Wojciech Charysz. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell
@synthesize offerTitleLabel;
@synthesize teaserLabel;
@synthesize thumbnailImageView;
@synthesize payoutLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

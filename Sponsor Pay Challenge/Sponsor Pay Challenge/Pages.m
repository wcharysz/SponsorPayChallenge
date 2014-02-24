//
//  Pages.m
//  test app
//
//  Created by User  on 21.02.2014.
//  Copyright (c) 2014 Wojciech Charysz. All rights reserved.
//

#import "Pages.h"

@implementation Pages
@synthesize offerItemsArray;

-(id)init {
    if(self = [super init]) {
        self.offerItemsArray = [NSMutableArray new];
    }
    return self;
}

@end

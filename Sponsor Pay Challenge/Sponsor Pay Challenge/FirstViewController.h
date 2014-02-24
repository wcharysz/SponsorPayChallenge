//
//  FirstViewController.h
//  Sponsor Pay Challenge
//
//  Created by User  on 06.02.2014.
//  Copyright (c) 2014 Wojciech Charysz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedUtils.h"


@interface FirstViewController : UIViewController  {
    SharedUtils *sharedUtils;
}

@property (strong, nonatomic) IBOutlet UITextField *userIDTextField;
@property (strong, nonatomic) IBOutlet UITextField *apiKeyTextField;
@property (strong, nonatomic) IBOutlet UITextField *appiIDTextField;
@property (strong, nonatomic) IBOutlet UITextField *customParametersTextField;

-(IBAction)getOffers:(id)sender;


@end

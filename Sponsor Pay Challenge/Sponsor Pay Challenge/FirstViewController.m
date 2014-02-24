//
//  FirstViewController.m
//  Sponsor Pay Challenge
//
//  Created by User  on 06.02.2014.
//  Copyright (c) 2014 Wojciech Charysz. All rights reserved.
//

#import "FirstViewController.h"
#import "OffersViewController.h"
#import "Pages.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize userIDTextField;
@synthesize appiIDTextField;
@synthesize apiKeyTextField;
@synthesize customParametersTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sharedUtils = [SharedUtils sharedUtils];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"%@",[sharedUtils deviceIP]);
}

-(IBAction)getOffers:(id)sender {
    
    //Check if we already have device IP
    if (sharedUtils.deviceIP == nil) {
        
        [sharedUtils findDeviceIPwithBlock:^(NSString *ipAddress) {
            sharedUtils.deviceIP = ipAddress;
        }];
    }
    
    //Get offers from Sponsor Pay web service
    [sharedUtils prepareOffersWithUserID:self.userIDTextField.text apiKey:self.apiKeyTextField.text appiID:self.appiIDTextField.text customParameter:self.customParametersTextField.text withBlock:^(NSDictionary *jsonInNSDictionary){
    
        //NSLog(@"jsonInNSDictionary: %@",jsonInNSDictionary);
        Pages *pagesWithOffers = [sharedUtils createPage:jsonInNSDictionary];
        //Pages *pagesWithOffers = [sharedUtils createPage:[self loadSampleJSON]];
    
        [self showOffersView:pagesWithOffers];
        
    }];
    
}

-(void)showOffersView:(Pages *)offers {
    
    if (offers == nil) {
        
        //if we have no offers to display, we show message
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"No offers!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        
    } else {
        //We have some offers to show, so we push a view with them
        OffersViewController *offersViewController = [[OffersViewController alloc] initWithNibName:@"OffersViewController" bundle:nil offersPages:offers];
        [[self navigationController] pushViewController:offersViewController animated:YES];
    }
    
}

//Used only for test purposes
-(NSDictionary *)loadSampleJSON {
    
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"testsponsorpay" ofType:@"json"];
    
    NSData *jsonToParse = [NSData dataWithContentsOfFile:jsonFilePath];
    
    NSError *error;
    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:jsonToParse options:kNilOptions error:&error];
        
    return parsedJSON;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

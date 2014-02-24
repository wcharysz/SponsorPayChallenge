//
//  Sponsor_Pay_ChallengeTests.m
//  Sponsor Pay ChallengeTests
//
//  Created by User  on 06.02.2014.
//  Copyright (c) 2014 Wojciech Charysz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FirstViewController.h"
#import "OffersViewController.h"
#import "SharedUtils.h"
#import "Pages.h"

@interface Sponsor_Pay_ChallengeTests : XCTestCase {
    FirstViewController *firstViewController;
    OffersViewController *offersViewController;
}

@end

@implementation Sponsor_Pay_ChallengeTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    firstViewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

-(void)testPrepareOffers {
    
    [[SharedUtils sharedUtils] prepareOffersWithUserID:firstViewController.userIDTextField.text apiKey:firstViewController.apiKeyTextField.text appiID:firstViewController.appiIDTextField.text customParameter:firstViewController.customParametersTextField.text withBlock:^(NSDictionary *jsonInNSDictionary){
    
    
        XCTAssertNotNil(jsonInNSDictionary, @"JSON is nil");
        
    }];
    
    
}

-(void)testGetOffersButtonAction {
    
    
    UIButton *sampleButton = [[UIButton alloc] init];


    XCTAssertNoThrow([firstViewController getOffers:sampleButton], @"getOffers throws exception");
}

-(void)testFindDeviceIP {
    
    [[SharedUtils sharedUtils] findDeviceIPwithBlock:^(NSString *ipAddress) {
        
        XCTAssertNotNil(ipAddress, @"ipAddress is nil");

    }];
    
}

-(void)testCreatePages {
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"testsponsorpay" ofType:@"json"];
    
    NSData *jsonToParse = [NSData dataWithContentsOfFile:jsonFilePath];
    
    NSError *error;
    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:jsonToParse options:kNilOptions error:&error];
    
    Pages *testPages = [[SharedUtils sharedUtils] createPage:parsedJSON];
    
    XCTAssertNotNil(testPages, @"testPages is nil");
    
}

-(void)testInitOffersViewController {

    Pages *testPages = [[Pages alloc] init];
    
    offersViewController = [[OffersViewController alloc] initWithNibName:@"OffersViewController" bundle:nil offersPages:testPages];
    
    XCTAssertNotNil(offersViewController, @"offersViewController is nil");
}





@end

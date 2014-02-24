//
//  SharedUtils.h
//  Sponsor Pay Challenge
//
//  Created by User  on 06.02.2014.
//  Copyright (c) 2014 Wojciech Charysz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pages.h"

@interface SharedUtils : NSObject {
    
    BOOL useSampleData;

}

@property (strong, nonatomic) NSString *deviceIP;
@property (strong, nonatomic) NSString *apiKeyString;
@property (assign, nonatomic) time_t ps_time;

+(id)sharedUtils;

//Downloading JSON from SponsorPay
-(void)prepareOffersWithUserID:(NSString *)userID apiKey:(NSString *)apiKey appiID:(NSString *)appiID customParameter:(NSString *)pub0 withBlock:(void (^)(NSDictionary *jsonData))block;
//Creates and populates data model Pages with offers from Sponsor Pay
-(Pages *)createPage:(NSDictionary *)parsedJSONObject;
-(void)findDeviceIPwithBlock:(void (^)(NSString *ipAddress))block;

@end

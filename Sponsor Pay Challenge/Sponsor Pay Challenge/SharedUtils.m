//
//  SharedUtils.m
//  Sponsor Pay Challenge
//
//  Created by User  on 06.02.2014.
//  Copyright (c) 2014 Wojciech Charysz. All rights reserved.
//

#import "SharedUtils.h"
#import <AdSupport/AdSupport.h>
#import "NSString+Hashes.h"
#import "OfferItem.h"

static SharedUtils *sharedUtils;

@implementation SharedUtils
@synthesize deviceIP;
@synthesize ps_time;
@synthesize apiKeyString;

+ (id)sharedUtils {
    
    @synchronized(self) {
		if(sharedUtils == nil)
			sharedUtils = [[super allocWithZone:NULL] init];
	}
    
	return sharedUtils;
}

+ (id)alloc {
    
	@synchronized([SharedUtils class]) {
		NSAssert(sharedUtils == nil, @"Attempted to allocate a second instance of a 'SharedUtils' singleton.");
		sharedUtils = [super alloc];
		return sharedUtils;
	}
    
	return nil;
}

-(id)init {
    if ( self = [super init] )
    {
        // Custom initialization
        
        //This will force app to use defaults values for request parameters
        useSampleData = YES;
        
        if (useSampleData) {
            self.deviceIP = @"109.235.143.113";

        } else {
            
            [self findDeviceIPwithBlock:^(NSString *ipAddress) {
                self.deviceIP = ipAddress;
            }];
            
        }
        
        
        //CAUTION: The user's game account creation date is created here artificially!
        [self creationDateOfTheUsersAccount];
    }
    return self;
}


-(void)prepareOffersWithUserID:(NSString *)userID apiKey:(NSString *)apiKey appiID:(NSString *)appiID customParameter:(NSString *)pub0 withBlock:(void (^)(NSDictionary *jsonData))block {
    
    //Parameters table to generate hashkey
    NSMutableArray *requestParameters = [NSMutableArray new];
    
    
    //Set the api key global variable
    self.apiKeyString = apiKey;
    
    
    //Build url string
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"http://api.sponsorpay.com/feed/v1/offers.json?"];
    
    [requestParameters addObject:[NSString stringWithFormat:@"appid=%@",appiID]];
    [requestParameters addObject:[NSString stringWithFormat:@"uid=%@",userID]];
    [requestParameters addObject:[NSString stringWithFormat:@"ip=%@",self.deviceIP]];
    [requestParameters addObject:[NSString stringWithFormat:@"locale=%@",[[self getLocalLanguage] lowercaseString]]];
    
    
    
    if (useSampleData) {
        NSString *deviceID = @"2b6f0cc904d137be2e1730235f5664094b831186";
        [requestParameters addObject:[[NSString stringWithFormat:@"device_id=%@",deviceID] lowercaseString]];
    } else {
        [requestParameters addObject:@"apple_idfa_tracking_enabled=true"];
        
        NSString *apple_idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [requestParameters addObject:[NSString stringWithFormat:@"apple_idfa=%@",apple_idfa]];
        
        [requestParameters addObject:[NSString stringWithFormat:@"ps_time=%ld",self.ps_time]];

    }

    
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(time_t)[[NSDate date] timeIntervalSince1970]];

    [requestParameters addObject:[NSString stringWithFormat:@"pub0=%@",pub0]];
    [requestParameters addObject:[NSString stringWithFormat:@"timestamp=%@",timeStamp]];

    //CAUTION: offer type and page is currently fixed!
    NSString *offerType = @"112";
    [requestParameters addObject:[NSString stringWithFormat:@"offer_types=%@",offerType]];
    NSString *pageNumber = @"1";
    [requestParameters addObject:[NSString stringWithFormat:@"page=%@",pageNumber]];
    
    
  
    
    for (NSString *parameter in requestParameters) {
        [urlString appendString:(parameter == nil ? @"" : parameter)];
        [urlString appendString:@"&"];
    }
    
    NSString *generatedHashKey = [self hashKeyCalculation:requestParameters];
    
    [urlString appendString:@"hashkey="];
    [urlString appendString:(generatedHashKey == nil ? @"" : generatedHashKey)];

    
    //NSLog(@"urlString: %@",urlString);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    
    
    //We make asynchronous connection so the UI is not blocked during the request
    
    [self makeAsynchronousRequest:request withBlock:^(NSData *jsonData, NSDictionary *httpHeaderFields){
        
        
        if ([self isResponseReal:httpHeaderFields parsedJSON:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]]) {
            
            //Get the offers from response JSON
            NSError *parsingError;
            NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&parsingError];
            block(parsedJSON);
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Fake response. Signatures mismatch!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        }
    
    }];
    

    
}

-(Pages *)createPage:(NSDictionary *)parsedJSONObject {
    
    //We make here data object with offers
    Pages *onePage = [[Pages alloc] init];
    
    //Get the offer details from JSON
    NSArray *offerItems = [self makeArrayOfOfferItems:parsedJSONObject];
    
    if (offerItems != nil) {
        
        [onePage.offerItemsArray addObjectsFromArray:offerItems];
        return onePage;
    } else {
        return nil;
    }
}

-(NSArray *)makeArrayOfOfferItems:(NSDictionary *)parsedJSONObject {
    
    NSMutableArray *newPage = [NSMutableArray new];
    
    //JSON parsing to extract offer details
    
    if ([[parsedJSONObject objectForKey:@"code"] isEqualToString:@"OK"]) {
        
        NSDictionary *offers = [parsedJSONObject objectForKey:@"offers"];
        
        
        for (id eachObject in offers) {
            
            OfferItem *oneOffer = [[OfferItem alloc] init];
            
            if ([eachObject objectForKey:@"title"]) {
                oneOffer.offerTitle = [eachObject objectForKey:@"title"];
            }
            
            if ([eachObject objectForKey:@"teaser"]) {
                oneOffer.offerTeaser = [eachObject objectForKey:@"teaser"];
            }
            
            if ([eachObject objectForKey:@"payout"]) {
                oneOffer.offerPayout = [eachObject objectForKey:@"payout"];
            }
            
            if ([[eachObject objectForKey:@"thumbnail"] objectForKey:@"hires"]) {
                oneOffer.thumbnailHiResLink = [[eachObject objectForKey:@"thumbnail"] objectForKey:@"hires"];
            }
            
            [newPage addObject:oneOffer];
        }
        
        return newPage;
        
    } else {
        return nil;
    }
}




-(NSString *)hashKeyCalculation:(NSMutableArray *)requestParameters  {

    NSMutableString *hashKey = [[NSMutableString alloc] init];
    
    //Sort the parameters alphabetically
    [requestParameters sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *parameter in requestParameters) {
        [hashKey appendString:(parameter == nil ? @"" : [parameter lowercaseString])];
        [hashKey appendString:@"&"];
    }
    
    
    //Concatenate the resulting string with the API Key
    [hashKey appendString:(self.apiKeyString == nil ? @"" : self.apiKeyString)];
    
    
    //Hash the resulting string using SHA1
    return  [hashKey sha1];
}

-(BOOL)isResponseReal:(NSDictionary *)httpHeaders parsedJSON:(NSString *)jsonData{
    
    //Check the signatures from web service response and our request
    
    NSString *responseSignature = [httpHeaders objectForKey:@"X-Sponsorpay-Response-Signature"];
    
    NSString *prepareHashKey = [jsonData stringByAppendingString:self.apiKeyString];
    
    NSString *hashKey = [prepareHashKey sha1];
    
    if ([responseSignature isEqualToString:hashKey]) {
        return YES;
    } else {
        return NO;
    }
    
    
}

-(void)creationDateOfTheUsersAccount {
    
    //TODO: This should be related to actual user account creation
    self.ps_time = (time_t)[[NSDate date] timeIntervalSince1970];
}


-(NSString *)getLocalLanguage {
    
    
    if (useSampleData) {
        return @"DE";
    } else {
        return [[NSLocale preferredLanguages] firstObject];
    }
}

-(void)findDeviceIPwithBlock:(void (^)(NSString *ipAddress))block {


    //We use ip-api.com to find out what is actual device IP
    NSString *serviceURL = @"http://ip-api.com/json";
    NSMutableURLRequest *requestForIP = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:serviceURL]];
    [requestForIP setHTTPMethod:@"GET"];
    [requestForIP setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [self makeAsynchronousRequestForJSON:requestForIP withBlock:^(NSArray *jsonInNSArray){
        
        NSString *foundIP = [jsonInNSArray valueForKey:@"query"];
        block(foundIP);
    }];

}

 
-(void)makeAsynchronousRequest:(NSMutableURLRequest *)request withBlock:(void (^)(NSData *jsonData, NSDictionary *httpHeaderFields))block {
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        //Check if we get data and web service replies OK
        if ([data length] >0 && error == nil && [(NSHTTPURLResponse *)response statusCode] == 200)
        {
            block(data, [(NSHTTPURLResponse *)response allHeaderFields]);
        } else if (error != nil) {
            NSLog(@"Status code: %ld",(long)[(NSHTTPURLResponse *)response statusCode]);
            NSLog(@"Request Error: %@",[error localizedDescription]);
            [[[UIAlertView alloc] initWithTitle:@"Request Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Problem" message:@"Can't get to web service" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}


-(void)makeAsynchronousRequestForJSON:(NSMutableURLRequest *)request withBlock:(void (^)(NSArray *jsonData))block {
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
    
        //Check if we get data and web service replies OK
        if ([data length] >0 && error == nil && [(NSHTTPURLResponse *)response statusCode] == 200)
        {
            NSError *parsingError;
            NSArray *parsedJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parsingError];
            //NSLog(@"%@",[(NSHTTPURLResponse *)response allHeaderFields]);
            block(parsedJSON);
        } else if (error != nil) {
            NSLog(@"Status code: %ld",(long)[(NSHTTPURLResponse *)response statusCode]);
            NSLog(@"Request Error: %@",[error localizedDescription]);
            [[[UIAlertView alloc] initWithTitle:@"Request Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Problem" message:@"Can't get to web service" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}


@end

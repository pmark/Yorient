//
//  YahooLocalSearch.m
//
//  Created by P. Mark Anderson on 12/18/09.
//  Copyright 2009 Spot Metrix. All rights reserved.
//

#import "YahooLocalSearch.h"
#import "SM3DAR.h"
#import "NSDictionary+BSJSONAdditions.h"

#define MAX_SEARCH_RESULT_COUNT 20

@implementation YahooLocalSearch

@synthesize webData;
@synthesize query;
@synthesize delegate;
@synthesize location;

- (void)dealloc 
{
    [webData release];
    [query release];
    [location release];
	[super dealloc];
}

- (id) initAtLocation:(CLLocation *)searchLocation
{
    if (self = [super init])
    {
        self.location = searchLocation;
    }
    
    return self;    
}


- (void)execute:(NSString*)searchQuery 
{
    
    NSLog(@"[YLS] ");
    
    self.query = searchQuery;
    
    NSLog(@"Executing search for '%@' at current location: %@", searchQuery, location);
    
	NSString *yahooMapUri = @"http://local.yahooapis.com/LocalSearchService/V3/localSearch?appid=YahooDemo&query=%@&latitude=%3.5f&longitude=%3.5f&results=%i&output=json";
	
    NSString *uri = [NSString stringWithFormat:yahooMapUri, 
                     [searchQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
                     location.coordinate.latitude, 
                     location.coordinate.longitude,
                     MAX_SEARCH_RESULT_COUNT];
    
	NSLog(@"Searching...\n%@\n", uri);
	NSURL *mapSearchURL = [NSURL URLWithString:uri];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:mapSearchURL] delegate:self startImmediately:YES];
    
	if (conn) 
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		self.webData = [NSMutableData data];
	} 
    else 
    {
		NSLog(@"ERROR: Connection was not established");
	}	
    
	[conn release];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	[self.webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[self.webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSLog(@"ERROR: Connection failed: %@", [error localizedDescription]);
}

// thank you http://json.parser.online.fr/
- (NSArray*)parseYahooMapSearchResults:(NSString*)json 
{
	NSDictionary *properties = [NSDictionary dictionaryWithJSONString:json];
	NSDictionary *container = [properties objectForKey:@"ResultSet"];	
	NSArray *responseSet = [container objectForKey:@"Result"];
	NSDictionary *minMarker;
	NSMutableArray *markers = [NSMutableArray arrayWithCapacity:[responseSet count]];
    NSMutableDictionary *merged;
    NSString *star = @"★"; // @"\U2605";
    
	for (NSDictionary *marker in responseSet) 
    {
        NSString *rating = [[marker objectForKey:@"Rating"] objectForKey:@"AverageRating"];
        CGFloat stars = [rating floatValue];
        rating = [@"" stringByPaddingToLength:stars withString:star startingAtIndex:0];
        
        CLLocationCoordinate2D coord;
        coord.latitude = [((NSDecimalNumber*)[marker objectForKey:@"Latitude"]) doubleValue];
        coord.longitude = [((NSDecimalNumber*)[marker objectForKey:@"Longitude"]) doubleValue];
        double altitude = -200.0;	
        
        CLLocation *pointLocation = [[[CLLocation alloc] initWithCoordinate:coord 
                                                                   altitude:altitude 
                                                         horizontalAccuracy:1 
                                                           verticalAccuracy:1 
                                                                  timestamp:nil] autorelease];
        
		minMarker = [NSDictionary dictionaryWithObjectsAndKeys:
                     [marker objectForKey:@"Title"], @"title",
                     rating, @"subtitle",
                     pointLocation, @"location",
                     self.query, @"search",
                     nil];
        
        //NSLog(@"marker: %@", minMarker);
        
        merged = [NSMutableDictionary dictionaryWithDictionary:marker];
        [merged addEntriesFromDictionary:minMarker];
		[markers addObject:merged];
	}
	
	return markers;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSString *response = [[NSString alloc] initWithData:self.webData encoding:NSASCIIStringEncoding];
	
    
	// Convert response JSON into a collection of point data.
    
	NSArray *results = [self parseYahooMapSearchResults:response];
    
	if (results && [results count] > 0) 
    {
	    [delegate searchDidFinishWithResults:results];
    }
    else
    {
        [delegate searchDidFinishWithEmptyResults];
    }
}


@end

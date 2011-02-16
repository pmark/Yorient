//
//  YahooLocalSearch.m
//
//  Created by P. Mark Anderson on 12/18/09.
//  Copyright 2009 Spot Metrix. All rights reserved.
//

#import "YahooLocalSearch.h"
#import "NSArray+BSJSONAdditions.h"
#import "NSString+BSJSONAdditions.h"
#import "UIApplication_TLCommon.h"
#import "SM3DAR.h"
#import "Constants.h"

#define MAX_SEARCH_RESULT_COUNT 10

@implementation YahooLocalSearch

@synthesize webData;
@synthesize query;
@synthesize delegate;

- (void)dealloc 
{
    [webData release];
    [query release];
	[super dealloc];
}


- (void)execute:(NSString*)searchQuery 
{
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
    
    self.query = searchQuery;
	CLLocation *loc = [sm3dar currentLocation];
    NSLog(@"Executing search for '%@' at current location: %@", searchQuery, loc);
    
	NSString *yahooMapUri = @"http://local.yahooapis.com/LocalSearchService/V3/localSearch?appid=YahooDemo&query=%@&latitude=%3.5f&longitude=%3.5f&results=%i&output=json";
	
    NSString *uri = [NSString stringWithFormat:yahooMapUri, 
                     [searchQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
                     loc.coordinate.latitude, 
                     loc.coordinate.longitude,
                     MAX_SEARCH_RESULT_COUNT];

	NSLog(@"Searching...\n%@\n", uri);
	NSURL *mapSearchURL = [NSURL URLWithString:uri];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:mapSearchURL] delegate:self startImmediately:YES];
    
	if (conn) 
    {
        [[UIApplication sharedApplication] didStartNetworkRequest];
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
    [[UIApplication sharedApplication] didStopNetworkRequest];
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
        //NSLog(@"stars: %f, rating: %@", stars, rating);
        
		minMarker = [NSDictionary dictionaryWithObjectsAndKeys:
                     [marker objectForKey:@"Title"], @"title",
                     rating, @"subtitle",
                     [marker objectForKey:@"Latitude"], @"latitude",
                     [marker objectForKey:@"Longitude"], @"longitude",
                     [NSString stringWithFormat:@"%.0f", BUBBLE_ALTITUDE_METERS], @"altitude",
                     self.query, @"search",
                     
                     // you can set the marker's view class right here
                     //@"BubbleMarkerView", @"view_class_name",
                     
                     nil];
        
        merged = [NSMutableDictionary dictionaryWithDictionary:marker];
        [merged addEntriesFromDictionary:minMarker];
		[markers addObject:merged];
	}
	
	return markers;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    [[UIApplication sharedApplication] didStopNetworkRequest];
	NSString *response = [[NSString alloc] initWithData:self.webData encoding:NSASCIIStringEncoding];
	
	// convert response json into a collection of markers
	NSArray *markers = [self parseYahooMapSearchResults:response];
    
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
	
	NSLog(@"Adding %i POIs", [markers count]);
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:[markers count]];
    
	if (markers && [markers count] > 0) 
    {
        NSInteger markerCount = 0;
        
        for (NSDictionary *row in markers) 
        {
            if (markerCount++ >= MAX_SEARCH_RESULT_COUNT)
                break;

            //////
            SM3DAR_PointOfInterest *poi = [sm3dar initPointOfInterest:row];
            poi.canReceiveFocus = YES;
            [points addObject:poi];
            //////
        }
        
        [sm3dar addPointsOfInterest:points];

	    [delegate searchDidFinishWithResults];
    }
    else
    {
        [delegate searchDidFinishWithEmptyResults];
    }
    
    [sm3dar zoomMapToFit];
}


@end

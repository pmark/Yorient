//
//  FlipsideViewController.m
//  SM3DAR_Viewer
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Bordertown Labs, LLC 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"
#import "NSArray+BSJSONAdditions.h"
#import "NSString+BSJSONAdditions.h"

@implementation FlipsideViewController

@synthesize delegate, webData, searchBar;


- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}

- (void)runSearch {
	((MainViewController*)self.delegate).searchQuery = self.searchBar.text;
	
	if (self.searchBar.text == nil) {
		NSLog(@"TODO: load markers.json");
	} else {
		[self localSearch:self.searchBar.text];	
	}
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (IBAction)done {
	[self runSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)bar {
	[bar resignFirstResponder];
	NSLog(@"canceling search");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)bar {
	[self runSearch];
}

- (SM3DAR_Controller*)get3darController {
	return ((MainViewController*)self.delegate).arController;
}

- (void)localSearch:(NSString*)query {

	SM3DAR_Controller *arController = [self get3darController];
	CLLocation *loc = [arController currentLocation];

	//NSString *googleMapUri = @"http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=%@&sll=%3.5f,%3.5f&spn=0.038852,0.077162&ie=UTF8&z=12&output=json";
	NSString *yahooMapUri = @"http://local.yahooapis.com/LocalSearchService/V3/localSearch?appid=YahooDemo&query=%@&latitude=%3.5f&longitude=%3.5f&results=20&output=json";

	NSString *uri = [NSString stringWithFormat:yahooMapUri, 
									 query, loc.coordinate.latitude, loc.coordinate.longitude];
	NSLog(@"Searching...\n\n%@\n\n", uri);
	NSURL *mapSearchURL = [NSURL URLWithString:uri];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:mapSearchURL] delegate:self startImmediately:YES];

	if (conn) {
		self.webData = [NSMutableData data];
	} else {
		NSLog(@"ERROR: Connection was not established");
	}	
	[conn release];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"ERROR: Connection failed: %@", [error localizedDescription]);
}

// thank you http://json.parser.online.fr/
- (NSArray*)parseYahooMapSearchResults:(NSString*)json {
	NSDictionary *responseDict = [NSDictionary dictionaryWithJSONString:json];	
	NSDictionary *container = [responseDict objectForKey:@"ResultSet"];	
	NSArray *responseSet = [container objectForKey:@"Result"];
	NSLog(@"Map query found %i points of interest", [responseSet count]);

	NSDictionary *marker, *minMarker;
	NSMutableArray *markers = [NSMutableArray arrayWithCapacity:[responseSet count]];

	for (marker in responseSet) {
		//NSLog(@"result: %@", marker);
		minMarker = [NSDictionary dictionaryWithObjectsAndKeys:
							[marker objectForKey:@"Title"], @"title",
							[marker objectForKey:@"Address"], @"subtitle",
							[marker objectForKey:@"Latitude"], @"latitude",
							[marker objectForKey:@"Longitude"], @"longitude",
							nil];
		[markers addObject:minMarker];
	}
	
	return markers;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"Received bytes: %d", [self.webData length]);
	NSString *response = [[NSString alloc] initWithData:self.webData encoding:NSASCIIStringEncoding];
	//NSLog(@"RESPONSE:\n\n%@", response);	
	
	// convert response json into a collection of markers
	NSArray *markers = [self parseYahooMapSearchResults:response];
	SM3DAR_Controller *arController = [self get3darController];
	[arController removeAllPointsOfInterest];
	[arController loadMarkersFromJSON:[markers jsonStringValue]];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.searchBar.text = ((MainViewController*)self.delegate).searchQuery;
}


- (void)dealloc {
	[webData release];
	[searchBar release];
	[super dealloc];
}


@end

//
//  MainViewController.m
//  SM3DARViewer
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Bordertown Labs, LLC 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import <MapKit/MapKit.h>
//#import "BSJSONEncoder.h"
#import "NSArray+BSJSONAdditions.h"

#define INFO_BUTTON_TAG 99877

@implementation MainViewController

@synthesize arController, infoButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
			// Custom initialization
    }
    return self;
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    

	[self.arController toggleMap];
	[self performSelector:@selector(showInfoButton) withObject:self afterDelay:2];

}

- (void)showFlipside {
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];	
	[controller release];
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

- (void)dealloc {
	[arController release];
	[infoButton release];
	[super dealloc];
}

#pragma mark -

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	ThreeDARController *ar = [[ThreeDARController alloc] init];
	[self.view addSubview:ar.view];
	self.arController = ar;
	ar.delegate = self;
	[ar release];	
	
	[self performSelector:@selector(showInfoButton) withObject:self afterDelay:4];
}

- (void)showInfoButton {
	[self.view bringSubviewToFront:[self.view viewWithTag:INFO_BUTTON_TAG]];
}


#pragma mark Data loading
-(NSString*)loadJSONFromFile:(NSString*)fileName {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
	NSString *json = nil;
	if (filePath) {
		json = [NSString stringWithContentsOfFile:filePath usedEncoding:NULL error:NULL];
	} else {
		NSLog(@"JSON file does not exist: %@", fileName);
	}
	return json;
}

-(NSArray*)loadData {
	NSString *jsonString = [self loadJSONFromFile:@"markers"];
	NSLog(@"JSON: %@", jsonString);
	return [NSArray arrayWithJSONString:jsonString];
}

-(void)loadPointsOfInterest {
	ThreeDARPointOfInterest *poi;
	NSArray *markers = [self loadData];
	CLLocation *loc;
	NSDate *now = [NSDate date];
	CLLocationCoordinate2D coord;
	double alt;
	NSString *title;
	
	for (NSDictionary *row in markers) {	
		coord.latitude = [((NSDecimalNumber*)[row objectForKey:@"latitude"]) floatValue];
		coord.longitude = [((NSDecimalNumber*)[row objectForKey:@"longitude"]) floatValue];
		alt = [((NSDecimalNumber*)[row objectForKey:@"altitude"]) floatValue];
		title = [row objectForKey:@"title"];
		loc = [[CLLocation alloc] initWithCoordinate:coord altitude:alt horizontalAccuracy:1 verticalAccuracy:1 timestamp:now];
		poi = [[ThreeDARPointOfInterest alloc] initWithLocation:loc title:title subtitle:nil url:nil];
		[self.arController addPointOfInterest:poi];
		[poi release];
	}
}



@end

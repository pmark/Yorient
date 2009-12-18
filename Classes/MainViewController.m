//
//  MainViewController.m
//  SM3DAR_Viewer
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Bordertown Labs, LLC 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import <MapKit/MapKit.h>
#import "NSArray+BSJSONAdditions.h"

#define INFO_BUTTON_TAG 99877

@implementation MainViewController

@synthesize sm3dar, infoButton, searchQuery, search;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)alignInfoButtonWith3darLogo {
	CGRect logoFrame = [self.sm3dar logoFrame];
	CGPoint logoCenter = CGPointMake(logoFrame.origin.x+logoFrame.size.width/2, 
																	 logoFrame.origin.y+logoFrame.size.height/2);
	int x, y, w, h, xpad;
	w = self.infoButton.frame.size.width;
	h = self.infoButton.frame.size.height;
	xpad = logoFrame.origin.x;
	x = self.view.frame.size.width - xpad - (w/2);
	y = logoCenter.y;
	self.infoButton.center = CGPointMake(x, y);
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

  if (!sm3darInitialized) {
    [self.view addSubview:self.sm3dar.view];
    NSLog(@"Added 3DAR view");
    
    [self.sm3dar startCamera];
    
    [self initSound];
    self.search = [[[LocalSearch alloc] init] autorelease];
    self.search.sm3dar = self.sm3dar;  
    sm3darInitialized = YES;
  }  
}

- (void)viewDidLoad {
	[super viewDidLoad];

	SM3DAR_Controller *controller = [[[SM3DAR_Controller alloc] init] autorelease];
	self.sm3dar = controller;	
	controller.delegate = self;

	[self alignInfoButtonWith3darLogo];
	[self performSelector:@selector(showInfoButton) withObject:self afterDelay:4];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
  [self dismissModalViewControllerAnimated:YES];
  if (self.searchQuery == nil) {
    [self loadPointsOfInterestFromMarkersFile];
  }
  [self showInfoButton];
}

- (void)showFlipside {
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];	
	[controller release];
}

- (void)runLocalSearch:(NSString*)query {
  [self.search execute:query];
}


- (IBAction)showInfo {
	[self showFlipside];
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
	[sm3dar release];
	[infoButton release];
	[searchQuery release];
  [search release];
	[super dealloc];
}

#pragma mark -

- (void)showInfoButton {
	[self.view bringSubviewToFront:[self.view viewWithTag:INFO_BUTTON_TAG]];
}


#pragma mark Data loading
-(void)loadPointsOfInterest {
  [self runLocalSearch:@"pizza"];
}

-(void)loadPointsOfInterestFromMarkersFile {
	self.sm3dar.markerViewClass = nil;
	[self.sm3dar loadMarkersFromJSONFile:@"markers"];
}

-(void)didChangeFocusToPOI:(SM3DAR_PointOfInterest*)newPOI fromPOI:(SM3DAR_PointOfInterest*)oldPOI {
	//NSLog(@"POI acquired focus: %@", newPOI.title);
	[self playFocusSound];
}

-(void)didChangeSelectionToPOI:(SM3DAR_PointOfInterest*)newPOI fromPOI:(SM3DAR_PointOfInterest*)oldPOI {
	//NSLog(@"POI was selected: %@", newPOI.title);
}

#pragma mark Sound
- (void)initSound {
	CFBundleRef mainBundle = CFBundleGetMainBundle();
	CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR ("focus2"), CFSTR ("aif"), NULL) ;
	AudioServicesCreateSystemSoundID(soundFileURLRef, &focusSound);
}

- (void)playFocusSound {
	AudioServicesPlaySystemSound(focusSound);
} 



#pragma mark -

-(void)sm3darViewDidLoad {
}

@end

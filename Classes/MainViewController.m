//
//  MainViewController.m
//  Y!orient
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Spot Metrix, Inc 2009. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MainViewController.h"
#import "MainView.h"
#import "NSArray+BSJSONAdditions.h"
#import "BubbleMarkerView.h"

@implementation MainViewController

@synthesize searchQuery, search, flipsideController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {      
    }
    return self;
}

- (SM3DAR_Controller*) sm3dar {
	return [SM3DAR_Controller sharedSM3DAR_Controller];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
  
  SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedSM3DAR_Controller];
  if (![sm3dar.view superview]) {
    [self.view addSubview:sm3dar.view];
    [sm3dar startCamera];
  }
}

- (void)viewDidLoad {
	[super viewDidLoad];
  [self initSound];
  self.view.backgroundColor = [UIColor blackColor];

	SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedSM3DAR_Controller];
	sm3dar.delegate = self;
  sm3dar.markerViewClass = [BubbleMarkerView class];

  self.search = [[[YahooLocalSearch alloc] init] autorelease];

  FlipsideViewController *flipside = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
  flipside.delegate = self;	
  flipside.view.hidden = YES;
  [self.view addSubview:flipside.view];
  self.flipsideController = flipside;
  [flipside release];  
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
  flipsideController.view.hidden = YES;
  SM3DAR_Controller *sm3dar = [self sm3dar];
  [sm3dar resume];
  sm3dar.view.hidden = NO;
  [sm3dar resume];
}

- (void)showFlipside {
  SM3DAR_Controller *sm3dar = [self sm3dar];
  [sm3dar suspend];
  
  sm3dar.view.hidden = YES;
  [self.view bringSubviewToFront:flipsideController.view];

  CGFloat duration = 0.66f;
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionFade;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.duration = duration;
  [flipsideController.view.layer addAnimation:transition forKey:nil];

  flipsideController.view.hidden = NO;
  [flipsideController.searchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:duration];  
}

- (void)runLocalSearch:(NSString*)query {
	self.searchQuery = query;
	[[self sm3dar] removeAllPointsOfInterest];
  [self.search execute:query];
}

- (void)didReceiveMemoryWarning {
  NSLog(@"\n\ndidReceiveMemoryWarning\n\n");
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
  NSLog(@"viewDidUnload");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[searchQuery release];
  [search release];
  [flipsideController release];
	[super dealloc];
}

#pragma mark Data loading
-(void)loadPointsOfInterest {
  // 3DAR initialization is complete
  [self runLocalSearch:@"cafe"];
}

-(void)loadPointsOfInterestFromMarkersFile {
  SM3DAR_Controller *sm3dar = [self sm3dar];
	sm3dar.markerViewClass = nil;
	[sm3dar loadMarkersFromJSONFile:@"markers"];
}

-(void)didChangeFocusToPOI:(SM3DAR_PointOfInterest*)newPOI fromPOI:(SM3DAR_PointOfInterest*)oldPOI {
	//NSLog(@"POI acquired focus: %@", newPOI.title);
	[self playFocusSound];
}

-(void)didChangeSelectionToPOI:(SM3DAR_PointOfInterest*)newPOI fromPOI:(SM3DAR_PointOfInterest*)oldPOI {
	NSLog(@"POI was selected: %@", newPOI.title);
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
-(void)logoWasTapped {
  [self showFlipside];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation 
{
  [manager stopUpdatingLocation];
}

@end

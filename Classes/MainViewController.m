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

@synthesize arController, infoButton, searchQuery;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
			[self initSound];
    }
    return self;
}

- (void)alignInfoButtonWith3darLogo {
	CGRect logoFrame = [self.arController logoFrame];
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

//- (void)viewDidAppear:(BOOL)animated {
//	[super viewDidAppear:animated];
//}

- (void)viewDidLoad {
	[super viewDidLoad];

	SM3DAR_Controller *controller = [[[SM3DAR_Controller alloc] init] autorelease];
	[self.view addSubview:controller.view];
	self.arController = controller;	
	controller.delegate = self;

	[self alignInfoButtonWith3darLogo];
	[self performSelector:@selector(showInfoButton) withObject:self afterDelay:4];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
	if (self.searchQuery == nil) {
		[self loadPointsOfInterest];
	}
}

- (void)showFlipside {
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];	
	[controller release];
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
	[arController release];
	[infoButton release];
	[searchQuery release];
	[super dealloc];
}

#pragma mark -

- (void)showInfoButton {
	[self.view bringSubviewToFront:[self.view viewWithTag:INFO_BUTTON_TAG]];
}


#pragma mark Data loading
-(void)loadPointsOfInterest {
	[self.arController loadMarkersFromJSONFile:@"markers"];
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

@end

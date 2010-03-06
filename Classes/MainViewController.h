//
//  MainViewController.h
//  Y!orient
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Spot Metrix, Inc 2009. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SM3DAR.h" 
#import "FlipsideViewController.h"
#import "AudioToolbox/AudioServices.h"
#import "YahooLocalSearch.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, SM3DAR_Delegate, CLLocationManagerDelegate> {
	SystemSoundID focusSound;
	NSString *searchQuery;
  YahooLocalSearch *search;
  BOOL sm3darInitialized;
  FlipsideViewController *flipsideController;
}

@property (nonatomic, retain) NSString *searchQuery;
@property (nonatomic, retain) YahooLocalSearch *search;
@property (nonatomic, retain) FlipsideViewController *flipsideController;

- (void)loadPointsOfInterest;
- (void)initSound;
- (void)playFocusSound;
- (void)loadPointsOfInterestFromMarkersFile;
- (void)runLocalSearch:(NSString*)query;

@end

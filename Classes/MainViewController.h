//
//  MainViewController.h
//  SM3DAR_Viewer
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Bordertown Labs, LLC 2009. All rights reserved.
//

#import "SM3DAR.h" 
#import "FlipsideViewController.h"
#import "AudioToolbox/AudioServices.h"
#import "LocalSearch.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, SM3DAR_Delegate> {
	SM3DAR_Controller *sm3dar;
	IBOutlet UIButton *infoButton;
	SystemSoundID focusSound;
	NSString *searchQuery;
  LocalSearch *search;
  BOOL sm3darInitialized;
}

//@property (nonatomic, assign) BOOL sm3darInitialized;
@property (nonatomic, retain) NSString *searchQuery;
@property (nonatomic, retain) SM3DAR_Controller *sm3dar;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) LocalSearch *search;

- (IBAction)showInfo;
- (void)loadPointsOfInterest;
- (void)initSound;
- (void)playFocusSound;
- (void)loadPointsOfInterestFromMarkersFile;
- (void)showInfoButton;
- (void)runLocalSearch:(NSString*)query;

@end

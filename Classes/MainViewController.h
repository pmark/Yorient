//
//  MainViewController.h
//  Yorient
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Spot Metrix, Inc 2009. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SM3DAR.h" 
#import "FlipsideViewController.h"
#import "AudioToolbox/AudioServices.h"
#import "YahooLocalSearch.h"
#import "Joystick.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, SM3DAR_Delegate, CLLocationManagerDelegate, SearchDelegate> {
	SystemSoundID focusSound;
	NSString *searchQuery;
    YahooLocalSearch *search;
    BOOL sm3darInitialized;
    FlipsideViewController *flipsideController;
    Joystick *joystick;
    Coord3D cameraOffset;
    
    IBOutlet UIView *hudView;
    IBOutlet UIView *centerMenu;
    IBOutlet UILabel *poiTitle;
    IBOutlet UILabel *poiSubtitle;
    IBOutlet UILabel *poiDistance;
    IBOutlet UIImageView *poiIcon;
    IBOutlet UIButton *searchButton;
    IBOutlet UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) NSString *searchQuery;
@property (nonatomic, retain) YahooLocalSearch *search;
@property (nonatomic, retain) FlipsideViewController *flipsideController;

- (void)loadPointsOfInterest;
- (void)initSound;
- (void)playFocusSound;
- (void)loadPointsOfInterestFromMarkersFile;
- (void)runLocalSearch:(NSString*)query;
- (IBAction)showFlipside;
- (void)addDirectionBillboardsWithFixtures;
@end

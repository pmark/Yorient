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

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, SM3DAR_Delegate> {
	SM3DAR_Controller *arController;
	IBOutlet UIButton *infoButton;
	SystemSoundID focusSound;
}

@property (nonatomic, retain) SM3DAR_Controller *arController;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;

- (IBAction)showInfo;
- (void)loadPointsOfInterest;
- (void)initSound;
- (void)playFocusSound;

@end

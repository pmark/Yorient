//
//  MainViewController.h
//  SM3DARViewer
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Bordertown Labs, LLC 2009. All rights reserved.
//

#import "AR3D_API.h" 
#import "ThreeDARController.h"
#import "FlipsideViewController.h"
#import "AudioToolbox/AudioServices.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, SM3DARDelegate> {
	ThreeDARController *arController;
	IBOutlet UIButton *infoButton;
	SystemSoundID focusSound;
}

@property (nonatomic, retain) ThreeDARController *arController;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;

- (IBAction)showInfo;
- (void)loadPointsOfInterest;
- (void)initSound;
- (void)playFocusSound;

@end

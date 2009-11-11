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

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	ThreeDARController *arController;
	IBOutlet UIButton *infoButton;
}

@property (nonatomic, retain) ThreeDARController *arController;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;

- (IBAction)showInfo;

@end

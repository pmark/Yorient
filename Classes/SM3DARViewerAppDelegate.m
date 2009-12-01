//
//  SM3DAR_ViewerAppDelegate.m
//  SM3DAR_Viewer
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Bordertown Labs, LLC 2009. All rights reserved.
//

#import "SM3DARViewerAppDelegate.h"
#import "MainViewController.h"

@implementation SM3DARViewerAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
  [application setStatusBarHidden:YES animated:NO];
	
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
	mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
	[window makeKeyAndVisible];
}


- (void)dealloc {
	[mainViewController release];
	[window release];
	[super dealloc];
}

@end

//
//  FlipsideViewController.h
//  SM3DAR_Viewer
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Bordertown Labs, LLC 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SM3DAR.h"

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <UISearchBarDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet UISearchBar *searchBar;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

- (IBAction)done;
- (void)runLocalSearch:(NSString*)query;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end


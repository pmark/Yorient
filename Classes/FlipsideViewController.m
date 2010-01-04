//
//  FlipsideViewController.m
//  SM3DAR_Viewer
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Bordertown Labs, LLC 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"

@implementation FlipsideViewController

@synthesize delegate, searchBar;


- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}

- (void)runSearch {
	((MainViewController*)self.delegate).searchQuery = self.searchBar.text;
	
	if ([self.searchBar.text length] != 0) {
		[self runLocalSearch:self.searchBar.text];	
	}
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (IBAction)done {
	[self runSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)bar {
	[bar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)bar {
	[self runSearch];
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

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.searchBar.text = ((MainViewController*)self.delegate).searchQuery;
}


- (void)dealloc {
	[searchBar release];
	[super dealloc];
}

- (void)runLocalSearch:(NSString*)query {
  MainViewController *c = (MainViewController*)self.delegate;
  [c runLocalSearch:query];
}


@end

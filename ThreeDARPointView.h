//
//  ThreeDARPointView.h
//  CoffeeCommuter
//
//  Created by P. Mark Anderson on 10/27/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreeDARPointOfInterest.h"

@interface ThreeDARPointView : UIView {
	ThreeDARPointOfInterest *poi;
}

@property (nonatomic, retain) ThreeDARPointOfInterest *poi;

- (void)addTitle;

@end

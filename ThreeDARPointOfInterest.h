//
//  ThreeDARPointOfInterest.h
//  CoffeeCommuter
//
//  Created by P. Mark Anderson on 10/26/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AR3D_API.h"

@interface ThreeDARPointOfInterest : CLLocation {
//	CLLocation *geoLocation;
	NSString *title;
	NSString *subtitle;
	NSURL *dataURL;

	UIView *view;
	Coord3D worldPoint;
}

//@property (nonatomic, retain) CLLocation *geoLocation;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSURL *dataURL;
@property (nonatomic, retain) UIView *view;
@property (assign) Coord3D worldPoint;

- (UIView*)defaultView;
- (id)initWithLocation:(CLLocation*)loc title:(NSString*)title subtitle:(NSString*)subtitle url:(NSURL*)url;
- (float)distanceInMiles;
- (NSString*)formattedDistanceInMiles;
//- (void)setLocation:(CLLocation*)newLocation;

@end

//
//  ThreeDARController.h
//  CoffeeCommuter
//
//  Created by P. Mark Anderson on 10/26/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AR3D_API.h"
#import "StdMath.h"
#import "ThreeDARPointOfInterest.h"
#include <QuartzCore/QuartzCore.h>

@protocol ThreeDARDelegate
- (UIView *)viewForCoordinate:(ThreeDARPointOfInterest*)poi;

@end


@interface ThreeDARController : UIViewController <UIAccelerometerDelegate, CLLocationManagerDelegate> {
	CLLocation *currentLocation;
	CLLocationManager *locationManager; 
	CLLocationDirection trueHeading;
	CLLocationDirection magneticHeading;
	CLLocationManager *locationDelegate;
	UIAccelerometer *accelerometerDelegate;
//	NSObject<ThreeDARDelegate> *delegate;
	
	//ARCoordinate *centerCoordinate;
	
	UIImagePickerController *cameraController;

	BOOL originInitialized;
	Coord3D currentPosition;
	Coord3D downVector;
	Coord3D northVector;		
	Coord3D lastDownVector;
	Coord3D lastNorthVector;
	
	NSMutableArray *pointsOfInterest;
	UILabel *statusLabel;
	UIImagePickerController *camera;
	
@private
	NSMutableDictionary *viewsForPointsOfInterest;
}

@property (nonatomic, retain) UIImagePickerController *camera;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) NSMutableArray *pointsOfInterest;
@property (nonatomic, retain) CLLocation *currentLocation;
//@property (nonatomic, assign) NSObject<ThreeDARDelegate> delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationDirection trueHeading;
@property (nonatomic, assign) CLLocationDirection magneticHeading;
@property (nonatomic, assign) Coord3D currentPosition;
@property (nonatomic, assign) Coord3D downVector;
@property (nonatomic, assign) Coord3D northVector;
@property (nonatomic, assign) Coord3D lastDownVector;
@property (nonatomic, assign) Coord3D lastNorthVector;
@property (assign) BOOL originInitialized;
@property (nonatomic, retain) NSMutableDictionary *viewsForPointsOfInterest;

- (void)AR3DDidInitialize;
- (void)addPointOfInterest:(ThreeDARPointOfInterest*)point;
- (UIView *)viewForCoordinate:(ThreeDARPointOfInterest*)poi;
- (void)updateCamera;
- (void)displayPoint:(ThreeDARPointOfInterest*)poi;
- (void)startCamera;

@end

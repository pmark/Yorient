//
//  ThreeDARController.h
//  CoffeeCommuter
//
//  Created by P. Mark Anderson on 10/26/09.
//  Copyright 2009 Spot Metrix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AR3D_API.h"
#import "StdMath.h"
#import "ThreeDARPointOfInterest.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
 
@protocol SM3DARDelegate
-(void)loadPointsOfInterest;
-(void)didChangeFocusToPOI:(ThreeDARPointOfInterest*)newPOI fromPOI:(ThreeDARPointOfInterest*)oldPOI;
-(void)didChangeSelectionToPOI:(ThreeDARPointOfInterest*)newPOI fromPOI:(ThreeDARPointOfInterest*)oldPOI;
@end


@interface ThreeDARController : UIViewController <UIAccelerometerDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
	CLLocationManager *locationManager; 
	CLLocationDirection trueHeading;
	CLLocationDirection magneticHeading;
	CLLocationManager *locationDelegate;
	UIAccelerometer *accelerometerDelegate;
	NSObject<SM3DARDelegate> *delegate;
	
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
	MKMapView *map;
	
@private
	NSMutableDictionary *viewsForPointsOfInterest;
}

@property (nonatomic, retain) MKMapView *map;
@property (nonatomic, retain) UIImagePickerController *camera;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) NSMutableArray *pointsOfInterest;
@property (nonatomic, assign) NSObject<SM3DARDelegate> *delegate;
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
- (CLLocation*)currentLocation;
- (void)initMap;
- (void)toggleMap;
- (void)showMap;
- (void)hideMap;
- (void)zoomMapToFit;
- (void)setCurrentMapLocation:(CLLocation *)location;
- (void)annotateMap;

@end

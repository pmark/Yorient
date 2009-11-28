/*
 *  SM3DAR_.h
 *  SM3DAR_Libary
 *
 *  Created by P. Mark Anderson on 11/27/09.
 *  Copyright 2009 Spot Metrix, Inc. All rights reserved.
 *
 *  This is the developer's API.
 */

#import <MapKit/MapKit.h>


@class SM3DAR_PointOfInterest;		
@class SM3DAR_Session;

@protocol SM3DAR_Delegate
-(void)loadPointsOfInterest;
-(void)didChangeFocusToPOI:(SM3DAR_PointOfInterest*)newPOI fromPOI:(SM3DAR_PointOfInterest*)oldPOI;
-(void)didChangeSelectionToPOI:(SM3DAR_PointOfInterest*)newPOI fromPOI:(SM3DAR_PointOfInterest*)oldPOI;
@end

@interface SM3DAR_Controller : UIViewController <UIAccelerometerDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
	BOOL mapIsVisible;	
	BOOL originInitialized;
	MKMapView *map;	
	UILabel *statusLabel;
	UIImagePickerController *camera;
	NSObject<SM3DAR_Delegate> *delegate;
	NSMutableArray *pointsOfInterest;
	SM3DAR_PointOfInterest *focusedPOI;
	SM3DAR_PointOfInterest *selectedPOI;
}

@property (assign) BOOL mapIsVisible;
@property (assign) BOOL originInitialized;
@property (nonatomic, retain) MKMapView *map;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UIImagePickerController *camera;
@property (nonatomic, assign) NSObject<SM3DAR_Delegate> *delegate;
@property (nonatomic, retain) NSMutableDictionary *pointsOfInterest;
@property (nonatomic, retain) SM3DAR_PointOfInterest *focusedPOI;
@property (nonatomic, retain) SM3DAR_PointOfInterest *selectedPOI;

- (void)addPointOfInterest:(SM3DAR_PointOfInterest*)point;
- (UIView *)viewForCoordinate:(SM3DAR_PointOfInterest*)poi;
- (BOOL)displayPoint:(SM3DAR_PointOfInterest*)poi;
- (CLLocation*)currentLocation;
- (void)startCamera;

// map
- (void)initMap;
- (void)toggleMap;
- (void)showMap;
- (void)hideMap;
- (void)zoomMapToFit;
- (void)setCurrentMapLocation:(CLLocation *)location;
- (void)fadeMapToAlpha:(CGFloat)alpha;
- (BOOL)setMapVisibility;
- (void)annotateMap;
@end


@class SM3DAR_Controller;
@interface SM3DAR_PointOfInterest : CLLocation <MKAnnotation> {
	NSString *title;
	NSString *subtitle;
	NSURL *dataURL;
	BOOL hasFocus;
	NSObject<SM3DAR_Delegate> *delegate;
	UIView *view;
	SM3DAR_Controller *controller;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSURL *dataURL;
@property (nonatomic, assign) NSObject<SM3DAR_Delegate> *delegate;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) SM3DAR_Controller *controller;
@property (assign) BOOL hasFocus;

- (UIView*)defaultView;
- (id)initWithLocation:(CLLocation*)loc title:(NSString*)title subtitle:(NSString*)subtitle url:(NSURL*)url;
- (NSString*)formattedDistanceInMilesFrom:(CLLocation*)otherPoint;
- (NSString*)formattedDistanceInMilesFromCurrentLocation;
- (CGFloat)distanceInMilesFrom:(CLLocation*)otherPoint;
- (CGFloat)distanceInMilesFromCurrentLocation;
- (BOOL)isInView:(CGPoint*)point;
@end

@interface SM3DAR_Session : NSObject {
	CLLocation *currentLocation;
	CGFloat nearClipMeters;
	CGFloat farClipMeters;
}

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) CGFloat nearClipMeters;
@property (nonatomic, assign) CGFloat farClipMeters;

+ (SM3DAR_Session*)sharedSM3DAR_Session;
@end




/*
 *  SM3DAR.h
 *  SM3DARLibary
 *
 *  Created by P. Mark Anderson on 11/27/09.
 *  Copyright 2009 Spot Metrix, Inc. All rights reserved.
 *
 *  This is the developer's API.
 */

#import <MapKit/MapKit.h>


@class ThreeDARPointOfInterest;		
@class SM3DARSession;

@protocol SM3DAR_Delegate
-(void)loadPointsOfInterest;
-(void)didChangeFocusToPOI:(ThreeDARPointOfInterest*)newPOI fromPOI:(ThreeDARPointOfInterest*)oldPOI;
-(void)didChangeSelectionToPOI:(ThreeDARPointOfInterest*)newPOI fromPOI:(ThreeDARPointOfInterest*)oldPOI;
@end

@interface ThreeDARController : UIViewController <UIAccelerometerDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
	BOOL mapIsVisible;	
	BOOL originInitialized;
	MKMapView *map;	
	UILabel *statusLabel;
	UIImagePickerController *camera;
	NSObject<SM3DAR_Delegate> *delegate;
	NSMutableArray *pointsOfInterest;
	ThreeDARPointOfInterest *focusedPOI;
	ThreeDARPointOfInterest *selectedPOI;
}

@property (assign) BOOL mapIsVisible;
@property (assign) BOOL originInitialized;
@property (nonatomic, retain) MKMapView *map;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UIImagePickerController *camera;
@property (nonatomic, assign) NSObject<SM3DAR_Delegate> *delegate;
@property (nonatomic, retain) NSMutableDictionary *pointsOfInterest;
@property (nonatomic, retain) ThreeDARPointOfInterest *focusedPOI;
@property (nonatomic, retain) ThreeDARPointOfInterest *selectedPOI;

- (void)addPointOfInterest:(ThreeDARPointOfInterest*)point;
- (UIView *)viewForCoordinate:(ThreeDARPointOfInterest*)poi;
- (BOOL)displayPoint:(ThreeDARPointOfInterest*)poi;
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


@class ThreeDARController;
@interface ThreeDARPointOfInterest : CLLocation <MKAnnotation> {
	NSString *title;
	NSString *subtitle;
	NSURL *dataURL;
	BOOL hasFocus;
	NSObject<SM3DAR_Delegate> *delegate;
	UIView *view;
	ThreeDARController *controller;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSURL *dataURL;
@property (nonatomic, assign) NSObject<SM3DAR_Delegate> *delegate;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) ThreeDARController *controller;
@property (assign) BOOL hasFocus;

- (UIView*)defaultView;
- (id)initWithLocation:(CLLocation*)loc title:(NSString*)title subtitle:(NSString*)subtitle url:(NSURL*)url;
- (NSString*)formattedDistanceInMilesFrom:(CLLocation*)otherPoint;
- (NSString*)formattedDistanceInMilesFromCurrentLocation;
- (CGFloat)distanceInMilesFrom:(CLLocation*)otherPoint;
- (CGFloat)distanceInMilesFromCurrentLocation;
- (BOOL)isInView:(CGPoint*)point;
@end

@interface SM3DARSession : NSObject {
	CLLocation *currentLocation;
	CGFloat nearClipMeters;
	CGFloat farClipMeters;
}

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) CGFloat nearClipMeters;
@property (nonatomic, assign) CGFloat farClipMeters;

+ (SM3DARSession*)sharedSM3DARSession;
@end




//
//  MainViewController.h
//  Yorient
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Spot Metrix, Inc 2009. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SM3DAR.h" 
#import "AudioToolbox/AudioServices.h"
#import "YahooLocalSearch.h"
#import <MapKit/MapKit.h>

@interface MainViewController : UIViewController <MKMapViewDelegate, SM3DAR_Delegate, CLLocationManagerDelegate, SearchDelegate> 
{
	SystemSoundID focusSound;
	NSString *searchQuery;
    YahooLocalSearch *search;
    BOOL sm3darInitialized;
    UIView *focusedMarker;

    IBOutlet SM3DARMapView *mapView;
    IBOutlet UIView *hudView;
    IBOutlet UIActivityIndicatorView *spinner;
    
}

@property (nonatomic, retain) NSString *searchQuery;
@property (nonatomic, retain) YahooLocalSearch *search;
@property (nonatomic, retain) IBOutlet SM3DARMapView *mapView;

- (void)initSound;
- (void)playFocusSound;
- (void)runLocalSearch:(NSString*)query;
//- (void)addDirectionBillboardsWithFixtures;

@end

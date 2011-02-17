//
//  MainViewController.m
//  Yorient
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Spot Metrix, Inc 2009. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MainViewController.h"
#import "NSArray+BSJSONAdditions.h"
#import "BubbleMarkerView.h"
#import "CGPointUtil.h"
#import "FlatGridView.h"
#import "RoundedLabelMarkerView.h"
#import "Constants.h"

@implementation MainViewController

@synthesize searchQuery;
@synthesize search;
@synthesize flipsideController;

- (void)dealloc {
	[searchQuery release];
    [search release];
    [flipsideController release];
    [joystick release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {      
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
    
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];

    if (![sm3dar.view superview]) 
    {

        [self.view addSubview:sm3dar.view];
        
        [sm3dar startCamera];
    }
}

- (void) decorateMap
{
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [SM3DAR.map addSubview:spinner];
    
    [SM3DAR.view bringSubviewToFront:SM3DAR.map];
}

- (void) clearFocus
{
    poiTitle.text = nil;
    poiSubtitle.text = nil;
    poiDistance.text = nil;
}

- (void) viewDidLoad 
{
	[super viewDidLoad];

    [self initSound];
    self.view.backgroundColor = [UIColor blackColor];
    
	SM3DAR_Controller *sm3dar = SM3DAR;
    sm3dar.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	sm3dar.delegate = self;
    sm3dar.focusView = nil;
    sm3dar.hudView = hudView;
    sm3dar.markerViewClass = [BubbleMarkerView class];
    sm3dar.map.alpha = 0.0;

    centerMenu.hidden = YES;
    hudView.hidden = NO;

    [self clearFocus];
    
    CALayer *l = centerMenu.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:7.0];
    [l setBorderWidth:2.0];
    [l setBorderColor:[[UIColor darkGrayColor] CGColor]];

    [self.view insertSubview:sm3dar.view atIndex:0];
    [self.view addSubview:sm3dar.iconLogo];

    
    // Search screen
    
    self.search = [[[YahooLocalSearch alloc] init] autorelease];
    search.delegate = self;
    
    FlipsideViewController *flipside = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    flipside.delegate = self;	
    flipside.view.hidden = YES;
    [self.view addSubview:flipside.view];
    self.flipsideController = flipside;
    [flipside release];

}

- (void) addJoystick
{
    joystick = [[Joystick alloc] initWithBackground:[UIImage imageNamed:@"128_white.png"]];
    joystick.center = CGPointMake(160, 406);
    
    [SM3DAR.hudView addSubview:joystick];
    [NSTimer scheduledTimerWithTimeInterval:0.10f target:self selector:@selector(updateJoystick) userInfo:nil repeats:YES];    
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller 
{
    flipsideController.view.hidden = YES;
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
    sm3dar.view.hidden = NO;
    [sm3dar resume];
}

- (IBAction)showFlipside 
{
    SM3DAR.view.hidden = YES;
    
    [self.view bringSubviewToFront:flipsideController.view];
    
    CGFloat duration = 0.4f;
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.duration = duration;
    [flipsideController.view.layer addAnimation:transition forKey:nil];
    flipsideController.view.hidden = NO;
    [flipsideController.searchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:duration];  
}

- (void)runLocalSearch:(NSString*)query 
{
    [self clearFocus];
    
    centerMenu.hidden = YES;
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [spinner startAnimating];

	self.searchQuery = query;
    [SM3DAR removeAllPointsOfInterest:NO];
    [self.search execute:query];
}

- (void)didReceiveMemoryWarning 
{
    NSLog(@"\n\ndidReceiveMemoryWarning\n\n");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    NSLog(@"viewDidUnload");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Data loading
- (void) addFlatGrid
{
    SM3DAR_Fixture *fixture = [[SM3DAR_Fixture alloc] init];
    
    FlatGridView *grid = [[FlatGridView alloc] init];
    
    grid.point = fixture;
    fixture.view = grid;
    
    Coord3D coord;
    coord.x = 0;
    coord.y = 0;
    coord.z = 0;
    
    fixture.worldPoint = coord;
    
    [SM3DAR addPoint:fixture];
    
    [grid release];
    [fixture release];
}

-(void)loadPointsOfInterest 
{
    // 3DAR initialization is complete
    
    [self addFlatGrid];    

    [self addDirectionBillboardsWithFixtures];

    self.searchQuery = @"pizza";
    [self.search execute:searchQuery];    
}

-(void)loadPointsOfInterestFromMarkersFile {
    SM3DAR.markerViewClass = nil;
	[SM3DAR loadMarkersFromJSONFile:@"markers"];
}

- (void) focusedMarkerAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if (context)
    {
        ((UIView*)context).alpha = 1.0;
    }
}

- (void) animateFocusedMarker
{
/*
    [UIView animateWithDuration:1.0 
                          delay:0.0
                        options:0
//     UIViewAnimationOptionAutoreverse |
//     UIViewAnimationOptionRepeat
                     animations: 
                            ^{
                                focusedMarker.alpha = 0.15;
                            }
                     completion:^(BOOL finished)
                            {
                            }];
*/
    
    focusedMarker.alpha = 1.0;
    
    [UIView beginAnimations:@"focusedMarkerAnim" context:focusedMarker];
    [UIView setAnimationDuration:0.66];    
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(focusedMarkerAnimationDidStop:finished:context:)];
    
    focusedMarker.alpha = 0.15;
    
    [UIView commitAnimations];
}

- (void) focusedMarkerAnimationDidStop
{
    if (focusedMarker && ![SM3DAR mapIsVisible])
    {
        [self animateFocusedMarker];
    }
} 
     
-(void)didChangeFocusToPOI:(SM3DAR_PointOfInterest*)newPOI fromPOI:(SM3DAR_PointOfInterest*)oldPOI {

    if (SM3DAR.view.hidden)
        return;
    
	[self playFocusSound];

    SM3DAR_IconMarkerView *newMarker = (SM3DAR_IconMarkerView *)newPOI.view;
    SM3DAR_IconMarkerView *oldMarker = (SM3DAR_IconMarkerView *)oldPOI.view;
    
//    [oldMarker.layer removeAllAnimations];
//    oldMarker.alpha = 1.0;

    newMarker.icon.image = [UIImage imageNamed:@"bubble3.png"];
    oldMarker.icon.image = [UIImage imageNamed:@"bubble1.png"];
    
    focusedMarker = newMarker;

    poiIcon.image = newMarker.icon.image;
    poiTitle.text = newPOI.title;
    poiSubtitle.text = newPOI.subtitle;
    poiDistance.text = [NSString stringWithFormat:@"%@ mi", 
                        [newPOI formattedDistanceInMilesFromCurrentLocation]];
    

    [self animateFocusedMarker];
}

-(void)didChangeSelectionToPOI:(SM3DAR_PointOfInterest*)newPOI fromPOI:(SM3DAR_PointOfInterest*)oldPOI {
	NSLog(@"POI was selected: %@", newPOI.title);
}

#pragma mark Sound
- (void)initSound {
	CFBundleRef mainBundle = CFBundleGetMainBundle();
	CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR ("focus2"), CFSTR ("aif"), NULL) ;
	AudioServicesCreateSystemSoundID(soundFileURLRef, &focusSound);
}

- (void)playFocusSound {
	AudioServicesPlaySystemSound(focusSound);
} 

#pragma mark -

-(void)logoWasTapped 
{
    hudView.hidden = !hudView.hidden;
    centerMenu.hidden = !centerMenu.hidden;    
    
    if ([SM3DAR mapIsVisible])
    {
        // Map will be hidden.

        [hudView addSubview:spinner];

    }
    else
    {
        // Map will be shown.

        [self decorateMap];
        
    }

    [SM3DAR toggleMap];
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation 
{
//    [SM3DAR debug:[NSString stringWithFormat:@" X %0.1f     Y %0.1f ", 
//                   SM3DAR.currentPosition.x, SM3DAR.currentPosition.y]];
}

#pragma mark -

- (void) updateJoystick 
{
    [joystick updateThumbPosition];
    
    CGFloat s = 6.2; // 4.6052;
    
    CGFloat xspeed =  joystick.velocity.x * exp(fabs(joystick.velocity.x) * s);
    CGFloat yspeed = -joystick.velocity.y * exp(fabs(joystick.velocity.y) * s);
    
    
    if (abs(xspeed) > 0.0 || abs(yspeed) > 0.0) 
    {        
        Coord3D ray = [SM3DAR ray:CGPointMake(160, 240)];
        
        cameraOffset.x += (ray.x * yspeed);
        cameraOffset.y += (ray.y * yspeed);
        //cameraOffset.z += (ray.z * yspeed);
        
        CGPoint perp = [CGPointUtil perpendicularCounterClockwise:CGPointMake(ray.x, ray.y)];        
        cameraOffset.x += (perp.x * xspeed);
        cameraOffset.y += (perp.y * xspeed);
        
        //NSLog(@"Camera (%.1f, %.1f, %.1f)", offset.x, offset.y, offset.z);

        [SM3DAR setCameraOffset:cameraOffset];
    }
}

#pragma mark -

- (SM3DAR_Fixture*) addFixtureWithView:(SM3DAR_PointView*)pointView
{
    SM3DAR_Fixture *point = [[SM3DAR_Fixture alloc] init];
    
    point.view = pointView;  
    
    pointView.point = point;
    
    return [point autorelease];
}

- (SM3DAR_Fixture*) addLabelFixture:(NSString*)title subtitle:(NSString*)subtitle coord:(Coord3D)coord
{
    RoundedLabelMarkerView *v = [[RoundedLabelMarkerView alloc] initWithTitle:title subtitle:subtitle];

    SM3DAR_Fixture *fixture = [self addFixtureWithView:v];
    [v release];    
    
    fixture.worldPoint = coord;
    
    [SM3DAR addPoint:fixture];

    return fixture;
}

- (void) addDirectionBillboardsWithFixtures
{
    Coord3D origin = {
        0, 0, DIRECTION_BILLBOARD_ALTITUDE_METERS
    };    
    
    Coord3D north, south, east, west;
    
    north = south = east = west = origin;
    
    CGFloat range = 5000.0;    
    
    north.y += range;
    south.y -= range;
    east.x += range;
    west.x -= range;
    
    [self addLabelFixture:@"N" subtitle:@"" coord:north];
    [self addLabelFixture:@"S" subtitle:@"" coord:south];
    [self addLabelFixture:@"E" subtitle:@"" coord:east];
    [self addLabelFixture:@"W" subtitle:@"" coord:west];
}

- (void) searchDidFinishWithEmptyResults
{
    [spinner stopAnimating];
}

- (void) searchDidFinishWithResults
{
    [spinner stopAnimating];

    if (![SM3DAR mapIsVisible])
    {
        centerMenu.hidden = NO;
    }    
}

@end

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

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];

    if (![sm3dar.view superview]) {

        [self.view addSubview:sm3dar.view];
        
//        [sm3dar startCamera];
    }
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [self initSound];
    self.view.backgroundColor = [UIColor blackColor];
    
	SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
	sm3dar.delegate = self;
    sm3dar.markerViewClass = [BubbleMarkerView class];    
    sm3dar.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    self.search = [[[YahooLocalSearch alloc] init] autorelease];
    
    FlipsideViewController *flipside = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    flipside.delegate = self;	
    flipside.view.hidden = YES;
    [self.view addSubview:flipside.view];
    self.flipsideController = flipside;
    [flipside release];  

    
    // HUD

    sm3dar.hudView = [[[UIView alloc] initWithFrame:sm3dar.view.frame] autorelease];
    [sm3dar.view addSubview:sm3dar.hudView];
    
    
    // Joystick
    
    joystick = [[Joystick alloc] initWithBackground:[UIImage imageNamed:@"128_white.png"]];
    joystick.center = CGPointMake(160, 406);
    
    [sm3dar.hudView addSubview:joystick];
    [NSTimer scheduledTimerWithTimeInterval:0.10f target:self selector:@selector(updateJoystick) userInfo:nil repeats:YES];    
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    flipsideController.view.hidden = YES;
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
    sm3dar.view.hidden = NO;
    [sm3dar resume];
}

- (IBAction)showFlipside {
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
    [sm3dar suspend];    
    sm3dar.view.hidden = YES;
    
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

- (void)runLocalSearch:(NSString*)query {
	self.searchQuery = query;
    [[SM3DAR_Controller sharedController] removeAllPointsOfInterest];
    [self.search execute:query];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"\n\ndidReceiveMemoryWarning\n\n");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
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

-(void)loadPointsOfInterest {
    // 3DAR initialization is complete
    
    [self addFlatGrid];    

    [self addDirectionBillboardsWithFixtures];

    self.searchQuery = @"cafe";
    [self.search execute:searchQuery];    
    
}

-(void)loadPointsOfInterestFromMarkersFile {
    SM3DAR.markerViewClass = nil;
	[SM3DAR loadMarkersFromJSONFile:@"markers"];
}

-(void)didChangeFocusToPOI:(SM3DAR_PointOfInterest*)newPOI fromPOI:(SM3DAR_PointOfInterest*)oldPOI {
	//NSLog(@"POI acquired focus: %@", newPOI.title);
	[self playFocusSound];
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
-(void)logoWasTapped {
//    [self showFlipside];

    
    self.searchQuery = @"cafe";
    [self.search execute:searchQuery];


}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation 
{
    [manager stopUpdatingLocation];
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
        0, 0, 0
    };    
    
    Coord3D north, south, east, west;
    
    north = south = east = west = origin;
    
    CGFloat range = 8000.0;    
    
    north.y += range;
    south.y -= range;
    east.x += range;
    west.x -= range;
    
    [self addLabelFixture:@"N" subtitle:@"" coord:north];
    [self addLabelFixture:@"S" subtitle:@"" coord:south];
    [self addLabelFixture:@"E" subtitle:@"" coord:east];
    [self addLabelFixture:@"W" subtitle:@"" coord:west];
}

@end
